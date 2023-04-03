//
//  ToolbarModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 3/29/2023.
//

import SwiftUI
import LiveViewNativeCore

/// Changes the anchor point of an element in a grid.
///
/// Use the available toolbar elements to place items in the toolbar.
///
/// ```html
/// <Text modifiers={toolbar(@native, content: :my_toolbar_content)}>
///     ...
///     <toolbar:my_toolbar_content>
///         <ToolbarItem placement="confirmation-action">
///             <Button phx-click="save">Save</Button>
///         </ToolbarItem>
///         <ToolbarItem placement="cancellation-action">
///             <Button phx-click="cancel">Cancel</Button>
///         </ToolbarItem>
///     </toolbar:my_toolbar_content>
/// </Text>
/// ```
///
/// ### Toolbar Elements
/// The following elements can be used within the toolbar content:
///
/// * ``ToolbarItem``
/// * ``ToolbarItemGroup``
/// * ``ToolbarTitleMenu``
///
/// ### Customizable Toolbars
/// If an ``id`` is specified on the toolbar modifier the toolbar will be customizable.
///
/// - Precondition: All ``ToolbarItem`` elements in a customizable toolbar *must* have an `id` attribute.
///
/// - Note: ``ToolbarItemGroup`` cannot be used in a customizable toolbar.
///
/// ```html
/// <Text modifiers={toolbar(@native, id: "my-main-bar", content: :editable_bar)}>
///     ...
///     <toolbar:editable_bar>
///         <ToolbarItem id="search" placement="secondary-action">
///             <TextField text-field-style="rounded-border">Search for photos...</TextField>
///         </ToolbarItem>
///         <ToolbarItem id="actions" customization-behavior="disabled">
///             <Button phx-click="search">Search</Button>
///         </ToolbarItem>
///         <ToolbarItem id="history" visibility="hidden" always-available>
///             <Button phx-click="search">Open History</Button>
///         </ToolbarItem>
///         <ToolbarItem id="spacer" visibility="hidden">
///             <Spacer />
///         </ToolbarItem>
///     </toolbar:editable_bar>
/// </Text>
/// ```
///
/// ## Arguments
/// * ``id``
/// * ``content``
///
/// ## See Also
/// ### Toolbars
/// * ``ToolbarItem``
/// * ``ToolbarItemGroup``
/// * ``ToolbarTitleMenu``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ToolbarModifier<R: RootRegistry>: ViewModifier, Decodable {
    /// A unique identifier for a customizable toolbar.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let id: String?

    /// The name of the element with the toolbar content.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let content: String
    
    @ObservedElement private var element
    @LiveContext<R> private var context

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.content = try container.decode(String.self, forKey: .content)
    }

    func body(content: Content) -> some View {
        if let id {
            content.toolbar(id: id) {
                CustomizableToolbarTreeBuilder<R>().fromNodes(
                    context.children(of: element, withTagName: self.content, namespace: "toolbar").flatMap { $0.children() },
                    context: context.storage
                )
            }
        } else {
            content.toolbar {
                ToolbarTreeBuilder<R>().fromNodes(
                    context.children(of: element, withTagName: self.content, namespace: "toolbar").flatMap { $0.children() },
                    context: context.storage
                )
            }
        }
    }

    enum CodingKeys: String, CodingKey {
        case id
        case content
    }
}

/// A builder for `ToolbarContent`.
struct ToolbarTreeBuilder<R: RootRegistry> {
    func fromNodes<Nodes>(_ e: Nodes, context c: LiveContextStorage<R>) -> some ToolbarContent
        where Nodes: RandomAccessCollection, Nodes.Index == Int, Nodes.Element == Node
    {
        switch e.count {
        case 1:
            return ToolbarContentBuilder.buildBlock(f(e[0], c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c))
        case 2:
            return ToolbarContentBuilder.buildBlock(f(e[0], c), f(e[1], c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c))
        case 3:
            return ToolbarContentBuilder.buildBlock(f(e[0], c), f(e[1], c), f(e[2], c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c))
        case 4:
            return ToolbarContentBuilder.buildBlock(f(e[0], c), f(e[1], c), f(e[2], c), f(e[3], c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c))
        case 5:
            return ToolbarContentBuilder.buildBlock(f(e[0], c), f(e[1], c), f(e[2], c), f(e[3], c), f(e[4], c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c))
        case 6:
            return ToolbarContentBuilder.buildBlock(f(e[0], c), f(e[1], c), f(e[2], c), f(e[3], c), f(e[4], c), f(e[5], c), f(nil, c), f(nil, c), f(nil, c), f(nil, c))
        case 7:
            return ToolbarContentBuilder.buildBlock(f(e[0], c), f(e[1], c), f(e[2], c), f(e[3], c), f(e[4], c), f(e[5], c), f(e[6], c), f(nil, c), f(nil, c), f(nil, c))
        case 8:
            return ToolbarContentBuilder.buildBlock(f(e[0], c), f(e[1], c), f(e[2], c), f(e[3], c), f(e[4], c), f(e[5], c), f(e[6], c), f(e[7], c), f(nil, c), f(nil, c))
        case 9:
            return ToolbarContentBuilder.buildBlock(f(e[0], c), f(e[1], c), f(e[2], c), f(e[3], c), f(e[4], c), f(e[5], c), f(e[6], c), f(e[7], c), f(e[8], c), f(nil, c))
        case 10:
            return ToolbarContentBuilder.buildBlock(f(e[0], c), f(e[1], c), f(e[2], c), f(e[3], c), f(e[4], c), f(e[5], c), f(e[6], c), f(e[7], c), f(e[8], c), f(e[9], c))
        default:
            fatalError("Too many children in toolbar content")
        }
    }
    
