//
//  ToolbarItem.swift
//  
//
//  Created by Carson Katri on 3/30/23.
//

import SwiftUI

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
struct ToolbarItem<R: RootRegistry>: ToolbarContent {
    @ObservedElement private var element
    @LiveContext<R> private var context
    
    /// The position of this item in the toolbar.
    @_documentation(visibility: public)
    @Attribute(.init(name: "placement"), transform: { _ in fatalError() }) private var placement: SwiftUI.ToolbarItemPlacement
    
    init(element: ElementNode) {
        self._element = .init(element: element)
        self._placement = .init("placement", transform: {
            (try? ToolbarItemPlacement(from: $0, on: $1))?.placement ?? .automatic
        }, element: element)
    }
    
    var body: some ToolbarContent {
        SwiftUI.ToolbarItem(placement: placement) {
            context.buildChildren(of: element)
        }
    }
}

/// See ``ToolbarItem``
@_documentation(visibility: public)
struct CustomizableToolbarItem<R: RootRegistry>: CustomizableToolbarContent {
    @ObservedElement private var element
    @LiveContext<R> private var context
    
    private var placement: SwiftUI.ToolbarItemPlacement {
        (try? ToolbarItemPlacement(from: element.attribute(named: "placement"), on: element))?.placement ?? .automatic
    }
    
    /// The unique ID for this customizable item.
    @_documentation(visibility: public)
    @Attribute(.init(name: "id")) private var id: String
    
    /// The visibility of the item when the toolbar is not customized.
    ///
    /// Possible values:
    /// * `visible`
    /// * `hidden`
    ///
    /// When set to `hidden`, the item must be added to the toolbar by the user to be visible.
    @_documentation(visibility: public)
    @Attribute(.init(name: "defaultVisibility"), transform: { _ in fatalError() }) private var defaultVisibility: Visibility
    
    /// Ensures the item is available in the overflow menu if removed from the toolbar.
    @_documentation(visibility: public)
    @Attribute(.init(name: "alwaysAvailable")) private var alwaysAvailable: Bool = false
    
    /// Changes the level of customization for this item.
    ///
    /// Possible values:
    /// * `default`
    /// * `disabled` - The item is not customizable.
    /// * `reorderable` - The item can be reordered, but not removed.
    @_documentation(visibility: public)
    @Attribute(.init(name: "customizationBehavior"), transform: { _ in fatalError() }) private var customizationBehavior: ToolbarCustomizationBehavior
    
    init(element: ElementNode) {
        self._element = .init(element: element)
        self._id = .init("id", element: element)
        self._defaultVisibility = .init(wrappedValue: .automatic, "visibility", transform: {
            switch $0?.value {
            case "visible": return .visible
            case "hidden": return .hidden
            default: return .automatic
            }
        }, element: element)
        self._alwaysAvailable = .init(wrappedValue: false, "alwaysAvailable", element: element)
        self._customizationBehavior = .init(wrappedValue: .default, "customizationBehavior", transform: {
            switch $0?.value {
            case "disabled": return .disabled
            case "reorderable": return .reorderable
            default: return .default
            }
        }, element: element)
    }
    
    var body: some CustomizableToolbarContent {
        SwiftUI.ToolbarItem(id: id, placement: placement) {
            context.buildChildren(of: element)
        }
        .defaultCustomization(defaultVisibility, options: alwaysAvailable ? .alwaysAvailable : [])
        .customizationBehavior(customizationBehavior)
    }
}

/// The positioning of a toolbar item.
@_documentation(visibility: public)
enum ToolbarItemPlacement: String, AttributeDecodable {
    @_documentation(visibility: public)
    case automatic
    @_documentation(visibility: public)
    case principal
    @_documentation(visibility: public)
    case navigation
    @_documentation(visibility: public)
    case primaryAction
    @_documentation(visibility: public)
    case secondaryAction
    @_documentation(visibility: public)
    case status
    @_documentation(visibility: public)
    case confirmationAction
    @_documentation(visibility: public)
    case cancellationAction
    @_documentation(visibility: public)
    case destructiveAction
    @_documentation(visibility: public)
    case keyboard
    @_documentation(visibility: public)
    case topBarLeading
    @_documentation(visibility: public)
    case topBarTrailing
    @_documentation(visibility: public)
    case bottomBar
    
    var placement: SwiftUI.ToolbarItemPlacement {
        switch self {
        case .automatic: return .automatic
        case .principal:
            #if os(watchOS)
            return .automatic
            #else
            return .principal
            #endif
        case .navigation:
            #if os(watchOS)
            return .automatic
            #else
            return .navigation
            #endif
        case .primaryAction: return .primaryAction
        case .secondaryAction:
            #if os(watchOS) || os(tvOS)
            return .automatic
            #else
            return .secondaryAction
            #endif
        case .status:
            #if os(watchOS) || os(tvOS)
            return .automatic
            #else
            return .status
            #endif
        case .confirmationAction: return .confirmationAction
        case .cancellationAction: return .cancellationAction
        case .destructiveAction: return .destructiveAction
        case .keyboard:
            #if os(watchOS) || os(tvOS)
            return .automatic
            #else
            return .keyboard
            #endif
        case .topBarLeading:
            #if os(macOS)
            return .automatic
            #else
            if #available(watchOS 10, *) {
                return .topBarLeading
            } else {
                return .automatic
            }
            #endif
        case .topBarTrailing:
            #if os(macOS)
            return .automatic
            #else
            if #available(watchOS 10, *) {
                return .topBarTrailing
            } else {
                return .automatic
            }
            #endif
        case .bottomBar:
            #if os(macOS) || os(tvOS)
            return .automatic
            #else
            if #available(watchOS 10, *) {
                return .bottomBar
            } else {
                return .automatic
            }
            #endif
        }
    }
}
