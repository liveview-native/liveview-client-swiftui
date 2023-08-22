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
/// <ToolbarItem placement="destructive-action">
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
/// <ToolbarItem id="delete" customization-behavior="disabled">
///     ...
/// </ToolbarItem>
/// ```
///
/// The default visibility and options can be configured with the ``CustomizableToolbarItem/defaultVisibility`` and ``CustomizableToolbarItem/alwaysAvailable`` attributes.
///
/// ```html
/// <ToolbarItem id="delete" default-visibility="hidden" always-available>
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
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ToolbarItem<R: RootRegistry>: ToolbarContent {
    @ObservedElement private var element
    @LiveContext<R> private var context
    
    /// The position of this item in the toolbar.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("placement", transform: { _ in fatalError() }) private var placement: SwiftUI.ToolbarItemPlacement
    
    init(element: ElementNode) {
        self._element = .init(element: element)
        self._placement = .init("placement", transform: {
            (try? ToolbarItemPlacement(from: $0))?.placement ?? .automatic
        }, element: element)
    }
    
    var body: some ToolbarContent {
        SwiftUI.ToolbarItem(placement: placement) {
            context.buildChildren(of: element)
        }
    }
}

/// See ``ToolbarItem``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct CustomizableToolbarItem<R: RootRegistry>: CustomizableToolbarContent {
    @ObservedElement private var element
    @LiveContext<R> private var context
    
    private var placement: SwiftUI.ToolbarItemPlacement {
        (try? ToolbarItemPlacement(from: element.attribute(named: "placement")))?.placement ?? .automatic
    }
    
    /// The unique ID for this customizable item.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("id") private var id: String
    
    /// The visibility of the item when the toolbar is not customized.
    ///
    /// Possible values:
    /// * `visible`
    /// * `hidden`
    ///
    /// When set to `hidden`, the item must be added to the toolbar by the user to be visible.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("default-visibility", transform: { _ in fatalError() }) private var defaultVisibility: Visibility
    
    /// Ensures the item is available in the overflow menu if removed from the toolbar.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("always-available") private var alwaysAvailable: Bool = false
    
    /// Changes the level of customization for this item.
    ///
    /// Possible values:
    /// * `default`
    /// * `disabled` - The item is not customizable.
    /// * `reorderable` - The item can be reordered, but not removed.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("customization-behavior", transform: { _ in fatalError() }) private var customizationBehavior: ToolbarCustomizationBehavior
    
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
        self._alwaysAvailable = .init(wrappedValue: false, "always-available", element: element)
        self._customizationBehavior = .init(wrappedValue: .default, "customization-behavior", transform: {
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
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
enum ToolbarItemPlacement: String, AttributeDecodable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case automatic
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case principal
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case navigation
    /// `primary-action`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case primaryAction = "primary-action"
    /// `secondary-action`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case secondaryAction = "secondary-action"
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case status
    /// `confirmation-action`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case confirmationAction = "confirmation-action"
    /// `cancellation-action`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case cancellationAction = "cancellation-action"
    /// `destructive-action`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case destructiveAction = "destructive-action"
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case keyboard
    
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
        }
    }
}
