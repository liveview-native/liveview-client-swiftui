import ArgumentParser
import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftParser

extension ModifierGenerator {
    struct Schema: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Generate a `stylesheet-language.json` file compatible with the VS Code extension.")
        
        @Option(
            help: "The `.swiftinterface` file from `/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks/SwiftUI.framework/Modules/SwiftUI.swiftmodule/arm64-apple-ios.swiftinterface`",
            transform: { URL(filePath: $0) }
        )
        var interface: URL?
        
        @Option(
            help: "The path to search for additional modifier types",
            transform: { URL(filePath: $0) }
        )
        private var modifierSearchPath: URL?
        
        @Option(
            help: "The path to search for additional enum types",
            transform: { URL(filePath: $0) }
        )
        private var enumSearchPath: URL?
        
        @Option(
            help: "The stylesheet format to use. Defaults to `swiftui`"
        )
        private var format: String = "swiftui"
        
        @Option(
            help: "The framework this library implements, used for documentation"
        )
        private var framework: String
        
        func run() throws {
            var generatedSchema = StylesheetLanguageSchema(format: format, framework: framework)
            
            // find extra enum and modifier types in project
            if let enumSearchPath,
                let enumerator = FileManager.default.enumerator(at: enumSearchPath, includingPropertiesForKeys: [.isRegularFileKey]) {
                for case let file as URL in enumerator where file.pathExtension == "swift" {
                    let source = try String(contentsOf: file, encoding: .utf8)
                    let sourceFile = Parser.parse(source: source)
                    let visitor = ParseableEnumVisitor(viewMode: SyntaxTreeViewMode.all)
                    visitor.walk(sourceFile)
                    for (key, value) in visitor.enums {
                        generatedSchema.enums[key] = value
                    }
                    generatedSchema.types.formUnion(visitor.types)
                }
            }
            if let modifierSearchPath,
                let enumerator = FileManager.default.enumerator(at: modifierSearchPath, includingPropertiesForKeys: [.isRegularFileKey]) {
                for case let file as URL in enumerator where file.pathExtension == "swift" {
                    let source = try String(contentsOf: file, encoding: .utf8)
                    let sourceFile = Parser.parse(source: source)
                    let visitor = ParseableModifierVisitor(viewMode: SyntaxTreeViewMode.all)
                    visitor.walk(sourceFile)
                    for (key, value) in visitor.modifiers {
                        generatedSchema.modifiers[key] = value
                    }
                }
            }
            
            if let interface {
                let source = try String(contentsOf: interface, encoding: .utf8)
                let sourceFile = Parser.parse(source: source)

                let (modifiers, deprecations) = ModifierGenerator.modifiers(from: sourceFile)
                generatedSchema.deprecations = deprecations
                for (modifier, signatures) in modifiers {
                    generatedSchema.modifiers[modifier] = signatures.0.map({
                        .init(parameters: $0.parameters.map({
                            .init(
                                firstName: $0.firstName.text,
                                secondName: $0.secondName?.text,
                                type: $0.type.trimmedDescription
                            )
                        }))
                    })
                }
                
                let typeVisitor = EnumTypeVisitor(typeNames: ModifierGenerator.requiredTypes)
                typeVisitor.walk(sourceFile)
                for (type, cases) in typeVisitor.types.sorted(by: { $0.key < $1.key }) {
                    generatedSchema.enums[type] = cases.map({ $0.0 })
                }
            }
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = .sortedKeys
            FileHandle.standardOutput.write(try encoder.encode(generatedSchema))
        }
    }
}
