//
//  ToolbarItemGroup.swift
//  
//
//  Created by Carson Katri on 3/30/23.
//

import SwiftUI

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
@LiveElement
struct ToolbarItemGroup<Root: RootRegistry>: ToolbarContent {
    /// The position of this group in the toolbar.
    @_documentation(visibility: public)
    private var placement: _ToolbarItemPlacement = .automatic
    
    init(element: ElementNode) {
        self._liveElement = .init(element: element)
    }
    
    var body: some ToolbarContent {
        SwiftUI.ToolbarItemGroup(placement: placement.placement) {
            $liveElement.children(in: "content", default: true)
        } label: {
            $liveElement.children(in: "label")
        }
    }
}
