import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftParser

final class ModifierVisitor: SyntaxVisitor {
    var modifiers = [String: [(FunctionDeclSyntax, availability: (AvailabilityArgumentListSyntax, Set<String>))]]()
    var deprecations = [String: String]()

    static let minimumAvailability = [
        "iOS": VersionTupleSyntax(major: .integerLiteral("16"), components: VersionComponentListSyntax([VersionComponentSyntax(number: .integerLiteral("0"))])),
        "macOS": VersionTupleSyntax(major: .integerLiteral("13"), components: VersionComponentListSyntax([VersionComponentSyntax(number: .integerLiteral("0"))])),
        "watchOS": VersionTupleSyntax(major: .integerLiteral("9"), components: VersionComponentListSyntax([VersionComponentSyntax(number: .integerLiteral("0"))])),
        "tvOS": VersionTupleSyntax(major: .integerLiteral("16"), components: VersionComponentListSyntax([VersionComponentSyntax(number: .integerLiteral("0"))])),
        "visionOS": VersionTupleSyntax(major: .integerLiteral("1"), components: VersionComponentListSyntax([VersionComponentSyntax(number: .integerLiteral("0"))])),
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
        let isDeprecated = !nodeAvailabilityAttributes.isEmpty && nodeAvailabilityAttributes.allSatisfy({
            $0.contains(where: {
                $0.argument.as(AvailabilityLabeledArgumentSyntax.self)?.label.tokenKind == .keyword(.deprecated)
                || $0.argument.as(TokenSyntax.self)?.tokenKind == .keyword(.unavailable)
            })
        })

        let ifConfigMembers = node.memberBlock.members.reduce(into: [], { prev, next in
            prev.append(contentsOf: next.decl.as(IfConfigDeclSyntax.self)?.clauses.reduce(into: [], { prev, next in
                prev.append(contentsOf: next.elements?.as(MemberBlockItemListSyntax.self).flatMap(Array.init) ?? [])
            }) ?? [])
        })
        for member in Array(node.memberBlock.members) + ifConfigMembers {
            // find extensions on `SwiftUI.View`
            guard let decl = member.decl.as(FunctionDeclSyntax.self),
                  decl.modifiers.contains(where: { $0.name.tokenKind == .keyword(.public) }),
                  let returnType = decl.signature.returnClause?.type.as(SomeOrAnyTypeSyntax.self)?.constraint.as(MemberTypeSyntax.self),
                  returnType.baseType.as(IdentifierTypeSyntax.self)?.name.tokenKind == .identifier("SwiftUI"),
                  returnType.name.tokenKind == .identifier("View")
            else { continue }
            let memberAvailabilityAttributes = decl.attributes.compactMap({ $0.as(AttributeSyntax.self)?.arguments?.as(AvailabilityArgumentListSyntax.self) })
            let isMemberDeprecated = memberAvailabilityAttributes.contains(where: {
                $0.contains(where: {
                    $0.argument.as(AvailabilityLabeledArgumentSyntax.self)?.label.tokenKind == .keyword(.deprecated)
                })
            })
            if isMemberDeprecated || isDeprecated {
                // extract the deprecation message.
                self.deprecations[decl.name.trimmed.text] = (isMemberDeprecated ? memberAvailabilityAttributes : nodeAvailabilityAttributes)
                    .lazy
                    .compactMap({ (attribute) -> String? in
                        guard attribute.contains(where: {
                            $0.argument.as(AvailabilityLabeledArgumentSyntax.self)?.label.tokenKind == .keyword(.deprecated)
                        })
                        else { return nil }
                        return attribute.lazy.compactMap({ (argument) -> String? in
                            guard let argument = argument.argument.as(AvailabilityLabeledArgumentSyntax.self),
                                  argument.label.tokenKind == .keyword(.message) || argument.label.tokenKind == .keyword(.renamed)
                            else { return nil }
                            if argument.label.tokenKind == .keyword(.renamed),
                               let value = argument.value.as(SimpleStringLiteralExprSyntax.self)
                            {
                                return #""renamed to `\#(value.segments.description)`""#
                            } else {
                                return argument.value.description
                            }
                        }).first
                    }).first ?? #""This symbol is unavailable and will have no effect""#
            } else {
                self.modifiers[decl.name.trimmed.text, default: []].append((decl, availability: Self.availability(node.attributes, decl.attributes)))
            }
        }

        return .skipChildren
    }
}
