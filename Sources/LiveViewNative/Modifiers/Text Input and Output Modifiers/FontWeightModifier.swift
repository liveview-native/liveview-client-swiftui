//
//  FontWeightModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 2/17/23.
//

import SwiftUI

/// Changes the font weight for child elements.
///
/// Pass a ``LiveViewNative/SwiftUI/Font/Weight`` to the ``weight`` argument to change the value.
///
/// ```html
/// <Text modifiers={font_weight(@native, weight: :bold)}>
///     Hello, world!
/// </Text>
/// ```
///
/// See ``LiveViewNative/SwiftUI/Font/Weight`` for more details on creating font weights.
///
/// ## Arguments
/// * ``weight``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct FontWeightModifier: ViewModifier, Decodable, Equatable {
    /// The font weight to use for child elements.
    ///
    /// See ``LiveViewNative/SwiftUI/Font/Weight`` for more details on creating font weights.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let weight: Font.Weight?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.weight = try container.decode(Font.Weight.self, forKey: .weight)
    }
    
    init(weight: Font.Weight) {
        self.weight = weight
    }

    func body(content: Content) -> some View {
        content.fontWeight(weight)
    }
    
    enum CodingKeys: String, CodingKey {
        case weight
    }
}
