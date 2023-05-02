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
    
    static let denylist = [
        "Shape",
        "TextFieldProtocol",
        "NamespaceContext",
        "ToolbarItem",
        "ToolbarItemGroup",
        "ToolbarTitleMenu",
    ]
    
    static let additionalViews = [
        "Capsule": "Shape(shape: Capsule(from: element))",
        "Circle": "Shape(shape: Circle())",
        "ContainerRelativeShape": "Shape(shape: ContainerRelativeShape())",
        "Divider": "Divider()",
        "EditButton": """
        #if os(iOS)
        EditButton()
        #endif
        """,
        "Ellipse": "Ellipse()",
        "NamespaceContext": "NamespaceContext<R>()",
        "Rectangle": "Shape(shape: Rectangle())",
        "RenameButton": "RenameButton()",
        "RoundedRectangle": "Shape(shape: RoundedRectangle(from: element))",
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
            .map(viewCase(path:))
            .joined(separator: "\n")
        
        let modifiers = modifiers
            .map(URL.init(fileURLWithPath:))
            .filter(isAllowed(path:))
        let modifierCases = try modifiers
            .map(modifierCase(path:))
            .joined(separator: "\n")
        let modifierSwitchCases = try modifiers
            .map(modifierSwitchCase(path:))
            .joined(separator: "\n")
        
        let generated = """
        import SwiftUI
        
        // This switch can't be inlined into BuiltinRegistry.lookup because it results in that method's return type
        // being a massive pile of nested _ConditionalContents. Instead, lift it out into a separate View type
        // that lookup can return, so it doesn't blow up the stack.
        // See #806 for more details.
        struct BuiltinElement<R: RootRegistry>: View {
            let name: String
            let element: ElementNode
            var body: some View {
                switch name {
        \(views)
        \(Self.additionalViews.map(additionalViewCase(name:initializer:)).joined(separator: "\n"))
                default:
                    // log here that view type cannot be found
                    EmptyView()
                }
            }
        }
        
        extension BuiltinRegistry {
            enum ModifierType: String {
        \(modifierCases)
            }
        
            @ViewModifierBuilder
            static func decodeModifier(_ type: ModifierType, from decoder: Decoder) throws -> some ViewModifier {
                switch type {
        \(modifierSwitchCases)
                }
            }
        }
        """
        try generated.write(to: output, atomically: true, encoding: .utf8)
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
            let expression = Regex {
                Capture(as: platform) {
                    OneOrMore(.word)
                }
                Optionally {
                    OneOrMore(.whitespace)
                    Capture(as: version) {
                        OneOrMore(.digit)
                        Optionally {
                            "."
                            OneOrMore(.digit)
                        }
                    } transform: {
                        Double($0)
                    }
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
    
    func viewCase(path: URL) throws -> String {
        let name = path.deletingPathExtension().lastPathComponent
        if let availability = try availability(path: path) {
            return """
                    case "\(name)":
                        if #available(\(availability)) {
                            \(name)\(try isGeneric(path: path) ? "<R>" : "")()
                        }
            """
        } else {
            return """
                    case "\(name)":
                        \(name)\(try isGeneric(path: path) ? "<R>" : "")()
            """
        }
    }
    
    func additionalViewCase(name: String, initializer: String) -> String {
        """
                case "\(name)":
                    \(initializer)
        """
    }
    
    func modifierCase(path: URL) throws -> String {
        let name = path.deletingPathExtension().lastPathComponent.firstMatch(of: Regex {
            Capture {
                OneOrMore(.any)
            }
            "Modifier"
        }).flatMap({ String($0.output.1) }) ?? path.deletingPathExtension().lastPathComponent
        return """
                case \(name.toCamelCase()) = "\(name.toSnakeCase())"
        """
    }
    
    func modifierSwitchCase(path: URL) throws -> String {
        let name = path.deletingPathExtension().lastPathComponent.firstMatch(of: Regex {
            Capture {
                OneOrMore(.any)
            }
            "Modifier"
        }).flatMap({ String($0.output.1) }) ?? path.deletingPathExtension().lastPathComponent
        if let availability = try availability(path: path) {
            return """
                    case .\(name.toCamelCase()):
                        if #available(\(availability)) {
                            try \(name)Modifier\(try isGeneric(path: path) ? "<R>" : "")(from: decoder)
                        }
            """
        } else {
            return """
                    case .\(name.toCamelCase()):
                        try \(name)Modifier\(try isGeneric(path: path) ? "<R>" : "")(from: decoder)
            """
        }
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
