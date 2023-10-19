import ArgumentParser
import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftParser

@main
struct ModifierGenerator: ParsableCommand {
    @Argument(
        help: "The `.swiftinterface` file from `/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks/SwiftUI.framework/Modules/SwiftUI.swiftmodule/arm64-apple-ios.swiftinterface`",
        transform: { URL(filePath: $0) }
    )
    private var interface: URL

    static let allowlist = [
        // "bold",
        // "italic",
        // "background",
        // "overlay",
        "navigationTitle",
        "navigationBarTitleDisplayMode",
        // "position",
        // "offset",
        // "opacity",
        // "border",
        // "hidden",
    ]

    func run() throws {
        let source = try String(contentsOf: interface, encoding: .utf8)
        let sourceFile = Parser.parse(source: source)
        
        let visitor = ModifierVisitor(viewMode: SyntaxTreeViewMode.all)
        visitor.walk(sourceFile)

        var output = #"""
        // File generated with `swift run ModifierGenerator "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks/SwiftUI.framework/Modules/SwiftUI.swiftmodule/arm64-apple-ios.swiftinterface" > Sources/LiveViewNative/_GeneratedModifiers.swift`
        
        import SwiftUI
        import LiveViewNativeStylesheet


        """#
        for (modifier, signatures) in visitor.modifiers {
            guard Self.allowlist.contains(modifier)
            else {
                FileHandle.standardError.write(Data("`\(modifier)` will be skipped\n".utf8))
                continue
            }
            let signatures = signatures.enumerated().map(signature(_:_:))
            output.append(#"""
            @ParseableExpression
            struct _\#(modifier)Modifier<R: RootRegistry>: ViewModifier {
                static var name: String { "\#(modifier)" }

                enum Value {
            \#(signatures.map(\.case).joined(separator: "\n"))
                }

                let value: Value

                @ObservedElement private var element
                @LiveContext<R> private var context
            
            \#(signatures.compactMap(\.changeTracked).joined(separator: "\n"))

            \#(signatures.map(\.`init`).joined(separator: "\n"))

                func body(content __content: Content) -> some View {
                    switch value {
            \#(signatures.map(\.content).joined(separator: "\n"))
                    }
                }
            }

            """#)
        }

        output.append(#"""

        extension BuiltinRegistry {
            struct BuiltinModifier: ViewModifier, ParseableModifierValue {
                enum Storage {
                    \#(Self.allowlist.map({ "case \($0)(_\($0)Modifier<R>)" }).joined(separator: "\n"))
                }
                
                let storage: Storage
                
                init(_ storage: Storage) {
                    self.storage = storage
                }
                
