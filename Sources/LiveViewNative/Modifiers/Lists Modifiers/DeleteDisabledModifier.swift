//
//  DeleteDisabledModifier.swift
//  LiveViewNatve
//
//  Created by Dylan.Ginsburg on 4/26/23.
//

import SwiftUI

/// Adds a condition for whether the view’s view hierarchy is deletable.
///
/// ```html
/// <List>
///     <Label modifiers={delete_disabled(true)}>
///         This label cannot be deleted when list is editable
///     </Label>
/// </List>
/// ```
///
/// ## Arguments
/// * ``isDisabled``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct DeleteDisabledModifier: ViewModifier, Decodable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let isDisabled: Bool
    
    func body(content: Content) -> some View {
        content.deleteDisabled(isDisabled)
    }
}
