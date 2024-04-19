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
            help: "The `.swiftinterface` file from `/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks/SwiftUI.framework/Modules/SwiftUI.swiftmodule/arm64-apple-ios.swiftinterface`",
            transform: { URL(filePath: $0) }
        )
        var interface: URL
        
        @Option(
            help: "The output folder for the generated documentation extensions",
            transform: { URL(filePath: $0) }
        )
        private var output: URL
        
        func run() throws {
            let source = try String(contentsOf: interface, encoding: .utf8)
            let sourceFile = Parser.parse(source: source)
            
            let (modifiers, _) = ModifierGenerator.modifiers(from: sourceFile)
            
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
                
                \#(signatures.map({ documentation(for: $0, on: name) }).joined(separator: "\n\n"))
                
                ## SwiftUI Documentation
                See [`SwiftUI.View/\#(firstSignatureDescription)`](\#(appleDocs.absoluteString)) for more details on this ViewModifier.
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
            let signatureDescription = signatureDescription(for: signature, on: name)
            let appleDocs = URL(string: "https://developer.apple.com/documentation/swiftui/view/")!
                .appending(path: signatureDescription)
            return #"""
            ## \#(signatureDescription)
            See [`SwiftUI.View/\#(signatureDescription)`](\#(appleDocs.absoluteString)) for more details on this ViewModifier.
            
            Parameters:
            \#(signature.parameters.map({
                let name = $0.firstName.kind == .wildcardPattern ? $0.secondName?.text ?? $0.firstName.text : $0.firstName.text
                var effects = [String]()
                if $0.defaultValue == nil {
                    effects.append("required")
                }
                return "- `\(name)`: \($0.type.markdown)\(effects.isEmpty ? "" : " (" + effects.joined(separator: ", ") + ")")"
            }).joined(separator: "\n"))
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
    }
}

fileprivate extension TypeSyntax {
    var markdown: String {
        if let identifierType = self.as(IdentifierTypeSyntax.self) {
            if let genericArgumentsClause = identifierType.genericArgumentClause {
                return "``\(identifierType.name.text)``<\(genericArgumentsClause.arguments.map(\.argument.markdown).joined(separator: ", "))>"
            } else {
                return "``\(identifierType.name.text)``"
            }
        } else if let optionalType = self.as(OptionalTypeSyntax.self) {
            return "\(optionalType.wrappedType.markdown)?"
        } else if let memberType = self.as(MemberTypeSyntax.self) {
            return "``\(memberType.baseType.markdown.replacing("``", with: ""))/\(memberType.name.trimmedDescription)``"
        } else {
            return "``\(self.trimmedDescription)``"
        }
    }
}