                public func body(content: Content) -> some View {
                    switch storage {
                    \#(Self.allowlist.map({
                        """
                        case let .\($0)(modifier):
                            content.modifier(modifier)
                        """
                    }).joined(separator: "\n"))
                    }
                }
                
                public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
                    OneOf {
                        \#(Self.allowlist.map({ "_\($0)Modifier<R>.parser(in: context).map({ Self.init(.\($0)($0)) })" }).joined(separator: "\n"))
                    }
                }
            }
        }
        """#)

        FileHandle.standardOutput.write(Data(output.utf8))
    }

    struct Signature {
        let `init`: String
        let `case`: String
        let content: String
        let changeTracked: String?
    }

    func signature(_ offset: Int, _ declarationSyntax: (FunctionDeclSyntax, availability: (AvailabilityArgumentListSyntax, Set<String>))) -> Signature {
        let (decl, (availability, unavailable)) = declarationSyntax

        let generics = Dictionary(uniqueKeysWithValues: decl.genericParameterClause?.parameters.compactMap { (generic) -> (String, TypeSyntax)? in
            guard let rightType = decl.genericWhereClause?.requirements.first(where: {
                $0.requirement.as(ConformanceRequirementSyntax.self)?.leftType.as(IdentifierTypeSyntax.self)?.name.text == generic.name.text
            })?.requirement.as(ConformanceRequirementSyntax.self)?.rightType
            else { return nil }
            return (
                generic.name.text,
                rightType
            )
        } ?? [])
        let parameters = decl.signature.parameterClause.parameters.map({ parameter($0, generics: generics) })
        let caseParameters = parameters
            .map({ $0.secondName != nil ? $0.with(\.firstName, $0.secondName!).with(\.secondName, nil) : $0 })
        // Filter out `ChangeTracked` arguments.
        let changeTracked = caseParameters.filter({ $0.type.as(IdentifierTypeSyntax.self)?.name.text == "ChangeTracked" })
        let boundParameters = caseParameters.filter({ $0.type.as(IdentifierTypeSyntax.self)?.name.text != "ChangeTracked" })
        return Signature(
            init: #"""
                init(\#(FunctionParameterListSyntax(parameters).description)) {
                    self.value = ._\#(offset)\#(caseParameters.isEmpty ? "" : "(")\#(caseParameters.map({ "\($0.firstName.trimmed): \($0.firstName.trimmed)" }).joined(separator: ", "))\#(caseParameters.isEmpty ? "" : ")")
                    \#(changeTracked
                        .map({
                            #"self.__\#(offset)_\#(($0.secondName ?? $0.firstName).trimmed.description) = \#($0.secondName ?? $0.firstName)"#
                        })
                        .joined(separator: "\n")
                    )
                }
            """#,
            case: #"""
                    case _\#(offset)\#(caseParameters.isEmpty ? "" : "(")\#(FunctionParameterListSyntax(caseParameters).description)\#(caseParameters.isEmpty ? "" : ")")
            """#,
            content: #"""
                    \#(boundParameters.isEmpty ? "case ._\(offset)" : "case let ._\(offset)(\(boundParameters.map(\.firstName.trimmed.description).joined(separator: ", ")))"):
                        \#(availability.isEmpty ? "" : "if #available(\(availability), *) {")
                        __content
                            \#(unavailable.isEmpty ? "" : "#if \(unavailable.map({ "!os(\($0))" }).joined(separator: " && "))")
                            .\#(decl.name.trimmed.text)(\#(parameters.map({
                                switch $0.type.as(IdentifierTypeSyntax.self)?.name.text {
                                case "ViewReference":
                                    return $0.firstName.tokenKind == .wildcard ? "{ \($0.secondName!.text).resolve(on: element, in: context) }" : "\($0.firstName.text): { \(($0.secondName ?? $0.firstName).text).resolve(on: element, in: context) }"
                                case "TextReference":
                                    return $0.firstName.tokenKind == .wildcard ? "\($0.secondName!.text).resolve(on: element, in: context)" : "\($0.firstName.text): \(($0.secondName ?? $0.firstName).text).resolve(on: element, in: context)"
                                case "ChangeTracked":
                                    // These are registered on the View so they get proper DynamicProperty treatment.
                                    return $0.firstName.tokenKind == .wildcard ? "__\(offset)_\($0.secondName!.text).projectedValue" : "\($0.firstName.text): __\(offset)_\(($0.secondName ?? $0.firstName).text).projectedValue"
                                default:
                                    return $0.firstName.tokenKind == .wildcard ? $0.secondName!.text : "\($0.firstName.text): \(($0.secondName ?? $0.firstName).text)"
                                }
                            }).joined(separator: ", ")))
                            \#(unavailable.isEmpty ? "" : "#endif")
                        \#(availability.isEmpty ? "" : "} else { __content }")
            """#,
            changeTracked: changeTracked
                .map({
                    #"@ChangeTracked private var _\#(offset)_\#(($0.secondName ?? $0.firstName).trimmed.description): \#($0.type.as(IdentifierTypeSyntax.self)!.genericArgumentClause!.arguments.description)"#
                })
                .joined(separator: "\n")
        )
    }

    func parameter(_ parameter: FunctionParameterSyntax, generics: [String:TypeSyntax]) -> FunctionParameterSyntax {
        let isViewBuilder = parameter.attributes.contains(where: {
            guard let attributeType = $0.as(AttributeSyntax.self)?.attributeName.as(MemberTypeSyntax.self),
                  attributeType.baseType.as(IdentifierTypeSyntax.self)?.name.tokenKind == .identifier("SwiftUI"),
                  attributeType.name.tokenKind == .identifier("ViewBuilder")
            else { return false }
            return true
        })

        // generic types are replaced with `Any*` erasers
        let genericBaseType: TypeSyntax?
        if let identifierType = parameter.type.as(IdentifierTypeSyntax.self) ?? parameter.type.as(OptionalTypeSyntax.self)?.wrappedType.as(IdentifierTypeSyntax.self),
           let baseType = generics[identifierType.name.text]
        {
            if let member = baseType.as(MemberTypeSyntax.self) {
                genericBaseType = TypeSyntax("\(raw: member.name.text)")
            } else {
                genericBaseType = baseType
            }
        } else if let someType = parameter.type.as(SomeOrAnyTypeSyntax.self)?.constraint {
            if let member = someType.as(MemberTypeSyntax.self) {
                genericBaseType = TypeSyntax("\(raw: member.name.text)")
            } else {
                genericBaseType = someType
            }
        } else {
            genericBaseType = nil
        }

        if isViewBuilder {
            // nested View content is replaced with a `ViewReference`
            return parameter
                .with(\.type, TypeSyntax("ViewReference"))
                .with(\.attributes, AttributeListSyntax([]))
                .with(\.defaultValue, InitializerClauseSyntax(value: ExprSyntax(#"ViewReference(value: [])"#)))
        } else if let genericBaseType {
            if genericBaseType.as(IdentifierTypeSyntax.self)?.name.text == "StringProtocol" {
                return parameter.with(\.type, TypeSyntax("String"))
            } else {
                return parameter.with(\.type, TypeSyntax("Any\(genericBaseType)")) // erase the generic
            }
        } else if let memberType = parameter.type.as(MemberTypeSyntax.self),
                  memberType.baseType.as(IdentifierTypeSyntax.self)?.name.text == "SwiftUI"
                    && memberType.name.text == "Text"
        {
            return parameter.with(\.type, TypeSyntax("TextReference"))
        } else if let memberType = parameter.type.as(MemberTypeSyntax.self),
                  memberType.baseType.as(IdentifierTypeSyntax.self)?.name.text == "SwiftUI"
                    && memberType.name.text == "Binding"
        {
            return parameter.with(\.type, TypeSyntax("ChangeTracked\(raw: memberType.genericArgumentClause?.description ?? "")"))
        } else {
            return parameter
        }
    }
}

final class ModifierVisitor: SyntaxVisitor {
    var modifiers = [String: [(FunctionDeclSyntax, availability: (AvailabilityArgumentListSyntax, Set<String>))]]()

    func availability(_ base: ExtensionDeclSyntax, _ decl: FunctionDeclSyntax) -> (AvailabilityArgumentListSyntax, Set<String>) {
        var availability = [String:PlatformVersionSyntax]()
        var unavailable = Set<String>()

        for attribute in base.attributes.lazy.compactMap({ $0.as(AttributeSyntax.self)?.arguments?.as(AvailabilityArgumentListSyntax.self) }) {
            for argument in attribute.lazy.compactMap({ $0.argument.as(PlatformVersionSyntax.self) }) {
                availability[argument.platform.text] = argument
            }
        }
        for attribute in decl.attributes.lazy.compactMap({ $0.as(AttributeSyntax.self)?.arguments?.as(AvailabilityArgumentListSyntax.self) }) {
            for argument in attribute {
                if let platformVersion = argument.argument.as(PlatformVersionSyntax.self) {
                    availability[platformVersion.platform.text] = platformVersion
                } else if argument.argument.as(TokenSyntax.self)?.tokenKind == .keyword(.unavailable),
                          let platform = attribute.first?.argument.as(TokenSyntax.self)?.text {
                    unavailable.insert(platform)
                }
            }
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
              extendedType.name.tokenKind == .identifier("View")
        else { return .skipChildren }

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
            self.modifiers[decl.name.trimmed.text, default: []].append((decl, availability: availability(node, decl)))
        }

        return .skipChildren
    }
}