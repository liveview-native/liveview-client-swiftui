import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftParser

final class ModifierVisitor: SyntaxVisitor {
    var modifiers = [String: [(FunctionDeclSyntax, availability: (AvailabilityArgumentListSyntax, Set<String>))]]()

    static let minimumAvailability = [
        "iOS": VersionTupleSyntax(major: .integerLiteral("16"), components: VersionComponentListSyntax([VersionComponentSyntax(number: .integerLiteral("0"))])),
        "macOS":  VersionTupleSyntax(major: .integerLiteral("13"), components: VersionComponentListSyntax([VersionComponentSyntax(number: .integerLiteral("0"))])),
        "watchOS":  VersionTupleSyntax(major: .integerLiteral("9"), components: VersionComponentListSyntax([VersionComponentSyntax(number: .integerLiteral("0"))])),
        "tvOS":  VersionTupleSyntax(major: .integerLiteral("16"), components: VersionComponentListSyntax([VersionComponentSyntax(number: .integerLiteral("0"))])),
        "visionOS":  VersionTupleSyntax(major: .integerLiteral("1"), components: VersionComponentListSyntax([VersionComponentSyntax(number: .integerLiteral("0"))])),
    ]

    static func availability(_ base: AttributeListSyntax, _ decl: AttributeListSyntax) -> (AvailabilityArgumentListSyntax, Set<String>) {
        var availability = [String:PlatformVersionSyntax]()
        var unavailable = Set<String>()

        for attribute in base.lazy.compactMap({ $0.as(AttributeSyntax.self)?.arguments?.as(AvailabilityArgumentListSyntax.self) }) {
            for argument in attribute.lazy.compactMap({ $0.argument.as(PlatformVersionSyntax.self) }) {
                availability[argument.platform.text] = argument
            }
        }
        for attribute in decl.lazy.compactMap({ $0.as(AttributeSyntax.self)?.arguments?.as(AvailabilityArgumentListSyntax.self) }) {
            for argument in attribute {
                if let platformVersion = argument.argument.as(PlatformVersionSyntax.self) {
                    availability[platformVersion.platform.text] = platformVersion
                } else if argument.argument.as(TokenSyntax.self)?.tokenKind == .keyword(.unavailable),
                          let platform = attribute.first?.argument.as(TokenSyntax.self)?.text {
                    unavailable.insert(platform)
                }
            }
        }

        if unavailable.isEmpty && availability.values.allSatisfy({
            if let version = $0.version {
                guard let minimum = Self.minimumAvailability[$0.platform.text]
                else { return false }
                return version <= minimum
            } else {
                return true
            }
        }) && Set(["iOS", "macOS", "watchOS", "tvOS"]).isSubset(of: Set(availability.values.map(\.platform.text))) {
            return (
                AvailabilityArgumentListSyntax([]),
                unavailable
            )
        }
        
        return (
            AvailabilityArgumentListSyntax {
                for value in availability.values {
                    AvailabilityArgumentSyntax(argument: .init(value))
                }
            },
            unavailable
        )
    }

    override func visit(_ node: ExtensionDeclSyntax) -> SyntaxVisitorContinueKind {
        guard node.extendedType.trimmed.description == "SwiftUI.View" else { return .skipChildren }
        guard let extendedType = node.extendedType.as(MemberTypeSyntax.self),
              extendedType.baseType.as(IdentifierTypeSyntax.self)?.name.tokenKind == .identifier("SwiftUI"),
              extendedType.name.tokenKind == .identifier("View"),
              node.genericWhereClause == nil
        else { return .skipChildren }

        let nodeAvailabilityAttributes = node.attributes.compactMap({ $0.as(AttributeSyntax.self)?.arguments?.as(AvailabilityArgumentListSyntax.self) })

        // if all platforms mark this symbol as deprecated, exclude it.
        if !nodeAvailabilityAttributes.isEmpty && nodeAvailabilityAttributes.allSatisfy({
            $0.contains(where: {
                $0.argument.as(AvailabilityLabeledArgumentSyntax.self)?.label.tokenKind == .keyword(.deprecated)
                || $0.argument.as(TokenSyntax.self)?.tokenKind == .keyword(.unavailable)
            })
        }) {
            return .skipChildren
        }

        for member in node.memberBlock.members {
            // find extensions on `SwiftUI.View`
            guard let decl = member.decl.as(FunctionDeclSyntax.self),
                  decl.modifiers.contains(where: { $0.name.tokenKind == .keyword(.public) }),
                  let returnType = decl.signature.returnClause?.type.as(SomeOrAnyTypeSyntax.self)?.constraint.as(MemberTypeSyntax.self),
                  returnType.baseType.as(IdentifierTypeSyntax.self)?.name.tokenKind == .identifier("SwiftUI"),
                  returnType.name.tokenKind == .identifier("View"),
                  // exclude deprecated modifiers
                  !decl.attributes.contains(where: {
                    $0.as(AttributeSyntax.self)?.arguments?.as(AvailabilityArgumentListSyntax.self)?.contains(where: {
                        $0.argument.as(AvailabilityLabeledArgumentSyntax.self)?.label.tokenKind == .keyword(.deprecated)
                    }) ?? false
                })
            else { continue }
            self.modifiers[decl.name.trimmed.text, default: []].append((decl, availability: Self.availability(node.attributes, decl.attributes)))
        }

        return .skipChildren
    }
}