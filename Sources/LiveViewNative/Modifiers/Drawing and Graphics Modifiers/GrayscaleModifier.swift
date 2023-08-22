//
//  GrayscaleModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/24/23.
//

import SwiftUI

/// Adds a grayscale effect to this view.
///
/// A grayscale effect reduces the intensity of colors in this view.
///
/// ```html
/// <Label modifiers={foreground_color(:red) |> grayscale(0.5)}>Color Text</Label>
/// ```
///
/// ## Arguments
/// * ``amount``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct GrayscaleModifier: ViewModifier, Decodable {
    /// The intensity of grayscale to apply from 0.0 to less than 1.0. Values closer to 0.0 are more colorful, and values closer to 1.0 are less colorful.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let amount: Double

    func body(content: Content) -> some View {
        content.grayscale(amount)
    }
}
