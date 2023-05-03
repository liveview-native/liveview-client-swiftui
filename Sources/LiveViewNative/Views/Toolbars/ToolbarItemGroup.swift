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
/// <ToolbarItemGroup placement="destructive-action">
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
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ToolbarItemGroup<R: RootRegistry>: ToolbarContent {
    @ObservedElement private var element
    @LiveContext<R> private var context
    
    /// The position of this group in the toolbar.
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
        SwiftUI.ToolbarItemGroup(placement: placement) {
            context.buildChildren(of: element, forTemplate: "content", includeDefaultSlot: true)
        } label: {
            context.buildChildren(of: element, forTemplate: "label")
        }
    }
}
