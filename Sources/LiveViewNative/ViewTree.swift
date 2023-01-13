//
//  ViewTree.swift
// LiveViewNative
//
//  Created by Brian Cardarella on 4/23/21.
//

import Foundation
import SwiftUI
import LiveViewNativeCore

public extension CodingUserInfoKey {
    /// The ``LiveContext`` that is present when a modifier is being decoded.
    static let liveContext = CodingUserInfoKey(rawValue: "LiveViewNative.liveContext")!
}

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
            SwiftUI.Text(content)
        case .element(let element):
            fromElement(ElementNode(node: node, data: element), context: context)
        }
    }
    
    fileprivate func fromElement(_ element: ElementNode, context: LiveContext<R>) -> some View {
        let view = createView(element, context: context)
        let jsonStr = element.attributeValue(for: "modifiers")
        let modified = applyModifiers(encoded: jsonStr, to: view, context: context)
        return modified
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
    
    private func applyModifiers(encoded: String?, to view: some View, context: LiveContext<R>) -> some View {
        let modifiers: [ModifierContainer<R>]
        if let encoded {
            let decoder = JSONDecoder()
            decoder.userInfo[.liveContext] = context
            if let decoded = try? decoder.decode([ModifierContainer<R>].self, from: Data(encoded.utf8)) {
                modifiers = decoded
            } else {
                modifiers = []
            }
        } else {
            modifiers = []
        }
        return view.applyModifiers(modifiers[...], context: context)
    }
}

extension ViewTreeBuilder {
    enum Error: Swift.Error {
        case unknownModifierType
        
        var localizedDescription: String {
            switch self {
            case .unknownModifierType:
                return "The modifier type is not builtin and is not declared by the custom registry."
            }
        }
    }
}

struct ModifierContainer<R: CustomRegistry>: Decodable {
    let modifier: any ViewModifier
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        if let type = R.ModifierType(rawValue: type) {
            let context = decoder.userInfo[.liveContext] as! LiveContext<R>
            do {
                self.modifier = try R.decodeModifier(type, from: decoder, context: context)
            } catch {
                self.modifier = ErrorModifier(type: type.rawValue, error: error)
            }
        } else if let type = BuiltinRegistry.ModifierType(rawValue: type) {
            do {
                self.modifier = try BuiltinRegistry.decodeModifier(type, from: decoder)
            } catch {
                self.modifier = ErrorModifier(type: type.rawValue, error: error)
            }
        } else {
            self.modifier = ErrorModifier(type: type, error: ViewTreeBuilder<R>.Error.unknownModifierType)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case type
    }
}

// this view is required to to break the infinitely-recursive type that occurs if the body of this view is inlined into applyAttributes(_:context:)
private struct ModifierApplicator<Parent: View, R: CustomRegistry>: View {
    let parent: Parent
    let modifiers: ArraySlice<ModifierContainer<R>>
    let context: LiveContext<R>

    var body: some View {
        let remaining = modifiers[modifiers.index(after: modifiers.startIndex)...]
        // force-unwrap is okay, this view is never  constructed with an empty slice
        modifiers.first!.modifier.apply(to: parent)
            .applyModifiers(remaining, context: context)
    }
}

private extension View {
    @ViewBuilder
    func applyModifiers<R: CustomRegistry>(_ modifiers: ArraySlice<ModifierContainer<R>>, context: LiveContext<R>) -> some View {
        if modifiers.isEmpty {
            self
        } else {
            ModifierApplicator(parent: self, modifiers: modifiers, context: context)
        }
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
