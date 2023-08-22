//
//  LuminanceToAlphaModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/24/23.
//

import SwiftUI

/// Adds a luminance to alpha effect to this view.
///
/// Use this modifier to create a semitransparent mask, with the opacity of each part of the modified view controlled by the luminance of the corresponding part of the original view. Regions of lower luminance become more transparent, while higher luminance yields greater opacity.
///
/// ```html
/// <Image
///     system-name="heart.fill"
///     modifiers={
///         background(alignment: :center, content: :heart_bg)
///             |> foreground_color(:red)
///             |> luminance_to_alpha()
///     }
/// >
///     <background:heart_bg>
///         <Circle modifiers={frame(width: 32, height: 32) |> foreground_color(:red)} />
///     </background:heart_bg>
/// </Image>
/// ```
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct LuminanceToAlphaModifier: ViewModifier, Decodable {
    func body(content: Content) -> some View {
        return content.luminanceToAlpha()
    }
}
