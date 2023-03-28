import SymbolKit
import Foundation
import RegexBuilder
import OSLog

let logger = Logger(subsystem: "LiveViewNative", category: "DocumentationExtensionGenerator")

@main
struct DocumentationExtensionGenerator {
    static let denylist = [
        "LiveView",
        "Shape",
    ]
    
    static let categoryDenyList = [
        "Shapes"
    ]
    
    static func main() throws {
        let packageDirectory = URL(filePath: FileManager.default.currentDirectoryPath)
        let symbolsURL = packageDirectory.appending(path: "docc_build/Build/Intermediates.noindex/LiveViewNative.build/Debug-iphoneos/LiveViewNative.build/symbol-graph/swift/arm64-apple-ios/LiveViewNative.symbols.json", directoryHint: .notDirectory)
        
        let data = try Data(contentsOf: symbolsURL)
        let symbolGraph = try JSONDecoder().decode(SymbolGraph.self, from: data)
        
        let extensionsURL = packageDirectory.appending(path: "Sources/LiveViewNative/LiveViewNative.docc/DocumentationExtensions")
        
        try viewCategories(
            directory: packageDirectory.appending(path: "Sources/LiveViewNative/Views"),
            output: extensionsURL
        )
        
        // MARK: View element name overrides and SwiftUI links
        for symbol in symbolGraph.symbols.values
            where symbol.kind.identifier == .struct
                && symbolGraph.relationships.contains(where: { $0.source == symbol.identifier.precise && $0.targetFallback == "SwiftUI.View" })
                && !Self.denylist.contains(symbol.pathComponents.joined(separator: "/"))
        {
            let symbolPath = (["LiveViewNative"] + symbol.pathComponents).joined(separator: "/")
            
            let markdownURL = extensionsURL
                .appending(path: symbol.pathComponents.joined(separator: "-"))
                .appendingPathExtension("md")
            
            try FileManager.default.createDirectory(at: markdownURL.deletingLastPathComponent(), withIntermediateDirectories: true)
            
            let appleDocs = URL(string: "https://developer.apple.com/documentation/swiftui/")!
                .appending(path: symbol.pathComponents.last!)
            
            let elementName = "<\(symbol.pathComponents.last!)>"
            let override = #"""
            # ``\#(symbolPath)``

            @Metadata {
                @DocumentationExtension(mergeBehavior: append)
                @DisplayName("\#(elementName)", style: symbol)
            }
            
            ## SwiftUI Documentation
            See [`SwiftUI.\#(symbol.pathComponents.last!)`](\#(appleDocs.absoluteString)) for more details on this View.
            """#
            try override.write(to: markdownURL, atomically: true, encoding: .utf8)
        }
        
        // MARK: @Attribute/@Event display name overrides
        let attributeID = symbolGraph.symbols.values.first(where: { $0.pathComponents == ["Attribute"] })!.identifier.precise
        let eventID = symbolGraph.symbols.values.first(where: { $0.pathComponents == ["Event"] })!.identifier.precise
        
        for symbol in symbolGraph.symbols.values
            where symbol.kind.identifier == .property
                && (symbol.declarationFragments?.count ?? 0) > 2
                && symbol.declarationFragments![0].kind == .attribute
                && symbol.declarationFragments![0].spelling == "@"
                && [attributeID, eventID].contains(symbol.declarationFragments![1].preciseIdentifier)
                && !Self.denylist.contains(symbol.pathComponents.joined(separator: "/"))
        {
            let expression = Regex {
                "@"
                ChoiceOf {
                    "Attribute"
                    "Event"
                }
                "("
                ZeroOrMore(.whitespace)
                "\""
                Capture {
                    ZeroOrMore(CharacterClass(.anyOf("\"")).inverted)
                }
                ZeroOrMore(.whitespace)
                "\""
            }
            
            // scan backwards from the declaration until we find the @Attribute
            let location = symbol[mixin: SymbolGraph.Symbol.Location.self]!
            let upToDeclaration = try String(contentsOf: location.url!)
                .split(separator: "\n", omittingEmptySubsequences: false)
                .prefix(location.position.line + 1)
                .joined(separator: "\n")
            var displayName: Substring?
            var index = upToDeclaration.endIndex
            repeat {
                index = upToDeclaration.index(before: index)
                if let match = upToDeclaration[index...].firstMatch(of: expression) {
                    displayName = match.output.1
                    break
                }
            } while index > upToDeclaration.startIndex
            
            guard let displayName else { continue }
            
            let symbolPath = (["LiveViewNative"] + symbol.pathComponents).joined(separator: "/")
            
            let markdownURL = extensionsURL
                .appending(path: symbol.pathComponents.joined(separator: "-"))
                .appendingPathExtension("md")
            
            try FileManager.default.createDirectory(at: markdownURL.deletingLastPathComponent(), withIntermediateDirectories: true)
            
            let override = #"""
            # ``\#(symbolPath)``

            @Metadata {
                @DocumentationExtension(mergeBehavior: append)
                @DisplayName("\#(displayName)", style: symbol)
            }
            """#
            try override.write(to: markdownURL, atomically: true, encoding: .utf8)
        }
        
        // MARK: ViewModifier function name overrides
        for symbol in symbolGraph.symbols.values
            where symbol.kind.identifier == .struct
                && symbolGraph.relationships.contains(where: { $0.source == symbol.identifier.precise && $0.targetFallback == "SwiftUI.ViewModifier" })
                && !Self.denylist.contains(symbol.pathComponents.joined(separator: "/"))
        {
            let symbolPath = (["LiveViewNative"] + symbol.pathComponents).joined(separator: "/")
            
            let markdownURL = extensionsURL
                .appending(path: symbol.pathComponents.joined(separator: "/"))
                .appendingPathExtension("md")
            
            try FileManager.default.createDirectory(at: markdownURL.deletingLastPathComponent(), withIntermediateDirectories: true)
            
            let expression = Regex {
                ChoiceOf {
                    Anchor.startOfLine
                    "a"..."z"
                }
                "A"..."Z"
            }
            let functionName = symbol.pathComponents.last!
                .replacing("Modifier", with: "")
                .replacing(expression) { match in
                    switch match.output.count {
                    case 2:
                        return "\(match.output[match.startIndex])_\(match.output[match.output.index(before: match.output.endIndex)])".lowercased()
                    default:
                        return match.output.lowercased()
                    }
                }

            let override = #"""
            # ``\#(symbolPath)``

            @Metadata {
                @DocumentationExtension(mergeBehavior: append)
                @DisplayName("\#(functionName)", style: symbol)
            }
            """#
            try override.write(to: markdownURL, atomically: true, encoding: .utf8)
        }
    }
    
    static func viewCategories(directory: URL, output: URL) throws {
        for category in try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
            where category.hasDirectoryPath
                  && !Self.categoryDenyList.contains(category.lastPathComponent)
        {
            let fileName = category.lastPathComponent.capitalized.replacing(" ", with: "")
            var categoryFile = ["# \(category.lastPathComponent)", "## Topics"]
            for subCategory in try FileManager.default.contentsOfDirectory(at: category, includingPropertiesForKeys: nil)
            where subCategory.hasDirectoryPath {
                categoryFile.append("### \(subCategory.lastPathComponent)")
                for file in try FileManager.default.contentsOfDirectory(at: subCategory, includingPropertiesForKeys: nil)
                    where file.pathExtension == "swift"
                {
                    categoryFile.append("- ``\(file.deletingPathExtension().lastPathComponent)``")
                }
            }
            for file in try FileManager.default.contentsOfDirectory(at: category, includingPropertiesForKeys: nil)
                where file.pathExtension == "swift"
            {
                if !categoryFile.contains("### Views") {
                    categoryFile.append("### Views")
                }
                categoryFile.append("- ``\(file.deletingPathExtension().lastPathComponent)``")
            }
            try categoryFile.joined(separator: "\n")
                .write(
                    to: output.appending(path: fileName).appendingPathExtension("md"),
                    atomically: true,
                    encoding: .utf8
                )
        }
    }
}
