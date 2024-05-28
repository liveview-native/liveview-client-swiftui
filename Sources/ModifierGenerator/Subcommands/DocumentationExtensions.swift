//
//  DocumentationGenerator.swift
//
//
//  Created by Carson Katri on 4/19/24.
//

import ArgumentParser
import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftParser

extension ModifierGenerator {
    struct DocumentationExtensions: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Output a list of the names of all available modifiers.")
        
        @Option(
            help: "The `.swiftinterface` file from `/Applications/Xcode.app/Contents/Developer/Platforms/XROS.platform/Developer/SDKs/XROS.sdk/System/Library/Frameworks/SwiftUI.framework/Modules/SwiftUI.swiftmodule/arm64-apple-xros.swiftinterface`",
            transform: { URL(filePath: $0) }
        )
        var interface: URL
        
        @Option(
            help: "The output folder for the generated documentation extensions",
            transform: { URL(filePath: $0) }
        )
        private var output: URL
        
        private static let typeVisitor = EnumTypeVisitor(typeNames: ModifierGenerator.requiredTypes)
        
        func run() throws {
            let source = try String(contentsOf: interface, encoding: .utf8)
            let sourceFile = Parser.parse(source: source)
            
            let (modifiers, _) = ModifierGenerator.modifiers(from: sourceFile)
            
            Self.typeVisitor.walk(sourceFile)
            
            for (name, (signatures, _)) in modifiers {
                let firstSignatureDescription = signatureDescription(for: signatures.first!, on: name)
                
                let appleDocs = URL(string: "https://developer.apple.com/documentation/swiftui/view/")!
                    .appending(path: firstSignatureDescription)
                
                let markdownURL = output
                    .appending(path: name)
                    .appendingPathExtension("md")
                
                try
                #"""
                # ``LiveViewNative/_\#(name)Modifier``
                
                @Metadata {
                    @DocumentationExtension(mergeBehavior: append)
                    @DisplayName("\#(firstSignatureDescription)", style: symbol)
                }
                
                See [`SwiftUI.View/\#(firstSignatureDescription)`](\#(appleDocs.absoluteString)) for more details on this ViewModifier.
                
                \#(signatures.map({ documentation(for: $0, on: name) }).joined(separator: "\n\n"))
                """#
                        .write(to: markdownURL, atomically: true, encoding: .utf8)
            }
            
            let listURL = output
                .appending(path: "Modifiers")
                .appendingPathExtension("md")
            
            try
            #"""
            # Modifiers
            ## Topics
            ### Modifiers
            \#(
                modifiers.keys.sorted()
                    .map({"- ``_\($0)Modifier``" })
                    .joined(separator: "\n")
            )
            """#
                .write(to: listURL, atomically: true, encoding: .utf8)
        }
        
        private func documentation(for signature: Signature, on name: String) -> String {
            let title = signatureDescription(for: signature, on: name)
            let signatureDescription = signatureDescription(for: signature, on: name)
            let appleDocs = URL(string: "https://developer.apple.com/documentation/swiftui/view/")!
                .appending(path: signatureDescription)
            
            return #"""
            ### \#(title)
            \#(signature.parameters.map({
                let name = $0.firstName.tokenKind == .wildcard ? $0.secondName?.text ?? $0.firstName.text : $0.firstName.text
                var effects = [String]()
                if $0.defaultValue == nil {
                    effects.append("required")
                }
                if $0.type.isChangeTracked {
                    effects.append("change tracked")
                }
                return "- `\(name)`: \($0.type.markdown)\(effects.isEmpty ? "" : " (" + effects.joined(separator: ", ") + ")")"
            }).joined(separator: "\n"))
            
            
            See [`SwiftUI.View/\#(signatureDescription)`](\#(appleDocs.absoluteString)) for more details on this ViewModifier.
            
            Example:
            \#(example(for: signature, on: name))
            """#
        }
        
        private func signatureDescription(for signature: Signature, on name: String) -> String {
            """
            \(name)(\(signature.parameters
                .map({ $0.firstName.text })
                .joined(separator: ":")
            )\(signature.parameters.count > 0 ? ":" : ""))
            """
        }
        
        private func example(for signature: Signature, on name: String) -> String {
            var parameters = [String]()
            var events = [String]()
            var attributes = [String]()
            var templates = [String]()
            var changeTracked = [String]()
            for parameter in signature.parameters {
                let displayName = parameter.firstName.tokenKind == .wildcard
                    ? parameter.secondName?.text ?? parameter.firstName.text
                    : parameter.firstName.text
                let value: String
                if parameter.type.isChangeTracked {
                    value = #"attr("\#(displayName)")"#
                    attributes.append(displayName)
                    changeTracked.append(displayName)
                } else if parameter.type.isEvent {
                    value = #"event("\#(displayName)")"#
                    events.append(displayName)
                } else if parameter.type.isAttributeReference {
                    value = #"attr("\#(displayName)")"#
                    attributes.append(displayName)
                } else if parameter.type.isViewReference {
                    value = #":\#(displayName)"#
                    templates.append(#"<Child template="\#(displayName)" />"#)
                } else if parameter.type.isTextReference {
                    value = #":\#(displayName)"#
                    templates.append(#"<Text template="\#(displayName)">...</Text>"#)
                } else if let enumType = Self.typeVisitor.types[parameter.type.nestedTypeName]?.first {
                    value = ".\(enumType.0)"
                } else {
                    value = parameter.type.exampleValue
                }
                parameters.append(
                    (parameter.firstName.tokenKind == .wildcard ? "" : parameter.firstName.text + ": ") + value
                )
            }
            
            var result = ""
            let style: String
            
            if parameters.isEmpty {
                style = #"\#(name)()"#
            } else {
                style = #"\#(name)(\#(parameters.joined(separator: ", ")))"#
            }
            
            let quotedStyle: String
            if style.contains(#"""# as Character) {
                quotedStyle = #"'\#(style)'"#
            } else {
                quotedStyle = #""\#(style)""#
            }
            
            let changeEvent: String? = switch changeTracked.count {
            case 0:
                nil
            case 1:
                "\(changeTracked.first!)-changed"
            default:
                "\(name)-changed"
            }
            
            let resolvedAttributes = (
                attributes.map({ "\($0)={@\($0)}" }) +
                (changeEvent.flatMap({ [#"phx-change="\#($0)""#] }) ?? [])
            )
            if !resolvedAttributes.isEmpty {
                if templates.isEmpty {
                    result.append(#"""
                    
                    ```html
                    <Element style=\#(quotedStyle) \#(resolvedAttributes.joined(separator: " ")) />
                    ```
                    """#)
                } else {
                    result.append(#"""
                    
                    ```html
                    <Element style=\#(quotedStyle) \#(resolvedAttributes.joined(separator: " "))>
                    \#(templates.map({ "  \($0)" }).joined(separator: "\n"))
                    </Element>
                    ```
                    """#)
                }
            } else if !templates.isEmpty {
                result.append(#"""
                
                ```html
                <Element style=\#(quotedStyle)>
                \#(templates.map({ "  \($0)" }).joined(separator: "\n"))
                </Element>
                ```
                """#)
            }
            
            let resolvedEvents = events + (changeEvent.flatMap({ [$0] }) ?? [])
            if !resolvedEvents.isEmpty {
                result.append(#"""
                
                ```elixir
                \#(resolvedEvents.map({ #"def handle_event("\#($0)", params, socket)"# }).joined(separator: "\n"))
                ```
                """#)
            }
            
            return result
        }
    }
}

fileprivate extension TypeSyntax {
    var markdown: String {
        if let identifierType = self.as(IdentifierTypeSyntax.self) {
            if let genericArgumentsClause = identifierType.genericArgumentClause {
                let genericArguments = genericArgumentsClause.arguments.map(\.argument.markdown).joined(separator: ", ")
                switch identifierType.name.text {
                case "AttributeReference":
                    return #"`attr("...")` or \#(genericArguments)"#
                case "ChangeTracked":
                    return #"`attr("...")` for a \#(genericArguments)"#
                case "AnyGesture":
                    return #"``SwiftUI/AnyGesture``"#
                default:
                    return "``\(identifierType.name.text)``<\(genericArguments)>"
                }
            } else {
                switch identifierType.name.text {
                case "Event":
                    return #"`event("...")`"#
                case "AnyShapeStyle":
                    return #"``SwiftUI/\#(identifierType.name.text)``"#
                default:
                    return "``\(identifierType.name.text)``"
                }
            }
        } else if let optionalType = self.as(OptionalTypeSyntax.self) {
            let wrappedMarkdown = optionalType.wrappedType.markdown
            return wrappedMarkdown.hasSuffix("or `nil`") ? wrappedMarkdown : "\(wrappedMarkdown) or `nil`"
        } else if let memberType = self.as(MemberTypeSyntax.self) {
            return "``\(memberType.baseType.markdown.replacing("``", with: ""))/\(memberType.name.trimmedDescription)``"
        } else {
            return "``\(self.trimmedDescription)``"
        }
    }
    
    var exampleValue: String {
        if let identifierType = self.as(IdentifierTypeSyntax.self) {
            return "_\(identifierType.name.text)_"
        } else if self.is(OptionalTypeSyntax.self) {
            return "nil"
        } else if let memberType = self.as(MemberTypeSyntax.self) {
            return "_\(memberType.name.trimmedDescription)_"
        } else {
            return "_\(self.trimmedDescription)_"
        }
    }
    
    var isChangeTracked: Bool {
        if let optionalType = self.as(OptionalTypeSyntax.self) {
            return optionalType.wrappedType.isChangeTracked
        } else if let identifierType = self.as(IdentifierTypeSyntax.self) {
            return identifierType.name.text == "ChangeTracked"
        } else {
            return false
        }
    }
    
    var isEvent: Bool {
        if let optionalType = self.as(OptionalTypeSyntax.self) {
            return optionalType.wrappedType.isEvent
        } else if let identifierType = self.as(IdentifierTypeSyntax.self) {
            return identifierType.name.text == "Event"
        } else {
            return false
        }
    }
    
    var isAttributeReference: Bool {
        if let optionalType = self.as(OptionalTypeSyntax.self) {
            return optionalType.wrappedType.isAttributeReference
        } else if let identifierType = self.as(IdentifierTypeSyntax.self) {
            return identifierType.name.text == "AttributeReference"
        } else {
            return false
        }
    }
    
    var isViewReference: Bool {
        if let optionalType = self.as(OptionalTypeSyntax.self) {
            return optionalType.wrappedType.isViewReference
        } else if let identifierType = self.as(IdentifierTypeSyntax.self) {
            return identifierType.name.text == "ViewReference"
        } else {
            return false
        }
    }
    
    var isTextReference: Bool {
        if let optionalType = self.as(OptionalTypeSyntax.self) {
            return optionalType.wrappedType.isTextReference
        } else if let identifierType = self.as(IdentifierTypeSyntax.self) {
            return identifierType.name.text == "TextReference"
        } else {
            return false
        }
    }
    
    var nestedTypeName: String {
        if let optionalType = self.as(OptionalTypeSyntax.self) {
            return optionalType.wrappedType.nestedTypeName
        } else if let identifierType = self.as(IdentifierTypeSyntax.self) {
            if let genericArgument = identifierType.genericArgumentClause?.arguments.first {
                return genericArgument.argument.nestedTypeName
            } else {
                return identifierType.name.text
            }
        } else if let memberType = self.as(MemberTypeSyntax.self) {
            return memberType.name.text
        } else {
            return ""
        }
    }
}
