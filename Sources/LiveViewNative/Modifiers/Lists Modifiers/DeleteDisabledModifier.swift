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
///     <Label modifiers={delete_disabled(@native, is_disabled: true)}>
///         This label cannot be deleted when list is editable
///     </Label>
/// </List>
/// ```
///
/// ## Arguments
/// * ``is_disabled``
struct DeleteDisabledModifier: ViewModifier, Decodable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let isDisabled: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isDisabled = try container.decode(Bool.self, forKey: .isDisabled)
    }
    
    func body(content: Content) -> some View {
        content.deleteDisabled(isDisabled)
    }
    
    enum CodingKeys: String, CodingKey {
        case isDisabled = "is_disabled"
    }
}
