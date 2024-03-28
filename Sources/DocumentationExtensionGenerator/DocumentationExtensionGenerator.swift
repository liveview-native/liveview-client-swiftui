import Foundation
import RegexBuilder
import ArgumentParser

@main
struct DocumentationExtensionGenerator: ParsableCommand {
    @Option(name: .customLong("view")) private var views: [String] = []
    
    static let denylist = [
        "LiveView",
        "Shape",
        "TextFieldProtocol",
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
