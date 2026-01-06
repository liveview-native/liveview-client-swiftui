//
//  ToolbarItemGroup.swift
//  
//
//  Created by Carson Katri on 3/30/23.
//

import SwiftUI
import LightpandaClient

/// Toolbar element for placing multiple items.
///
/// Optionally specify a ``placement`` to reposition the elements.
///
/// ```html
/// <ToolbarItemGroup placement="destructiveAction">
///     <Button phx-click="delete">Delete</Button>
///     <Button phx-click="destroy">Destroy</Button>
///     <Button phx-click="eradicate">Eradicate</Button>
/// </ToolbarItemGroup>
/// ```
///
/// - Note: This element cannot be used in a customizable toolbar.
///
/// ## Attributes
/// * ``placement``
///
/// ## See Also
/// ### Toolbars Modifiers
/// * ``ToolbarModifier``
@_documentation(visibility: public)
struct ToolbarItemGroup<Library: ElementLibrary>: ToolbarContent {
    let node: Node
    
    /// The position of this group in the toolbar.
    @_documentation(visibility: public)
    private var placement: ToolbarItemPlacement {
        node.attributeValue(for: "placement", strategy: ToolbarItemPlacementParseStrategy()) ?? .automatic
    }
    
    init(node: Node) {
        self.node = node
    }
    
    var body: some ToolbarContent {
        SwiftUI.ToolbarItemGroup(placement: placement) {
            node.children(in: "content", default: true, library: Library.self)
        } label: {
            node.children(in: "label", library: Library.self)
        }
    }
}

struct ToolbarItemPlacementParseStrategy: ParseStrategy {
    func parse(_ value: String) throws -> ToolbarItemPlacement {
        // Strip leading dot if present (e.g., ".bottomBar" -> "bottomBar")
        let name = value.hasPrefix(".") ? String(value.dropFirst()) : value
        switch name {
        case "automatic":
            return .automatic
        case "principal":
            return .principal
        case "navigation":
            return .navigation
        case "primaryAction":
            return .primaryAction
        case "secondaryAction":
            return .secondaryAction
        case "status":
            return .status
        case "confirmationAction":
            return .confirmationAction
        case "cancellationAction":
            return .cancellationAction
        case "destructiveAction":
            return .destructiveAction
        #if os(iOS) || os(visionOS)
        case "keyboard":
            return .keyboard
        case "topBarLeading", "navigationBarLeading":
            return .topBarLeading
        case "topBarTrailing", "navigationBarTrailing":
            return .topBarTrailing
        case "bottomBar":
            return .bottomBar
        #endif
        #if os(iOS)
        case "title":
            if #available(iOS 17.0, *) {
                return .title
            } else {
                throw ParseError()
            }
        case "largeTitle":
            if #available(iOS 17.0, *) {
                return .largeTitle
            } else {
                throw ParseError()
            }
        case "subtitle":
            if #available(iOS 17.0, *) {
                return .subtitle
            } else {
                throw ParseError()
            }
        case "largeSubtitle":
            if #available(iOS 17.0, *) {
                return .largeSubtitle
            } else {
                throw ParseError()
            }
        #endif
        default:
            throw ParseError()
        }
    }
}
