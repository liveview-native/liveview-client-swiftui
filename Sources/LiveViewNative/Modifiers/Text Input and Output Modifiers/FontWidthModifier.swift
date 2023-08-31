//
//  FontWidthModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/6/2023.
//

import SwiftUI

/// Changes the font width for child elements.
///
/// Pass a ``LiveViewNative/SwiftUI/Font/Width`` to the ``width`` argument to change the value.
///
/// ```html
/// <Text modifiers={font_width(:expanded)}>
///     Hello, world!
/// </Text>
/// ```
///
/// See ``LiveViewNative/SwiftUI/Font/Width`` for more details on creating font weights.
///
/// ## Arguments
/// * ``width``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct FontWidthModifier: ViewModifier, Decodable, TextModifier {
    /// The font width to use for child elements.
    ///
    /// See ``LiveViewNative/SwiftUI/Font/Width`` for more details on creating font widths.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let width: Font.Width

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let widthContainer = try container.nestedContainer(keyedBy: CodingKeys.Width.self, forKey: .width)
        self.width = try widthContainer.decodeIfPresent(Font.Width.self, forKey: .name)
            ?? widthContainer.decode(Font.Width.self, forKey: .value)
    }

    func body(content: Content) -> some View {
        content.fontWidth(width)
    }
    
    func apply(to text: SwiftUI.Text) -> SwiftUI.Text {
        text.fontWidth(width)
    }

    enum CodingKeys: String, CodingKey {
        case width
        
        enum Width: String, CodingKey {
            case name
            case value
        }
    }
}
