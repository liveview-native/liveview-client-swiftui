//
//  BuiltinRegistryGenerator.swift
//  
//
//  Created by Carson Katri on 4/18/23.
//

import ArgumentParser
import Foundation
import RegexBuilder

@main
struct BuiltinRegistryGenerator: ParsableCommand {
    @Argument(transform: { URL(filePath: $0) }) private var package: URL
    @Argument(transform: { URL(filePath: $0) }) private var output: URL
    @Option(name: .customLong("view")) private var views: [String] = []
    @Option(name: .customLong("modifier")) private var modifiers: [String] = []
    @Option(name: .customLong("chunk-size")) private var chunkSize: Int = 10
    
    static let denylist = [
        "Shape",
        "TextFieldProtocol",
        "NamespaceContext",
        "ToolbarItem",
        "ToolbarItemGroup",
        "ToolbarTitleMenu",
        "ColorView",
    ]
    
    static let additionalViews: [String: (String, String)] = [
        "Capsule": ("Shape<R, Capsule>", "Shape<R, Capsule>(shape: Capsule(from: element))"),
        "Circle": ("Shape<R, Circle>", "Shape<R, Circle>(shape: Circle())"),
        "ContainerRelativeShape": ("Shape<R, ContainerRelativeShape>", "Shape<R, ContainerRelativeShape>(shape: ContainerRelativeShape())"),
        "Divider": ("Divider", "Divider()"),
        "EditButton": ("EditButton", "EditButton()"),
        "Ellipse": ("Ellipse", "Ellipse()"),
        "NamespaceContext": ("NamespaceContext<R>", "NamespaceContext<R>()"),
        "Rectangle": ("Shape<R, Rectangle>", "Shape<R, Rectangle>(shape: Rectangle())"),
        "RenameButton": ("RenameButton<SwiftUI.Label<SwiftUI.Text, SwiftUI.Image>>", "RenameButton()"),
        "RoundedRectangle": ("Shape<R, RoundedRectangle>", "Shape<R, RoundedRectangle>(shape: RoundedRectangle(from: element))"),
        "Color": ("ColorView<R>", "ColorView<R>()"),
        "Image": ("ImageView<R>", "ImageView<R>()"),
        "div": ("PhxMain<R>", "PhxMain<R>()")
    ]
    
    var platformFamilyName: String? {
        ProcessInfo.processInfo.environment["PLATFORM_FAMILY_NAME"]
    }
    
    var deploymentTarget: Double? {
        ProcessInfo.processInfo.environment["DEPLOYMENT_TARGET_SETTING_NAME"]
            .flatMap { ProcessInfo.processInfo.environment[$0] }
            .flatMap(Double.init(_:))
    }
    
    func run() throws {
        let views = try views
            .map(URL.init(fileURLWithPath:))
            .filter(isAllowed(path:))
        
//        let chunks: [[String]] = stride(from: 0, to: views.count, by: chunkSize).map {
//            Array(views[$0..<min($0 + chunkSize, views.count)])
//        }
        
        var result = """
        import SwiftUI
        import LiveViewNativeStylesheet
        
        // This switch can't be inlined into BuiltinRegistry.lookup because it results in that method's return type
        // being a massive pile of nested _ConditionalContents. Instead, lift it out into a separate View type
        // that lookup can return, so it doesn't blow up the stack.
        // See #806 for more details.
        enum BuiltinElement<R: RootRegistry>: View {
            \(try views.map(viewCaseDefinition(path:)).joined(separator: "\n"))
            \(try Self.additionalViews.map(additionalViewCaseDefinition).joined(separator: "\n"))
            case unknown
        
            init(name: String, element: ElementNode) {
                switch name {
                \(try views.map(viewCaseInit(path:)).joined(separator: "\n"))
                \(try Self.additionalViews.map(additionalViewCaseInit).joined(separator: "\n"))
                default:
                    self = .unknown
                }
            }
        
            var body: some View {
                switch self {
                \(try views.map(viewCase(path:)).joined(separator: "\n"))
                \(try Self.additionalViews.map(additionalViewCase).joined(separator: "\n"))
                case .unknown:
                    // log here that view type cannot be found
                    EmptyView()
                }
            }
        }
        """
        
//        for (i, chunk) in chunks.enumerated() {
//            FileHandle.standardOutput.write(Data(#"""
//            
//            extension BuiltinElement {
//                enum _BuiltinViewChunk\#(i): View {
//                    func body(content: Content) -> some View {
//                        switch self {
//                        \#(chunk.map({
//                            """
//                            case let .\($0)(modifier):
//                                content.modifier(modifier)
//                            """
//                        }).joined(separator: "\n"))
//                        }
//                    }
//                }
//            }
//            """#.utf8))
//        }
        
        try result.write(to: output, atomically: true, encoding: .utf8)
    }
    
