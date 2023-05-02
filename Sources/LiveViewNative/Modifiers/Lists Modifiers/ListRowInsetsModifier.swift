//
//  ListRowInsetsModifier.swift
// LiveViewNative
//
//  Created by Shadowfacts on 9/14/22.
//

import SwiftUI

/// Sets the inset for an element in a ``List``.
///
/// Apply this modifier to an element inside of a ``List`` to change the inset from the system default.
///
/// ```html
/// <List>
///     <Text id="item" modifiers={list_row_insets(@native, insets: [top: 0, leading: 25, bottom: 0, trailing: 0])}>
///         Item
///     </Text>
/// </List>
/// ```
///
/// ## Arguments
/// * ``insets``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ListRowInsetsModifier: ViewModifier, Decodable, Equatable {
    /// The amount to inset by.
    ///
    /// See ``LiveViewNative/SwiftUI/EdgeInsets`` for more details on creating insets.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let insets: EdgeInsets?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.insets = try container.decodeIfPresent(EdgeInsets.self, forKey: .insets)
    }
    
    init(insets: EdgeInsets) {
        self.insets = insets
    }
    
    func body(content: Content) -> some View {
        content.listRowInsets(insets)
    }
    
    enum CodingKeys: CodingKey {
        case insets
    }
}
