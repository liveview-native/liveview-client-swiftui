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
        switch value {
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
        case "keyboard":
            return .keyboard
        case "topBarLeading":
            return .topBarLeading
        case "topBarTrailing":
            return .topBarTrailing
        case "title":
            return .title
        case "largeTitle":
            return .largeTitle
        case "bottomBar":
            return .bottomBar
        case "subtitle":
            return .subtitle
        case "largeSubtitle":
            return .largeSubtitle
        default:
            throw ParseError()
        }
    }
}
