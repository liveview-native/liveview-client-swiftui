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
/// <Text modifiers={minimum_scale_factor(0.8)}
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

    func body(content: Content) -> some View {
        content.minimumScaleFactor(factor)
    }
}
