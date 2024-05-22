import ArgumentParser
import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftParser

extension ModifierGenerator {
    struct List: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Output a list of the names of all available modifiers.")
        
        @Option(
            help: "The `.swiftinterface` file from `/Applications/Xcode.app/Contents/Developer/Platforms/XROS.platform/Developer/SDKs/XROS.sdk/System/Library/Frameworks/SwiftUI.framework/Modules/SwiftUI.swiftmodule/arm64-apple-xros.swiftinterface`",
            transform: { URL(filePath: $0) }
        )
        var interface: URL?
        
        @Option(
            help: "The path to search for additional modifier types",
            transform: { URL(filePath: $0) }
        )
        private var modifierSearchPath: URL?
        
        func run() throws {
            var modifierNames = [String]()
            
            // find extra modifier types in project
            if let modifierSearchPath,
                let enumerator = FileManager.default.enumerator(at: modifierSearchPath, includingPropertiesForKeys: [.isRegularFileKey]) {
                for case let file as URL in enumerator where file.pathExtension == "swift" {
                    let source = try String(contentsOf: file, encoding: .utf8)
                    let sourceFile = Parser.parse(source: source)
                    let visitor = ParseableModifierVisitor(viewMode: SyntaxTreeViewMode.all)
                    visitor.walk(sourceFile)
                    modifierNames.append(contentsOf: visitor.modifiers.keys)
                }
            }
            
            if let interface {
                let source = try String(contentsOf: interface, encoding: .utf8)
                let sourceFile = Parser.parse(source: source)

                let (modifiers, _) = ModifierGenerator.modifiers(from: sourceFile)
                modifierNames.append(contentsOf: modifiers.keys)
            }
            
            FileHandle.standardOutput.write(Data(modifierNames.sorted().joined(separator: "\n").utf8))
        }
    }
}
