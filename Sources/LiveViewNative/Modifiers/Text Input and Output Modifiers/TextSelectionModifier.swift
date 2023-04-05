//
//  TextSelectionModifier.swift
//  
//
//  Created by Carson Katri on 4/5/23.
//

import SwiftUI

/// Enables/disables selection of ``Text``.
///
/// Use this modifier to enable selection of non-editable ``Text`` elements.
///
/// ```html
/// <Text modifiers={text_selection(@native, selectable: true)}>
///     Hello, world!
/// </Text>
/// ```
///
/// Arguments:
/// * ``selectable``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct TextSelectionModifier: ViewModifier, Decodable {
    /// Sets the selectability of the element.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let selectable: Bool

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.selectable = try container.decode(Bool.self, forKey: .selectable)
    }

    func body(content: Content) -> some View {
        if selectable {
            content.textSelection(.enabled)
        } else {
            content.textSelection(.disabled)
        }
    }

    enum CodingKeys: String, CodingKey {
        case selectable
    }
}
