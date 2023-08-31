//
//  SaturationModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/24/23.
//

import SwiftUI

/// Adjusts the color saturation of this view.
///
/// Use color saturation to increase or decrease the intensity of colors in a view.
///
/// ```html
/// <Label modifiers={foreground_color(:red) |> saturation(0.5)}>Color Text</Label>
/// ```
///
/// ## Arguments
/// * ``amount``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct SaturationModifier: ViewModifier, Decodable {
    /// The amount of saturation to apply to this view.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let amount: Double

    func body(content: Content) -> some View {
        content.saturation(amount)
    }
}
