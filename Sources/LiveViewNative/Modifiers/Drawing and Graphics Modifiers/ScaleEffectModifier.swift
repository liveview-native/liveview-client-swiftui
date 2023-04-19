//
//  ScaleEffectModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/19/23.
//

import SwiftUI

/// Scales this view’s rendered output by the given vertical and horizontal size amounts, relative to an anchor point.
///
/// ```html
/// <Text modifiers={scale_effect(@native, width: 2.0, height: 2.0, anchor: :bottom)}>
///     Scale by a width and height factor
/// </Text>
/// ```
///
/// ## Arguments
/// * ``width``
/// * ``height``
/// * ``anchor``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ScaleEffectEffectModifier: ViewModifier, Decodable {
    /// The amount to scale the width
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let width: CGFloat

    /// The amount to scale the height
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let height: CGFloat

    /// The ``LiveViewNative/SwiftUI/UnitPoint`` from which to apply the transformatio. Defaults to `{0.5, 0.5}`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let anchor: UnitPoint

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.width = try container.decode(CGFloat.self, forKey: .width)
        self.height = try container.decode(CGFloat.self, forKey: .height)
        self.anchor = try container.decodeIfPresent(UnitPoint.self, forKey: .anchor) ?? .center
    }

    func body(content: Content) -> some View {
        content.scaleEffect(CGSize(width: width, height: height), anchor: anchor)
    }

    enum CodingKeys: String, CodingKey {
        case width
        case height
        case anchor
    }
}
