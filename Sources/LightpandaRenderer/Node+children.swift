//
//  Node+children.swift
//  LightpandaClient
//
//  Created by Carson.Katri on 10/7/25.
//

import SwiftUI
import LightpandaClient

extension Node {
    @MainActor
    public func children<Library: ElementLibrary>(
        library: Library.Type = Library.self
    ) -> some View {
        ForEach(self.children) { child in
            NodeView<Library>(node: child)
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
        return attributes[name].flatMap({ try? strategy.parse($0) })
    }

    public func attributeValue(for name: String) -> String? {
        return attributes[name]
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
