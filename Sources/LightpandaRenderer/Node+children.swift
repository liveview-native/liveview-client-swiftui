//
//  Node+children.swift
//  LightpandaClient
//
//  Created by Carson.Katri on 10/7/25.
//

import SwiftUI
import LightpandaClient

@MainActor
struct NodeView<Library: ElementLibrary>: View {
    let node: Node
    
    @Environment(ModifierParser<Library>.self) private var modifierParser
    
    #if DEBUG
    @Environment(LightpandaRuntime.self) private var runtime
    @Environment(\.lightpandaNamespace) private var lightpandaNamespace
    #endif
    
    var body: some View {
        #if DEBUG
        nodeContent
            .overlay(SwiftUI.Group {
                if runtime.cdp.focusedNode == node.id {
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(.tint.quinary)
                        .stroke(.tint, style: .init(lineWidth: 1))
                        .ignoresSafeArea()
                        .matchedGeometryEffect(id: "lightpanda:focused_node", in: lightpandaNamespace!)
                }
            })
            .environment(node)
        #else
        nodeContent
        #endif
    }
    
    @ViewBuilder
    var nodeContent: some View {
        switch node.type {
        case .element:
            switch node.name {
            case "head", "script":
                EmptyView()
            default:
                if let tagName = Library.TagName(rawValue: node.name) {
                    // Views with context-specific modifiers (Text, Image, Shape) handle their own
                    // modifier parsing and application internally
                    let contextSpecificViews: Set<String> = [
                        "text",
                        "image", "asyncimage",
                        "circle", "ellipse", "capsule", "rectangle", "roundedrectangle", "unevenroundedrectangle"
                    ]
                    
                    if contextSpecificViews.contains(node.name),
                       let _ = node.attributeValue(for: "modifiers") {
                        // Let the view handle all modifiers itself
                        Library.render(tagName, for: node)
                    } else if let style = node.attributeValue(for: "modifiers") {
                        // Generic views: apply all modifiers as ViewModifiers
                        let parsed = modifierParser.parse(style)
                        Library.render(tagName, for: node)
                            .modifier(parsed.allAsViewModifiers)
                    } else {
                        Library.render(tagName, for: node)
                    }
                } else {
                    node.children(library: Library.self)
                }
            }
        case .text:
            if !node.value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                SwiftUI.Text(node.value)
            }
        case .document, .documentFragment, .documentType:
            node.children(library: Library.self)
        default:
            EmptyView()
        }
    }
}

extension Node {
    @MainActor
    public func children<Library: ElementLibrary>(
        library: Library.Type = Library.self
    ) -> some View {
        ForEach(self.children) { child in
            if !child.attributes.keys.contains("template") {
                NodeView<Library>(node: child)
            }
        }
    }
    
    @MainActor
    public func children<Library: ElementLibrary>(
        in template: String,
        default: Bool = false,
        library: Library.Type = Library.self
    ) -> some View {
        ForEach(self.children) { child in
            if child.attributes["template"] == template {
                NodeView<Library>(node: child)
            }
        }
    }
    
    public func attributeValue<V, S: ParseStrategy>(
        for name: String,
        strategy: S
    ) -> V?
        where S.ParseInput == String, S.ParseOutput == V
    {
        return attributes[name.lowercased()].flatMap({ try? strategy.parse($0) })
    }

    public func attributeValue(for name: String) -> String? {
        return attributes[name.lowercased()]
    }

    public func attributeBoolean(for name: String) -> Bool {
        return attributes.keys.contains(name)
    }

    public func hasTemplate(_ template: String, default: Bool = false) -> Bool {
        for child in children {
            if child.attributes["template"] == template { return true }
            if `default` && (child.attributes["template"] == nil || child.attributes["template"] == "") { return true }
        }
        return false
    }

    public func buildPhxValuePayload() -> [String: Any] {
        var payload: [String: Any] = [:]
        for (key, value) in attributes {
            if key.hasPrefix("phx-value-") {
                let name = String(key.dropFirst("phx-value-".count))
                payload[name] = value
            } else if key == "value" {
                payload["value"] = value
            }
        }
        return payload
    }
}

struct ParseError: Error {}

extension ParseStrategy where Self == FloatingPointParseStrategy<FloatingPointFormatStyle<Double>> {
    static var number: FloatingPointParseStrategy<FloatingPointFormatStyle<Double>> { FloatingPointParseStrategy(format: .number) }
}
