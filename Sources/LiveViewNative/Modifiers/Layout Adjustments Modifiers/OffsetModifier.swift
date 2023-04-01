//
//  OffsetModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 4/1/23.
//

import SwiftUI

/// Applies an offset to any element.
///
/// ```html
/// <Text
///     modifiers={
///         offset(@native, x: 24, y: 48)
///     }
/// >
///   This text is offset by 24 on the x axis and 48 on the y axis.
/// </Text>
/// ```
///
/// ## Arguments
/// * ``x``: The offset to apply to the x axis.
/// * ``y``: The offset to apply to the y axis.

#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct OffsetModifier: ViewModifier, Decodable, Equatable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let x: CGFloat
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let y: CGFloat

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.x = try container.decode(CGFloat.self, forKey: .x)
        self.y = try container.decode(CGFloat.self, forKey: .y)
    }

    func body(content: Content) -> some View {
        content.offset(x: x, y: y)
    }

    enum CodingKeys: String, CodingKey {
        case x
        case y
    }
}