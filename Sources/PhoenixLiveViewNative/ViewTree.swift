//
//  ViewTree.swift
//  PhoenixLiveViewNative
//
//  Created by Brian Cardarella on 4/23/21.
//

import Foundation
import SwiftUI
import LiveViewNativeCore

struct ViewTreeBuilder<R: CustomRegistry> {
    func fromNodes(_ nodes: NodeChildrenSequence, coordinator: LiveViewCoordinator<R>, url: URL) -> some View {
        return fromNodes(nodes, context: LiveContext(coordinator: coordinator, url: url))
    }
    
    @ViewBuilder
    func fromNodes(_ nodes: NodeChildrenSequence, context: LiveContext<R>) -> some View {
        let e = nodes
        let c = context
        switch e.count {
        case 0:
            EmptyView()
        case 1:
            f(e[0], c)
        case 2:
            TupleView((f(e[0], c), f(e[1], c)))
        case 3:
            TupleView((f(e[0], c), f(e[1], c), f(e[2], c)))
        case 4:
            TupleView((f(e[0], c), f(e[1], c), f(e[2], c), f(e[3], c)))
        case 5:
            TupleView((f(e[0], c), f(e[1], c), f(e[2], c), f(e[3], c), f(e[4], c)))
        case 6:
            TupleView((f(e[0], c), f(e[1], c), f(e[2], c), f(e[3], c), f(e[4], c), f(e[5], c)))
        case 7:
            TupleView((f(e[0], c), f(e[1], c), f(e[2], c), f(e[3], c), f(e[4], c), f(e[5], c), f(e[6], c)))
        case 8:
            TupleView((f(e[0], c), f(e[1], c), f(e[2], c), f(e[3], c), f(e[4], c), f(e[5], c), f(e[6], c), f(e[7], c)))
        case 9:
            TupleView((f(e[0], c), f(e[1], c), f(e[2], c), f(e[3], c), f(e[4], c), f(e[5], c), f(e[6], c), f(e[7], c), f(e[8], c)))
        case 10:
            TupleView((f(e[0], c), f(e[1], c), f(e[2], c), f(e[3], c), f(e[4], c), f(e[5], c), f(e[6], c), f(e[7], c), f(e[8], c), f(e[9], c)))
        default:
            forEach(nodes: nodes, context: c)
        }
    }
    
    // alias for typing
    @inline(__always)
    fileprivate func f(_ n: Node, _ c: LiveContext<R>) -> some View {
        return fromNode(n, context: c)
    }
    
    @ViewBuilder
    fileprivate func fromNode(_ node: Node, context: LiveContext<R>) -> some View {
        switch node.data {
        case .root:
            fatalError("ViewTreeBuilder.fromNode may not be called with the root node")
        case .leaf(let content):
            Text(content)
        case .element(let element):
            fromElement(ElementNode(node: node, data: element), context: context)
        }
    }
    
    fileprivate func fromElement(_ element: ElementNode, context: LiveContext<R>) -> some View {
        createView(element, context: context)
            .applyAttributes(element.attributes[...], element: element, context: context)
            .environment(\.element, element)
    }
    
    @ViewBuilder
    private func createView(_ element: ElementNode, context: LiveContext<R>) -> some View {
        if let tagName = R.TagName(rawValue: element.tag) {
            R.lookup(tagName, element: element, context: context)
        } else {
            BuiltinRegistry.lookup(element.tag, element, context: context)
        }
    }
    
}

// this view is required to to break the infinitely-recursive type that occurs if the body of this view is inlined into applyAttributes(_:context:)
private struct AttributeApplicator<Parent: View, R: CustomRegistry>: View {
    let parent: Parent
    let attributes: ArraySlice<Attribute>
    let element: ElementNode
    let context: LiveContext<R>
    
    var body: some View {
        let remaining = attributes[attributes.index(after: attributes.startIndex)...]
        parent
            // force-unwrap is okay, this view is never  constructed with an empty slice
            .applyAttribute(attributes.first!, element: element, context: context)
            .applyAttributes(remaining, element: element, context: context)
    }
}

private extension View {
    @ViewBuilder
    func applyAttributes(_ attributes: ArraySlice<Attribute>, element: ElementNode, context: LiveContext<some CustomRegistry>) -> some View {
        if attributes.isEmpty {
            self
        } else {
            AttributeApplicator(parent: self, attributes: attributes, element: element, context: context)
        }
    }
    
    func applyAttribute<R: CustomRegistry>(_ attribute: Attribute, element: ElementNode, context: LiveContext<R>) -> some View {
        // EmptyModifier is used if the attribute is not recognized as builtin or custom modifier
        var modifier: any ViewModifier = EmptyModifier()
        if let name = BuiltinRegistry.AttributeName(rawValue: attribute.name.rawValue) {
            modifier = BuiltinRegistry.lookupModifier(attribute: name, value: attribute.value, context: context)
        } else if let name = R.AttributeName(rawValue: attribute.name.rawValue) {
            modifier = R.lookupModifier(name, value: attribute.value, element: element, context: context)
        }
        return modifier.apply(to: self)
    }
}

private extension ViewModifier {
    func apply<V: View>(to view: V) -> AnyView {
        AnyView(view.modifier(self))
    }
}

// not fileprivate because it's used by LiveContext
// this cannot be "NodeView" because it's used by forEach which requires element ids, which leaf nodes can't have
internal struct ElementView<R: CustomRegistry>: View {
    let element: ElementNode
    let context: LiveContext<R>
    
    var body: some View {
        context.coordinator.builder.fromElement(element, context: context)
    }
}

// not fileprivate because List needs ot use it so it has access to ForEach modifiers
func forEach<R: CustomRegistry>(nodes: NodeChildrenSequence, context: LiveContext<R>) -> ForEach<[(ElementNode, String)], String, ElementView<R>> {
    let elements = nodes.map { (node) -> (ElementNode, String) in
        guard let element = node.asElement() else {
            preconditionFailure("node in list or parent with more than 10 children must be an element")
        }
        guard let id = element.attributeValue(for: "id") else {
            preconditionFailure("element in list or parent with more than 10 children must have an id")
        }
        return (element, id)
    }
    return ForEach(elements, id: \.1) { ElementView(element: $0.0, context: context) }
}
