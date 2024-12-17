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

@MainActor
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

        let modified = ModifierObserver<_, R>(parent: view)
        let bound = applyBindings(to: modified, element: element, context: context)
        let withID = applyID(element: element, to: bound)
        let withIDAndTag = applyTag(element: element, to: withID)

        return ObservedElement.Observer.Applicator(element.node.id) {
            withIDAndTag
                .environment(\.element, element)
        }
            .preference(key: _ProvidedBindingsKey.self, value: []) // reset for the next View.
    }

    @ViewBuilder
    private func applyID(element: ElementNode, to view: some View) -> some View {
        if let id = element.attributeValue(for: .init(name: "id")) {
            view.id(id)
        } else {
            view
        }
    }

    @ViewBuilder
    private func applyTag(element: ElementNode, to view: some View) -> some View {
        if let tag = element.attributeValue(for: .init(name: "tag")) {
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
            element.attributes.compactMap({
                guard $0.name.namespace == nil,
                      $0.value != nil,
                      let name = _EventBinding(rawValue: $0.name.name)
                else { return nil }
                return (name, $0)
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

@MainActor
@propertyWrapper
@LiveElement
struct ClassModifiers<Root: RootRegistry>: @preconcurrency DynamicProperty {
    @LiveAttribute(.init(name: "class")) private var `class`: String?
    @LiveAttribute(.init(name: "style")) private var style: String?
    
    @LiveElementIgnored
    @Environment(\.stylesheet)
    var stylesheet
    
    @LiveElementIgnored
    let overrideStylesheet: Stylesheet<Root>?
    
    init(element: ElementNode, overrideStylesheet: Stylesheet<Root>?) {
        self._liveElement = .init(element: element)
        self.overrideStylesheet = overrideStylesheet
    }
    
    init(overrideStylesheet: Stylesheet<Root>? = nil) {
        self._liveElement = .init(wrappedValue: .init())
        self.overrideStylesheet = overrideStylesheet
    }
    
    @LiveElementIgnored
    var wrappedValue: ArraySlice<BuiltinRegistry<Root>.BuiltinModifier> {
        if _liveElement.isConstant {
            var result = ArraySlice<BuiltinRegistry<Root>.BuiltinModifier>()
            guard let sheet = overrideStylesheet ?? (stylesheet as? Stylesheet<Root>)
            else { return result }
            if let style,
               !style.isEmpty
            {
                result += resolveModifiers(forStyle: style, sheet: sheet)
            }
            if let `class`,
               !`class`.isEmpty
            {
                result += resolveModifiers(forClass: `class`, sheet: sheet)
            }
            return result
        } else {
            return resolvedModifiers
        }
    }
    
    @LiveElementIgnored
    var resolvedModifiers: ArraySlice<BuiltinRegistry<Root>.BuiltinModifier> = .init()
    
    mutating func update() {
        resolvedModifiers.removeAll()
        guard let sheet = overrideStylesheet ?? (stylesheet as? Stylesheet<Root>)
        else { return }
        if let style,
           !style.isEmpty
        {
            resolvedModifiers += resolveModifiers(forStyle: style, sheet: sheet)
        }
        if let `class`,
           !`class`.isEmpty
        {
            resolvedModifiers += resolveModifiers(forClass: `class`, sheet: sheet)
        }
    }
    
    private func resolveModifiers(
        forClass `class`: String,
        sheet: Stylesheet<Root>
    ) -> ArraySlice<BuiltinRegistry<Root>.BuiltinModifier> {
        return `class`
            .components(separatedBy: .whitespacesAndNewlines)
            .reduce(into: ArraySlice<BuiltinRegistry<Root>.BuiltinModifier>()) {
                guard let modifiers = sheet.classes[$1] else { return }
                $0.append(contentsOf: modifiers)
            }
    }
    
    private func resolveModifiers(
        forStyle style: String,
        sheet: Stylesheet<Root>
    ) -> ArraySlice<BuiltinRegistry<Root>.BuiltinModifier> {
        return style
            .split(separator: ";" as Character)
            .reduce(into: ArraySlice<BuiltinRegistry<Root>.BuiltinModifier>()) {
                guard let modifiers = sheet.classes[String($1).trimmingCharacters(in: .whitespacesAndNewlines)] else { return }
                $0.append(contentsOf: modifiers)
            }
    }
}

private struct ModifierObserver<Parent: View, R: RootRegistry>: View {
    let parent: Parent
    @ClassModifiers<R> private var modifiers
    
    var body: some View {
        ModifierApplicator(parent: parent, modifiers: modifiers)
    }
}

extension EnvironmentValues {
    private enum StylesheetKey: @preconcurrency EnvironmentKey {
        @MainActor
        static let defaultValue: Any = Stylesheet<EmptyRegistry>(content: [], classes: [:])
    }
    
    var stylesheet: Any {
        get { self[StylesheetKey.self] }
        set { self[StylesheetKey.self] = newValue }
    }
}

private struct BindingApplicator<Parent: View, R: RootRegistry>: View {
    let parent: Parent
    let bindings: ArraySlice<(_EventBinding, LiveViewNativeCore.Attribute)>
    let element: ElementNode
    let context: LiveContextStorage<R>

    var body: some View {
        let remaining = bindings.dropFirst()
        // force-unwrap is okay, this view is never constructed with an empty slice
        let binding = bindings.first!
        BuiltinRegistry<R>.applyBinding(
            binding.0,
            event: binding.1.value!,
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
        if modifiers.isEmpty {
            parent
        } else {
            var modifiers = modifiers
            ModifierApplicator<_, R>(
                parent: parent.modifier(modifiers.removeFirst()),
                modifiers: modifiers
            )
        }
    }
}

extension View {
    @ViewBuilder
    func applyBindings<R: RootRegistry>(
        _ bindings: ArraySlice<(_EventBinding, LiveViewNativeCore.Attribute)>,
        element: ElementNode,
        context: LiveContextStorage<R>
    ) -> some View {
        if bindings.isEmpty {
            self
        } else {
            BindingApplicator(parent: self, bindings: bindings, element: element, context: context)
        }
    }
}

enum ForEachElement: Identifiable {
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
@MainActor
func forEach<R: CustomRegistry>(nodes: some Collection<Node>, context: LiveContextStorage<R>) -> some DynamicViewContent {
    let elements = nodes.map { (node) -> ForEachElement in
        if let element = node.asElement(),
           let id = element.attributeValue(for: .init(name: "id"))
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
