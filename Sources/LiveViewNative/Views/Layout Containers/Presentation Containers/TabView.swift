//
//  TabView.swift
//
//
//  Created by Carson Katri on 3/2/23.
//

import SwiftUI
import LiveViewNativeCore
import OSLog

private let logger = Logger(subsystem: "LiveViewNative", category: "TabView")

/// Container that presents content on separate pages.
///
/// Each child element will become its own tab.
///
/// ```html
/// <TabView class="tab-view-style-page">
///     <Rectangle fillColor="system-red" />
///     <Rectangle fillColor="system-red" />
///     <Rectangle fillColor="system-red" />
/// </TabView>
/// ```
///
/// The icon shown in the index view can be configured with the ``TabItemModifier`` modifier.
///
/// ## Bindings
/// * ``selection``
@_documentation(visibility: public)
@MainActor
@LiveElement
struct TabView<Root: RootRegistry>: View {
    /// Synchronizes the selected tab with the server.
    ///
    /// Use the ``TagModifier`` modifier to set the selection value for a given tab.
    @_documentation(visibility: public)
    @ChangeTracked(attribute: "selection") private var selection: String? = nil
    
    @LiveAttribute(.init(name: "selection")) var selectionAttribute: String?
    @LiveAttribute(.init(name: "phx-change")) var changeAttribute: String?
    
    var body: some View {
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *),
           $liveElement.childNodes.contains(where: {
               guard case let .element(element) = $0.data else { return false }
               return element.tag == "Tab"
           })
        {
            if selectionAttribute != nil || changeAttribute != nil {
                SwiftUI.TabView(selection: $selection) {
                    TabTreeBuilder<Root, String?>().fromNodes($liveElement.childNodes, context: $liveElement.context.storage)
                }
            } else {
                SwiftUI.TabView {
                    TabTreeBuilder<Root, Never>().fromNodes($liveElement.childNodes, context: $liveElement.context.storage)
                }
            }
        } else {
            SwiftUI.TabView(
                selection: (selectionAttribute != nil || changeAttribute != nil) ? $selection : nil
            ) {
                $liveElement.children()
            }
        }
    }
}

/// A builder for `TabContent`.
@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
@MainActor
struct TabTreeBuilder<Root: RootRegistry, TabValue: Hashable> {
    func fromNodes<Nodes>(_ nodes: Nodes, context: LiveContextStorage<Root>) -> some TabContent<TabValue>
        where Nodes: RandomAccessCollection, Nodes.Index == Int, Nodes.Element == Node
    {
        ForEach(nodes, id: \.id) { node in
            fromNode(node, context: context)
        }
    }
    
    @TabContentBuilder<TabValue>
    fileprivate func fromNode(_ node: Node, context: LiveContextStorage<Root>) -> some TabContent<TabValue> {
        // ToolbarTreeBuilder.fromNode may not be called with a root or leaf node
        if case .element(let element) = node.data {
            Self.lookup(ElementNode(node: node, data: element))
        }
    }
    
    @TabContentBuilder<TabValue>
    static func lookup(_ node: ElementNode) -> some TabContent<TabValue> {
        if node.tag == "Tab" {
            Tab<Root, TabValue>(element: node)
        } else if node.tag == "TabSection" {
            Tab<Root, TabValue>(element: node) // todo
        }
    }
}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
@MainActor
struct Tab<Root: RootRegistry, TabValue: Hashable>: TabContent {
    @ObservedElement private var element: ElementNode
    @LiveContext<Root> private var context
    
    init(element: ElementNode) {
        self._element = .init(element: element)
    }
    
    var body: some TabContent<TabValue> {
        if TabValue.self == Never.self {
            noValueTab
        } else if TabValue.self == String?.self {
            stringValueTab
        }
    }
    
    @TabContentBuilder<TabValue>
    var noValueTab: some TabContent<TabValue> {
        if let title,
           let image
        {
            SwiftUI.Tab(title, image: image, role: role) {
                content
            }
            .forceCast(as: TabValue.self)
        } else if let title,
                  let systemImage
        {
            SwiftUI.Tab(title, systemImage: systemImage, role: role) {
                content
            }
            .forceCast(as: TabValue.self)
        } else {
            SwiftUI.Tab(role: role) {
                content
            } label: {
                label
            }
            .forceCast(as: TabValue.self)
        }
    }
    
    @TabContentBuilder<TabValue>
    var stringValueTab: some TabContent<TabValue> {
        let value = try? element.attributeValue(String.self, for: "value")
        if let title,
           let image
        {
            SwiftUI.Tab(title, image: image, value: value, role: role) {
                content
            }
            .forceCast(as: TabValue.self)
        } else if let title,
                  let systemImage
        {
            SwiftUI.Tab(title, systemImage: systemImage, value: value, role: role) {
                content
            }
            .forceCast(as: TabValue.self)
        } else {
            SwiftUI.Tab(value: value, role: role) {
                content
            } label: {
                label
            }
            .forceCast(as: TabValue.self)
        }
    }
    
    var title: String? { element.attributeValue(for: "title") }
    var image: String? { element.attributeValue(for: "image") }
    var systemImage: String? { element.attributeValue(for: "systemImage") }
    var role: TabRole? { try? element.attributeValue(TabRole.self, for: "role") }
    
    var content: some View {
        context.buildChildren(of: element, forTemplate: "content", includeDefaultSlot: true)
    }
    
    var label: some View {
        context.buildChildren(of: element, forTemplate: "label")
    }
}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
extension SwiftUI.Tab {
    func forceCast<V: Hashable>(as valueType: V.Type = V.self) -> SwiftUI.Tab<V, Content, Label> {
        self as! SwiftUI.Tab<V, Content, Label>
    }
}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
extension TabRole: AttributeDecodable {
    public init(from attribute: Attribute?, on element: ElementNode) throws {
        guard let value = attribute?.value
        else { throw AttributeDecodingError.missingAttribute(Self.self) }
        
        switch value {
        case "search":
            self = .search
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}
