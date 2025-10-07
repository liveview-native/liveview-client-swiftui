//
//  ToolbarItem.swift
//  
//
//  Created by Carson Katri on 3/30/23.
//

import SwiftUI
import LightpandaClient

/// Toolbar element for placing items.
///
/// Optionally specify a ``placement`` to reposition the element.
///
/// ```html
/// <ToolbarItem placement="destructiveAction">
///     <Button phx-click="delete">Delete</Button>
/// </ToolbarItem>
/// ```
///
/// ### Customizable Items
/// A customizable toolbar is a toolbar modifier with an `id`.
///
/// ```elixir
/// toolbar(id: "unique-toolbar-id", content: :my_toolbar_content)
/// ```
///
/// - Precondition: All items in a customizable toolbar *must* have an `id` attribute.
///
/// Set the `id` attribute to a unique value on each customizable item.
///
/// ```html
/// <ToolbarItem id="delete">
///     ...
/// </ToolbarItem>
/// ```
///
/// To prevent customization of an item in a customizable toolbar, set the ``CustomizableToolbarItem/customizationBehavior`` attribute to `disabled`.
///
/// ```html
/// <ToolbarItem id="delete" customizationBehavior="disabled">
///     ...
/// </ToolbarItem>
/// ```
///
/// The default visibility and options can be configured with the ``CustomizableToolbarItem/defaultVisibility`` and ``CustomizableToolbarItem/alwaysAvailable`` attributes.
///
/// ```html
/// <ToolbarItem id="delete" defaultVisibility="hidden" alwaysAvailable>
///     ...
/// </ToolbarItem>
/// ```
///
/// ## Attributes
/// * ``placement``
/// * ``CustomizableToolbarItem/id``
/// * ``CustomizableToolbarItem/defaultVisibility``
/// * ``CustomizableToolbarItem/alwaysAvailable``
/// * ``CustomizableToolbarItem/customizationBehavior``
///
/// ## See Also
/// ### Toolbars Modifiers
/// * ``ToolbarModifier`` 
@_documentation(visibility: public)
struct ToolbarItem<Library: ElementLibrary>: ToolbarContent {
    let node: Node
    
    /// The position of this item in the toolbar.
    @_documentation(visibility: public)
    private var placement: ToolbarItemPlacement {
        node.attributeValue(for: "placement", strategy: ToolbarItemPlacementParseStrategy()) ?? .automatic
    }
    
    var body: some ToolbarContent {
        SwiftUI.ToolbarItem(placement: placement) {
            node.children(library: Library.self)
        }
    }
}

/// See ``ToolbarItem``
@_documentation(visibility: public)
struct CustomizableToolbarItem<Library: ElementLibrary>: CustomizableToolbarContent {
    let node: Node
    
    var placement: ToolbarItemPlacement {
        node.attributeValue(for: "placement", strategy: ToolbarItemPlacementParseStrategy()) ?? .automatic
    }
    
    /// The unique ID for this customizable item.
    @_documentation(visibility: public)
    private var id: String? {
        node.attributeValue(for: "id")
    }
    
    /// The visibility of the item when the toolbar is not customized.
    ///
    /// Possible values:
    /// * `visible`
    /// * `hidden`
    ///
    /// When set to `hidden`, the item must be added to the toolbar by the user to be visible.
    @_documentation(visibility: public)
    private var defaultVisibility: Visibility {
        node.attributeValue(for: "defaultVisibility", strategy: VisibilityParseStrategy()) ?? .automatic
    }
    
    /// Ensures the item is available in the overflow menu if removed from the toolbar.
    @_documentation(visibility: public)
    private var alwaysAvailable: Bool {
        node.attributeBoolean(for: "alwaysAvailable")
    }
    
    /// Changes the level of customization for this item.
    ///
    /// Possible values:
    /// * `default`
    /// * `disabled` - The item is not customizable.
    /// * `reorderable` - The item can be reordered, but not removed.
    @_documentation(visibility: public)
    private var customizationBehavior: ToolbarCustomizationBehavior {
        node.attributeValue(for: "customizationBehavior", strategy: ToolbarCustomizationBehaviorParseStrategy()) ?? .default
    }
    
    var body: some CustomizableToolbarContent {
        if let id {
            SwiftUI.ToolbarItem(id: id, placement: placement) {
                node.children(library: Library.self)
            }
            .defaultCustomization(defaultVisibility, options: alwaysAvailable ? .alwaysAvailable : [])
            .customizationBehavior(customizationBehavior)
        } else {
            fatalError("Missing `id` attribute on customizable `ToolbarItem`")
        }
    }
}

struct VisibilityParseStrategy: ParseStrategy {
    func parse(_ value: String) throws -> Visibility {
        switch value {
        case "automatic":
            return .automatic
        case "hidden":
            return .hidden
        case "visible":
            return .visible
        default:
            throw ParseError()
        }
    }
}

struct ToolbarCustomizationBehaviorParseStrategy: ParseStrategy {
    func parse(_ value: String) throws -> ToolbarCustomizationBehavior {
        switch value {
        case "default":
            return .default
        case "disabled":
            return .disabled
        case "reorderable":
            return .reorderable
        default:
            throw ParseError()
        }
    }
}
