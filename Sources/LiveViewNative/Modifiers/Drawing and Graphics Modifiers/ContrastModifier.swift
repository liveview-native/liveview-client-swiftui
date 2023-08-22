//
//  ContrastModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/20/23.
//

import SwiftUI

/// Sets the contrast and separation between similar colors in this view.
///
/// ```html
/// <Circle modifiers={foreground_style({:color, :red}) |> contrast(0.5)} />
/// ```
///
/// ## Arguments
/// * ``amount``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ContrastModifier: ViewModifier, Decodable {
    /// The intensity of color contrast to apply. Negative values invert colors in addition to applying contrast.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let amount: Double

    func body(content: Content) -> some View {
        content.contrast(amount)
    }
}
