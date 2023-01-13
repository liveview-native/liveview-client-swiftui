//
//  DOM.swift
// LiveViewNative
//
//  Created by Shadowfacts on 10/10/22.
//

import LiveViewNativeCore

/// An attribute is a key-value pair of an attribute name (with an optional namespace) and an optional value.
public typealias Attribute = LiveViewNativeCore.Attribute

/// A wrapper for an element-containing DOM node and its associated data.
///
/// ## Topics
/// ### Tag Info
/// - ``namespace``
/// - ``tag``
/// ### Accessing Attributes
/// - ``attributes``
/// - ``attribute(named:)``
/// - ``attributeValue(for:)``
/// ### Accessing Children
/// - ``children()``
/// - ``depthFirstChildren()``
/// - ``innerText()``
public struct ElementNode {
    let node: Node
    let data: ElementData
    
    init(node: Node, data: ElementData) {
        self.node = node
        self.data = data
    }
    
    /// A sequence representing this element's direct children.
    public func children() -> NodeChildrenSequence { node.children() }
    /// A sequence that traverses the nested child nodes of this element in depth-first order.
    public func depthFirstChildren() -> NodeDepthFirstChildrenSequence { node.depthFirstChildren() }
    
    /// The namespace of the element.
    public var namespace: String? { data.namespace }
    /// The tag name of the element.
    public var tag: String { data.tag }
    /// The list of attributes present on this element.
    public var attributes: [Attribute] { data.attributes }
    /// The attribute with the given name, or `nil` if there is no such attribute.
    ///
    /// ## Discussion
    /// Because `AttributeName` conforms to `ExpressibleByStringLiteral`, you can directly use a string literal as the attribute name:
    /// ```swift
    /// element.attribute(named: "my-attr")
    /// ```
    public func attribute(named name: AttributeName) -> Attribute? { node[name] }
    
    /// The value of the attribute with the given name, or `nil` if there is no such attribute.
    ///
    /// ## Discussion
    /// Because `AttributeName` conforms to `ExpressibleByStringLiteral`, you can directly use a string literal as the attribute name:
    /// ```swift
    /// element.attributeValue(for: "my-attr")
    /// ```
    public func attributeValue(for name: AttributeName) -> String? {
        attribute(named: name)?.value
    }
    
    /// The text of this element.
    ///
    /// The returned string only incorporates the direct text node children, not any text nodes within nested elements.
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

extension Node {
    func asElement() -> ElementNode? {
        if case .element(let data) = self.data {
            return ElementNode(node: self, data: data)
        } else {
            return nil
        }
    }
}