    func isAllowed(path: URL) -> Bool {
        !Self.denylist.contains(path.deletingPathExtension().lastPathComponent)
    }
    
    func isGeneric(path: URL) throws -> Bool {
        let name = path.deletingPathExtension().lastPathComponent
        let contents = try String(contentsOf: path)
        // struct [name] <_ : RootRegistry>
        return contents.contains {
            "struct"
            OneOrMore(.whitespace)
            name
            ZeroOrMore(.whitespace)
            "<"
            OneOrMore(.word)
            ZeroOrMore(.whitespace)
            ":"
            ZeroOrMore(.whitespace)
            "RootRegistry"
            ZeroOrMore(.whitespace)
            ">"
        }
    }
    
    func availability(path: URL) throws -> String? {
        let name = path.deletingPathExtension().lastPathComponent
        let contents = try String(contentsOf: path)
        // @available(_)
        // struct [name]
        let availability = Reference(Substring.self)
        if let match = contents.firstMatch(of: Regex {
            "@available("
            Capture(as: availability) {
                ZeroOrMore(.any, .reluctant)
            }
            ")"
            OneOrMore(.whitespace)
            "struct"
            OneOrMore(.whitespace)
            name
        }) {
            // [platform] [version], ...
            let platform = Reference(Substring.self)
            let version = Reference(Double?.self)
            let platformExpr = Capture(as: platform) {
                OneOrMore(.word)
            }
            let versionExpr = Capture(as: version) {
                OneOrMore(.digit)
                Optionally {
                    "."
                    OneOrMore(.digit)
                }
            } transform: {
                Double($0)
            }
            
            let expression = Regex {
                platformExpr
                Optionally {
                    OneOrMore(.whitespace)
                    versionExpr
                }
            }
            let availability = String(match[availability])
            for condition in availability.matches(of: expression) {
                if let version = condition[version] {
                    // Only wrap in `if #available` when the check is higher than the minimum supported version.
                    // This avoids unnecessary type erasure.
                    if let platformFamilyName,
                       let deploymentTarget,
                       condition[platform] == platformFamilyName && version > deploymentTarget
                    {
                        return availability
                    }
                }
            }
        }
        return nil
    }
    
    func viewCaseDefinition(path: URL) throws -> String {
        let name = path.deletingPathExtension().lastPathComponent
        return "case \(name.lowercased())(\(name)\(try isGeneric(path: path) ? "<R>" : ""))"
    }
    
    func viewCaseInit(path: URL) throws -> String {
        let name = path.deletingPathExtension().lastPathComponent
        return """
        case "\(name)":
            self = .\(name.lowercased())(\(name)\(try isGeneric(path: path) ? "<R>" : "")())
        """
    }
    
    func viewCase(path: URL) throws -> String {
        let name = path.deletingPathExtension().lastPathComponent
        if let availability = try availability(path: path) {
            return """
                    case let .\(name.lowercased())(view):
                        if #available(\(availability)) {
                            view
                        }
            """
        } else {
            return """
                    case let .\(name.lowercased())(view):
                        view
            """
        }
    }
    
    func additionalViewCaseDefinition(name: String, initializer: (String, String)) -> String {
        """
        case \(name.lowercased())(\(initializer.0))
        """
    }
    
    func additionalViewCaseInit(name: String, initializer: (String, String)) -> String {
        """
        case "\(name)":
            self = .\(name.lowercased())(\(initializer.1))
        """
    }
    
    func additionalViewCase(name: String, initializer: (String, String)) -> String {
        """
                case let .\(name.lowercased())(view):
                    view
        """
    }
}

extension String {
    func toCamelCase() -> String {
        self.splitWords()
            .enumerated()
            .map { $0.offset == 0 ? $0.element.lowercased() : "\($0.element.first?.uppercased() ?? "")\($0.element.dropFirst().lowercased())" }
            .joined(separator: "")
    }
    
    func toSnakeCase() -> String {
        self.splitWords().map({ $0.lowercased() }).joined(separator: "_")
    }
    
    func splitWords() -> [String] {
        reduce(into: [String]()) { partialResult, character in
            if (character.isUppercase && !(partialResult.last?.last == "3" && character == "D")) || character.isNumber || partialResult.isEmpty {
                partialResult.append(String(character))
            } else {
                partialResult[partialResult.count - 1].append(character)
            }
        }
    }
}