    // alias for typing
    @inline(__always)
    fileprivate func f(_ n: Node?, _ c: LiveContextStorage<R>) -> some ToolbarContent {
        return n.flatMap({ fromNode($0, context: c) })
    }
    
    @ToolbarContentBuilder
    fileprivate func fromNode(_ node: Node, context: LiveContextStorage<R>) -> some ToolbarContent {
        if case .element(let element) = node.data {
            Self.lookup(ElementNode(node: node, data: element))
        } else {
            fatalError("ToolbarTreeBuilder.fromNode may not be called with a root or leaf node")
        }
    }
    
    @ToolbarContentBuilder
    static func lookup(_ node: ElementNode) -> some ToolbarContent {
        switch node.tag {
        case "ToolbarItemGroup":
            ToolbarItemGroup<R>(element: node)
        case "ToolbarItem":
            ToolbarItem<R>(element: node)
        case "ToolbarTitleMenu":
            ToolbarTitleMenu<R>(element: node)
        default:
            fatalError("Unsupported toolbar content '\(node.tag)'")
        }
    }
}

/// A builder for `CustomizableToolbarContent`.
struct CustomizableToolbarTreeBuilder<R: RootRegistry> {
    func fromNodes<Nodes>(_ e: Nodes, context c: LiveContextStorage<R>) -> some CustomizableToolbarContent
        where Nodes: RandomAccessCollection, Nodes.Index == Int, Nodes.Element == Node
    {
        switch e.count {
        case 1:
            return ToolbarContentBuilder.buildBlock(f(e[0], c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c))
        case 2:
            return ToolbarContentBuilder.buildBlock(f(e[0], c), f(e[1], c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c))
        case 3:
            return ToolbarContentBuilder.buildBlock(f(e[0], c), f(e[1], c), f(e[2], c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c))
        case 4:
            return ToolbarContentBuilder.buildBlock(f(e[0], c), f(e[1], c), f(e[2], c), f(e[3], c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c))
        case 5:
            return ToolbarContentBuilder.buildBlock(f(e[0], c), f(e[1], c), f(e[2], c), f(e[3], c), f(e[4], c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c))
        case 6:
            return ToolbarContentBuilder.buildBlock(f(e[0], c), f(e[1], c), f(e[2], c), f(e[3], c), f(e[4], c), f(e[5], c), f(nil, c), f(nil, c), f(nil, c), f(nil, c))
        case 7:
            return ToolbarContentBuilder.buildBlock(f(e[0], c), f(e[1], c), f(e[2], c), f(e[3], c), f(e[4], c), f(e[5], c), f(e[6], c), f(nil, c), f(nil, c), f(nil, c))
        case 8:
            return ToolbarContentBuilder.buildBlock(f(e[0], c), f(e[1], c), f(e[2], c), f(e[3], c), f(e[4], c), f(e[5], c), f(e[6], c), f(e[7], c), f(nil, c), f(nil, c))
        case 9:
            return ToolbarContentBuilder.buildBlock(f(e[0], c), f(e[1], c), f(e[2], c), f(e[3], c), f(e[4], c), f(e[5], c), f(e[6], c), f(e[7], c), f(e[8], c), f(nil, c))
        case 10:
            return ToolbarContentBuilder.buildBlock(f(e[0], c), f(e[1], c), f(e[2], c), f(e[3], c), f(e[4], c), f(e[5], c), f(e[6], c), f(e[7], c), f(e[8], c), f(e[9], c))
        default:
            fatalError("Too many children in toolbar content")
        }
    }
    
    // alias for typing
    @inline(__always)
    fileprivate func f(_ n: Node?, _ c: LiveContextStorage<R>) -> some CustomizableToolbarContent {
        return n.flatMap({ fromNode($0, context: c) })
    }
    
    @ToolbarContentBuilder
    fileprivate func fromNode(_ node: Node, context: LiveContextStorage<R>) -> some CustomizableToolbarContent {
        if case .element(let element) = node.data {
            Self.lookup(ElementNode(node: node, data: element))
        } else {
            fatalError("CustomizableToolbarTreeBuilder.fromNode may not be called with a root or leaf node")
        }
    }
    
    @ToolbarContentBuilder
    static func lookup(_ node: ElementNode) -> some CustomizableToolbarContent {
        switch node.tag {
        case "ToolbarItem":
            CustomizableToolbarItem<R>(element: node)
        case "ToolbarTitleMenu":
            ToolbarTitleMenu<R>(element: node)
        default:
            fatalError("Unsupported toolbar content '\(node.tag)'")
        }
    }
}
