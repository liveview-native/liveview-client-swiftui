//
//  ToolbarItem.swift
//  
//
//  Created by Carson Katri on 3/30/23.
//

import SwiftUI
import LiveViewNativeCore

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
@LiveElement
struct ToolbarItem<Root: RootRegistry>: ToolbarContent {
    /// The position of this item in the toolbar.
    @_documentation(visibility: public)
    private var placement: ToolbarItemPlacement = .automatic
    
    init(element: ElementNode) {
        self._liveElement = .init(element: element)
    }
    
    var body: some ToolbarContent {
        SwiftUI.ToolbarItem(placement: placement.placement) {
            $liveElement.children()
        }
    }
}

/// See ``ToolbarItem``
@_documentation(visibility: public)
@LiveElement
struct CustomizableToolbarItem<Root: RootRegistry>: CustomizableToolbarContent {
    var placement: ToolbarItemPlacement = .automatic
    
    /// The unique ID for this customizable item.
    @_documentation(visibility: public)
    private var id: String?
    
    /// The visibility of the item when the toolbar is not customized.
    ///
    /// Possible values:
    /// * `visible`
    /// * `hidden`
    ///
    /// When set to `hidden`, the item must be added to the toolbar by the user to be visible.
    @_documentation(visibility: public)
    private var defaultVisibility: Visibility = .automatic
    
    /// Ensures the item is available in the overflow menu if removed from the toolbar.
    @_documentation(visibility: public)
    private var alwaysAvailable: Bool = false
    
    /// Changes the level of customization for this item.
    ///
    /// Possible values:
    /// * `default`
    /// * `disabled` - The item is not customizable.
    /// * `reorderable` - The item can be reordered, but not removed.
    @_documentation(visibility: public)
    private var customizationBehavior: ToolbarCustomizationBehavior = .default
    
    init(element: ElementNode) {
        self._liveElement = .init(element: element)
    }
    
    var body: some CustomizableToolbarContent {
        if let id {
            SwiftUI.ToolbarItem(id: id, placement: placement.placement) {
                $liveElement.children()
            }
            .defaultCustomization(defaultVisibility, options: alwaysAvailable ? .alwaysAvailable : [])
            .customizationBehavior(customizationBehavior)
        } else {
            fatalError("Missing `id` attribute on customizable `ToolbarItem`")
        }
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
    @_documentation(visibility: public)
    case bottomOrnament
    
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
            #if os(watchOS) || os(tvOS) || os(visionOS)
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
        case .bottomOrnament:
            #if os(visionOS)
            return .bottomOrnament
            #else
            return .automatic
            #endif
        }
    }
}

extension ToolbarCustomizationBehavior: AttributeDecodable {
    public init(from attribute: LiveViewNativeCore.Attribute?, on element: ElementNode) throws {
        guard let value = attribute?.value
        else { throw AttributeDecodingError.missingAttribute(Self.self) }
        switch value {
        case "default":
            self = .default
        case "disabled":
            self = .disabled
        case "reorderable":
            self = .reorderable
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}
