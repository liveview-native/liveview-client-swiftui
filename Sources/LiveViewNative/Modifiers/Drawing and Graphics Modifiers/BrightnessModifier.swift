//
//  BrightnessModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/20/23.
//

import SwiftUI

/// Brighten the intensity of the colors in a view.
///
/// ```html
/// <Color name="system-red" modifiers={brightness(0.5)} />
/// ```
///
/// ## Arguments
/// * ``amount``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct BrightnessModifier: ViewModifier, Decodable {
    /// A value between 0 (no effect) and 1 (full white brightening) that represents the intensity of the brightness effect.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let amount: Double

    func body(content: Content) -> some View {
        content.brightness(amount)
    }
}
