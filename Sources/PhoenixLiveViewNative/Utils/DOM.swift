//
//  DOM.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 10/10/22.
//

import LiveViewNativeCore

public typealias Attribute = LiveViewNativeCore.Attribute

/// A wrapper for an element-containing ``Node`` and its ``ElementData``.
public struct ElementNode {
    let node: Node
    let data: ElementData
    
    init(node: Node, data: ElementData) {
        self.node = node
        self.data = data
    }
    
    public func children() -> NodeChildrenSequence { node.children() }
    public func depthFirstChildren() -> NodeDepthFirstChildrenSequence { node.depthFirstChildren() }
    
    public var namespace: String? { data.namespace }
    public var tag: String { data.tag }
    public var attributes: [Attribute] { data.attributes }
    public func attribute(named name: AttributeName) -> Attribute? { node[name] }
    
    public func attributeValue(for name: AttributeName) -> String? {
        attribute(named: name)?.value
    }
    
    public func innerText() -> String {
        // TODO: should follow the spec and insert/collapse whitespace around elements
        self.children().compactMap { node in
            if case .leaf(let content) = node.data {
                return content
            } else {
                return nil
            }
        }
        .joined(separator: " ")
    }
    
    internal func buildPhxValuePayload() -> Payload {
        let prefix = "phx-value-"
        return attributes
            .filter { $0.name.namespace == nil && $0.name.name.starts(with: prefix) }
            .reduce(into: [:]) { partialResult, attr in
                // TODO: for nil attribute values, what value should this use?
                partialResult[String(attr.name.name.dropFirst(prefix.count))] = attr.value
            }
    }
}

//extension ElementNode: Equatable {
//    public static func ==(lhs: ElementNode, rhs: ElementNode) -> Bool {
//        return lhs.node.id == rhs.node.id
//    }
//}

extension Node {
    func asElement() -> ElementNode? {
        if case .element(let data) = self.data {
            return ElementNode(node: self, data: data)
        } else {
            return nil
        }
    }
}
