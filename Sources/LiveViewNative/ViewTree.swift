//
//  ViewTree.swift
// LiveViewNative
//
//  Created by Brian Cardarella on 4/23/21.
//

import Foundation
import SwiftUI
import LiveViewNativeCore
import LiveViewNativeStylesheet

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
        forEach(nodes: nodes, context: context)
    }
    
    struct NodeView: View {
        let node: Node
        let context: LiveContextStorage<R>
        
        var body: some View {
            switch node.data {
            case .root:
                fatalError("ViewTreeBuilder.fromNode may not be called with the root node")
            case .leaf(let content):
                SwiftUI.Text(content)
            case .element(let element):
                context.coordinator.builder.fromElement(ElementNode(node: node, data: element), context: context)
            }
        }
    }
    
    func fromElement(_ element: ElementNode, context: LiveContextStorage<R>) -> some View {
        let view = createView(element, context: context)

        let modified = view.applyModifiers(R.self)
        let bound = applyBindings(to: modified, element: element, context: context)
        let withID = applyID(element: element, to: bound)
        let withIDAndTag = applyTag(element: element, to: withID)

        return withIDAndTag
            .environment(\.element, element)
            .environmentObject(ObservedElement.Observer(element.node.id))
            .preference(key: _ProvidedBindingsKey.self, value: []) // reset for the next View.
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
    private func applyTag(element: ElementNode, to view: some View) -> some View {
        if let tag = element.attributeValue(for: "tag") {
            view.tag(Optional<String>.some(tag))
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
    
    @ViewBuilder
    private func applyBindings(
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

extension CodingUserInfoKey {
    static var modifierAnimationScale: Self { .init(rawValue: "modifierAnimationScale")! }
}

enum ModifierContainer<R: RootRegistry>: ParseableModifierValue {
    case builtin(BuiltinRegistry<R>.BuiltinModifier)
    case custom(R.CustomModifier)
    case error(ErrorModifier<R>)
    case inert
    
    static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            R.CustomModifier.parser(in: context).map({ .custom($0) })
            BuiltinRegistry.BuiltinModifier.parser(in: context).map({ .builtin($0) })
        }
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
        case .inert:
            EmptyModifier()
        }
    }
}

private struct ModifierObserver<Parent: View, R: RootRegistry>: View {
    let parent: Parent
    @ObservedElement private var element
    @LiveContext<R> private var context
    @Attribute("class", transform: { attribute in
        guard let classNames = attribute?.value else { return [] }
        
        return classNames.split(separator: " ")
    }) private var classNames: [Substring]
    
    @Environment(\.stylesheets) private var stylesheets
    
    var body: some View {
        let sheet = stylesheets[ObjectIdentifier(R.self)]
        return parent.applyModifiers(
            classNames.reduce(into: ArraySlice<BuiltinRegistry<R>.BuiltinModifier>()) {
                $0.append(contentsOf: (sheet?.classModifiers(String($1)) ?? []) as! [BuiltinRegistry<R>.BuiltinModifier])
            }
        )
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

private struct ModifierApplicator<Parent: View, R: RootRegistry>: View {
    let parent: Parent
    let modifiers: ArraySlice<BuiltinRegistry<R>.BuiltinModifier>
    
    var body: some View {
        parent
            .modifier(modifiers.first!)
            .applyModifiers(modifiers.dropFirst())
    }
}

extension View {
    func applyModifiers<R: RootRegistry>(_: R.Type = R.self) -> some View {
        ModifierObserver<Self, R>(parent: self)
    }
    
    @ViewBuilder
    func applyModifiers<R: RootRegistry>(_ modifiers: ArraySlice<BuiltinRegistry<R>.BuiltinModifier>) -> some View {
        if modifiers.isEmpty {
            self
        } else {
            ModifierApplicator(parent: self, modifiers: modifiers)
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

private enum ForEachElement: Identifiable {
    case keyed(Node, id: String)
    case unkeyed(Node)
    
    var id: String {
        switch self {
        case let .keyed(_, id):
            return id
        case let .unkeyed(node):
            return "\(node.id)"
        }
    }
    
    var node: Node {
        switch self {
        case let .keyed(node, _),
             let .unkeyed(node):
            return node
        }
    }
}
// not fileprivate because List needs to use it so it has access to ForEach modifiers
func forEach<R: CustomRegistry>(nodes: some Collection<Node>, context: LiveContextStorage<R>) -> some DynamicViewContent {
    let elements = nodes.map { (node) -> ForEachElement in
        if let element = node.asElement(),
           let id = element.attributeValue(for: "id")
        {
            return .keyed(node, id: id)
        } else {
            return .unkeyed(node)
        }
    }
    return ForEach(elements) {
        ViewTreeBuilder<R>.NodeView(node: $0.node, context: context)
    }
}

enum ForEachViewError: LocalizedError {
    case invalidNode
    case missingID
    
    var errorDescription: String? {
        switch self {
        case .invalidNode:
            return "node in list or parent with more than 10 children must be an element"
        case .missingID:
            return "element in list or parent with more than 10 children must have an id"
        }
    }
}
