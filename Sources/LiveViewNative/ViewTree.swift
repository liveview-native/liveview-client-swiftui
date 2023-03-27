//
//  ViewTree.swift
// LiveViewNative
//
//  Created by Brian Cardarella on 4/23/21.
//

import Foundation
import SwiftUI
import LiveViewNativeCore

struct ViewTreeBuilder<R: RootRegistry> {
    func fromNodes(_ nodes: NodeChildrenSequence, coordinator: LiveViewCoordinator<R>, url: URL) -> some View {
        let context = LiveContextStorage(coordinator: coordinator, url: url)
        return fromNodes(nodes, context: context)
            .environment(\.anyLiveContextStorage, context)
    }
    
    @ViewBuilder
    func fromNodes<Nodes>(_ nodes: Nodes, context: LiveContextStorage<R>) -> some View
        where Nodes: RandomAccessCollection, Nodes.Index == Int, Nodes.Element == Node
    {
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
    fileprivate func f(_ n: Node, _ c: LiveContextStorage<R>) -> some View {
        return fromNode(n, context: c)
    }
    
    @ViewBuilder
    fileprivate func fromNode(_ node: Node, context: LiveContextStorage<R>) -> some View {
        switch node.data {
        case .root:
            fatalError("ViewTreeBuilder.fromNode may not be called with the root node")
        case .leaf(let content):
            SwiftUI.Text(content)
        case .element(let element):
            fromElement(ElementNode(node: node, data: element), context: context)
        }
    }
    
    fileprivate func fromElement(_ element: ElementNode, context: LiveContextStorage<R>) -> some View {
        let view = createView(element, context: context)
        let jsonStr = element.attributeValue(for: "modifiers")
        let modified = applyModifiers(encoded: jsonStr, to: view, element: element, context: context)
        let bound = applyBindings(to: modified, element: element, context: context)
        let withID = applyID(element: element, to: bound)
        return withID
            .environment(\.element, element)
            .preference(key: ProvidedBindingsKey.self, value: []) // reset for the next View.
    }
    
    @ViewBuilder
    private func applyID(element: ElementNode, to view: some View) -> some View {
        if let id = element.attributeValue(for: "id") {
            view.id(id)
        } else {
            view
        }
    }
    
    @ViewBuilder
    private func createView(_ element: ElementNode, context: LiveContextStorage<R>) -> some View {
        if let tagName = R.TagName(rawValue: element.tag) {
            R.lookup(tagName, element: element)
        } else {
            BuiltinRegistry<R>.lookup(element.tag, element)
        } 
    }
    
    private func applyModifiers(encoded: String?, to view: some View, element: ElementNode, context: LiveContextStorage<R>) -> some View {
        let modifiers: [ModifierContainer<R>]
        if let encoded {
            let decoder = JSONDecoder()

            if let decoded = try? decoder.decode([ModifierContainer<R>].self, from: Data(encoded.utf8)) {
                modifiers = decoded
            } else {
                modifiers = []
            }
        } else {
            modifiers = []
        }
        return view.applyModifiers(modifiers[...], element: element, context: context)
    }
    
    @ViewBuilder
    private func applyBindings<R: RootRegistry>(
        to view: some View,
        element: ElementNode,
        context: LiveContextStorage<R>
    ) -> some View {
        view.applyBindings(
            element.attributes.filter({
                $0.name.rawValue.starts(with: "phx-") && $0.value != nil
            })[...],
            element: element,
            context: context
        )
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

enum ModifierContainer<R: RootRegistry>: Decodable {
    case builtin(BuiltinRegistry<R>.BuiltinModifier)
    case custom(R.CustomModifier)
    case error(ErrorModifier)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        if let type = R.ModifierType(rawValue: type) {
            do {
                self = .custom(try R.decodeModifier(type, from: decoder))
            } catch {
                self = .error(ErrorModifier(type: type.rawValue, error: error))
            }
        } else if let type = BuiltinRegistry<R>.ModifierType(rawValue: type) {
            do {
                self = .builtin(try BuiltinRegistry<R>.decodeModifier(type, from: decoder))
            } catch {
                self = .error(ErrorModifier(type: type.rawValue, error: error))
            }
        } else {
            self = .error(ErrorModifier(type: type, error: ViewTreeBuilder<R>.Error.unknownModifierType))
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case type
    }
    
    @ViewModifierBuilder
    var modifier: some ViewModifier {
        switch self {
        case let .builtin(modifier):
            modifier
        case let .custom(modifier):
            modifier
        case let .error(modifier):
            modifier
        }
    }
}

// this view is required to to break the infinitely-recursive type that occurs if the body of this view is inlined into applyAttributes(_:context:)
private struct ModifierApplicator<Parent: View, R: RootRegistry>: View {
    let parent: Parent
    let modifiers: ArraySlice<ModifierContainer<R>>
    let element: ElementNode
    let context: LiveContextStorage<R>

    var body: some View {
        let remaining = modifiers.dropFirst()
        // force-unwrap is okay, this view is never constructed with an empty slice
        parent.modifier(modifiers.first!.modifier)
            .applyModifiers(remaining, element: element, context: context)
    }
}

private struct BindingApplicator<Parent: View, R: RootRegistry>: View {
    let parent: Parent
    let bindings: ArraySlice<LiveViewNativeCore.Attribute>
    let element: ElementNode
    let context: LiveContextStorage<R>

    var body: some View {
        let remaining = bindings.dropFirst()
        // force-unwrap is okay, this view is never constructed with an empty slice
        let binding = bindings.first!
        BuiltinRegistry<R>.applyBinding(
            binding.name,
            event: binding.value!,
            value: element.buildPhxValuePayload(),
            to: parent,
            element: element
        )
        .applyBindings(remaining, element: element, context: context)
    }
}

private extension View {
    @ViewBuilder
    func applyModifiers<R: RootRegistry>(_ modifiers: ArraySlice<ModifierContainer<R>>, element: ElementNode, context: LiveContextStorage<R>) -> some View {
        if modifiers.isEmpty {
            self
        } else {
            ModifierApplicator(parent: self, modifiers: modifiers, element: element, context: context)
        }
    }
    
    @ViewBuilder
    func applyBindings<R: RootRegistry>(_ bindings: ArraySlice<LiveViewNativeCore.Attribute>, element: ElementNode, context: LiveContextStorage<R>) -> some View {
        if bindings.isEmpty {
            self
        } else {
            BindingApplicator(parent: self, bindings: bindings, element: element, context: context)
        }
    }
}

// not fileprivate because it's used by LiveContext
// this cannot be "NodeView" because it's used by forEach which requires element ids, which leaf nodes can't have
internal struct ElementView<R: RootRegistry>: View {
    let element: ElementNode
    let context: LiveContextStorage<R>
    
    var body: some View {
        context.coordinator.builder.fromElement(element, context: context)
    }
}

// not fileprivate because List needs ot use it so it has access to ForEach modifiers
func forEach<R: CustomRegistry>(nodes: some Collection<Node>, context: LiveContextStorage<R>) -> ForEach<[(ElementNode, String)], String, some View> {
    let elements = nodes.map { (node) -> (ElementNode, String) in
        guard let element = node.asElement() else {
            preconditionFailure("node in list or parent with more than 10 children must be an element")
        }
        guard let id = element.attributeValue(for: "id") else {
            preconditionFailure("element in list or parent with more than 10 children must have an id")
        }
        return (element, id)
    }
    return ForEach(elements, id: \.1) {
        ElementView<R>(element: $0.0, context: context)
    }
}
