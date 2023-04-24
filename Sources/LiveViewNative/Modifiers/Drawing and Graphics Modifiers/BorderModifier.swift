//
//  BorderModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 4/24/23.
//

import SwiftUI

/// Applies a border to any element.
///
/// ```html
/// <Text modifiers={border(@native, content: {:color, :purple}, width: 4)}>
///   Purple border inside the view bounds.
/// </Text>
/// ```
///
/// ## Arguments
/// * ``content``
/// * ``width``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct BorderModifier: ViewModifier, Decodable {
    /// The content of the border as a `ShapeStyle`.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private var content: AnyShapeStyle

    /// The thickness of the border.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private var width: CGFloat

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.content = try container.decode(AnyShapeStyle.self, forKey: .content)
        self.width = try container.decode(CGFloat.self, forKey: .width)
    }

    func body(content: Content) -> some View {
        content.border(self.content, width: width)
    }

    enum CodingKeys: String, CodingKey {
        case content
        case width
    }
}
