//
//  ToolbarTitleMenu.swift
//  
//
//  Created by Carson.Katri on 3/30/23.
//

import SwiftUI
import LightpandaClient

/// Toolbar element that opens a menu when the navigation title is tapped.
///
/// On iOS, the menu can be opened by tapping the inline navigation bar title.
///
/// ```html
/// <ToolbarTitleMenu>
///     <Button phx-click="edit">Edit</Button>
///     <Button phx-click="save">Save</Button>
///     <Button phx-click="open">Open</Button>
/// </ToolbarTitleMenu>
/// ```
///
/// ## See Also
/// ### Toolbars Modifiers
/// * ``ToolbarModifier``
@_documentation(visibility: public)
struct ToolbarTitleMenu<Library: ElementLibrary>: CustomizableToolbarContent {
    let node: Node
    
    var body: some CustomizableToolbarContent {
        SwiftUI.ToolbarTitleMenu {
            node.children(library: Library.self)
        }
    }
}
