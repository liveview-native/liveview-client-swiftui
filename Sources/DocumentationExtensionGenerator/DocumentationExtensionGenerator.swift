import Foundation
import RegexBuilder
import ArgumentParser

@main
struct DocumentationExtensionGenerator: ParsableCommand {
    @Option(name: .customLong("view")) private var views: [String] = []
    @Option(name: .customLong("modifier")) private var modifiers: [String] = []
    
    static let denylist = [
        "LiveView",
        "Shape",
        "TextFieldProtocol",
        "NamespaceContext"
    ]
    
    static let categoryDenyList = [
        "Shapes"
    ]
    
    static let categoryAdditions = [
        ["Controls and Indicators", "Buttons"]: [
            "<doc:EditButton>",
            "<doc:RenameButton>",
        ],
        ["Layout Containers", "Separators"]: [
            "<doc:Divider>",
        ],
        ["Animations Modifiers", "Views"]: [
            "``NamespaceContext``"
        ]
    ]
    
    func run() throws {
        let packageDirectory = URL(filePath: FileManager.default.currentDirectoryPath)
        let extensionsURL = packageDirectory.appending(path: "Sources/LiveViewNative/LiveViewNative.docc/DocumentationExtensions")
        
        try viewCategories(
            directory: packageDirectory.appending(path: "Sources/LiveViewNative/Views"),
            output: extensionsURL,
            fallbackSubcategory: "Views"
        )

        try viewCategories(
            directory: packageDirectory.appending(path: "Sources/LiveViewNative/Modifiers"),
            output: extensionsURL,
            fallbackSubcategory: "Modifiers"
        )
        
        // MARK: View element and attribute/event names
        let views = self.views.map { URL(filePath: $0) }
        for view in views {
            let name = view.deletingPathExtension().lastPathComponent
            guard !Self.denylist.contains(name) else { continue }
            
            let markdownURL = extensionsURL
                .appending(path: name)
                .appendingPathExtension("md")
            
            try FileManager.default.createDirectory(at: markdownURL.deletingLastPathComponent(), withIntermediateDirectories: true)
            
            let appleDocs = URL(string: "https://developer.apple.com/documentation/swiftui/")!
                .appending(path: name)
            
            let elementName = "<\(name)>"
            try
            #"""
            # ``LiveViewNative/\#(name)``
            
            @Metadata {
                @DocumentationExtension(mergeBehavior: append)
                @DisplayName("\#(elementName)", style: symbol)
            }
            
            ## SwiftUI Documentation
            See [`SwiftUI.\#(name)`](\#(appleDocs.absoluteString)) for more details on this View.
            """#
                .write(to: markdownURL, atomically: true, encoding: .utf8)
            
            let property = Reference(Substring.self)
            let attributeName = Reference(Substring.self)
            let expression = Regex {
                "@"
                ChoiceOf {
                    "Attribute"
                    "Event"
                }
                "("
                ZeroOrMore(.whitespace)
                "\""
                Capture(as: attributeName) {
                    OneOrMore(.any, .reluctant)
                }
                "\""
                ZeroOrMore(.any, .reluctant)
                ")"
                OneOrMore(.whitespace)
                "private"
                OneOrMore(.whitespace)
                "var"
                OneOrMore(.whitespace)
                Capture(as: property) {
                    OneOrMore(.word)
                }
            }
            for match in try String(contentsOf: view).matches(of: expression) where match[property] != match[attributeName] {
                try
                #"""
                # ``LiveViewNative/\#(name)/\#(match[property])``
                
                @Metadata {
                    @DocumentationExtension(mergeBehavior: append)
                    @DisplayName("\#(match[attributeName])", style: symbol)
                }
                """#
                    .write(
                        to: extensionsURL
                            .appending(path: "\(name)-\(match[property])")
                            .appendingPathExtension("md"),
                        atomically: true,
                        encoding: .utf8
                    )
            }
        }
        
        // MARK: Modifier function names
        let modifiers = self.modifiers.map { URL(filePath: $0) }
        for modifier in modifiers {
            let name = modifier.deletingPathExtension().lastPathComponent
            guard !Self.denylist.contains(name) else { continue }

            let markdownURL = extensionsURL
                .appending(path: name)
                .appendingPathExtension("md")

            try FileManager.default.createDirectory(at: markdownURL.deletingLastPathComponent(), withIntermediateDirectories: true)

            let expression = Regex {
                ChoiceOf {
                    Anchor.startOfLine
                    "a"..."z"
                }
                "A"..."Z"
            }
            let functionName = name
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
            # ``LiveViewNative/\#(name)``

            @Metadata {
                @DocumentationExtension(mergeBehavior: append)
                @DisplayName("\#(functionName)", style: symbol)
            }
            """#
            try override.write(to: markdownURL, atomically: true, encoding: .utf8)
        }
    }

    func viewCategories(directory: URL, output: URL, fallbackSubcategory: String) throws {
        for category in try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
            where category.hasDirectoryPath
                  && !Self.categoryDenyList.contains(category.lastPathComponent)
        {
            let fileName = category.lastPathComponent.capitalized.replacing(" ", with: "")
            
            func getFileTypes(at url: URL) throws -> [String] {
                try FileManager.default
                    .contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
                    .filter {
                        $0.pathExtension == "swift"
                        && !Self.denylist.contains($0.deletingPathExtension().lastPathComponent)
                    }
                    .map { "``\($0.deletingPathExtension().lastPathComponent)``" }
            }
            
            let topics = Self.categoryAdditions
                .filter({ $0.key.first == category.lastPathComponent })
                .merging(
                    try FileManager.default
                        .contentsOfDirectory(at: category, includingPropertiesForKeys: nil)
                        .filter(\.hasDirectoryPath)
                        .map {
                            (
                                [category.lastPathComponent, $0.lastPathComponent],
                                try getFileTypes(at: $0)
                            )
                        },
                    uniquingKeysWith: { $0 + $1 }
                )
                .merging(
                    [[category.lastPathComponent, fallbackSubcategory]: try getFileTypes(at: category)],
                    uniquingKeysWith: { $0 + $1 }
                )
            
            try """
            # \(category.lastPathComponent)
            ## Topics
            \(topics
                .sorted(by: { $0.key.joined() < $1.key.joined() })
                .map { (heading, references) in
                    (
                        heading
                            .dropFirst()
                            .enumerated()
                            .map { "###\(String(repeating: "#", count: $0.offset)) \($0.element)" }
                        + references
                            .sorted()
                            .map { "- \($0)" }
                    )
                        .joined(separator: "\n")
                }
                    .joined(separator: "\n")
            )
            """
                .write(
                    to: output.appending(path: fileName).appendingPathExtension("md"),
                    atomically: true,
                    encoding: .utf8
                )
        }
    }
}

extension Dictionary {
    mutating func popAll(where condition: ((key: Key, value: Value)) -> Bool) -> Self {
        var result = Self()
        for (key, value) in self where condition((key: key, value: value)) {
            guard let value = self.removeValue(forKey: key) else { continue }
            result[key] = value
        }
        return result
    }
}
