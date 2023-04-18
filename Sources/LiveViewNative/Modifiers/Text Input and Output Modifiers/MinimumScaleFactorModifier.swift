//
//  MinimumScaleFactorModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/18/23.
//

import SwiftUI

/// Sets the minimum amount that text in this view scales down to fit in the available space.
///
/// ```html
/// <Text modifiers={minimum_scale_factor(@native, factor: 0.8)}
/// ```
///
/// ## Arguments
/// * ``factor``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct MinimumScaleFactorModifier: ViewModifier, Decodable {
    /// The vertical offset to apply.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let factor: CGFloat

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.factor = try container.decode(CGFloat.self, forKey: .factor)
    }

    func body(content: Content) -> some View {
        content.minimumScaleFactor(factor)
    }

    enum CodingKeys: String, CodingKey {
        case factor
    }
}
