//
//  BlendModeModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/25/23.
//

import SwiftUI

/// Sets the blend mode for compositing this view with overlapping views.
///
/// ```html
/// <HStack>
///     <Color name="system-yellow" modifiers={@native |> frame(width: 50, height: 50, alignment: :center)} />
///     <Color name="system-red"
///         modifiers={
///             @native
///                 |> frame(width: 50, height: 50, alignment: :center)
///                 |> rotation_effect(angle: {:degrees, 45})
///                 |> padding(all: -20)
///                 |> blend_mode(blend_mode: :color_burn)
///         }
///     />
/// </HStack>
/// ```
///
/// ## Arguments
/// * ``blend_mode``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct BlendModeModifier: ViewModifier, Decodable {
    /// Modes for compositing a view with overlapping content.
    ///
    /// Possible values:
    /// * `normal`
    /// * `darken`
    /// * `multiply`
    /// * `color_burn`
    /// * `plus_darker`
    /// * `lighten`
    /// * `screen`
    /// * `color_dodge`
    /// * `plus_lighter`
    /// * `overlay`
    /// * `soft_light`
    /// * `hard_light`
    /// * `difference`
    /// * `exclusion`
    /// * `hue`
    /// * `saturation`
    /// * `color`
    /// * `luminosity`
    /// * `source_atop`
    /// * `destination_over`
    /// * `destination_out`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let blendMode: BlendMode
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        switch try container.decode(String.self, forKey: .blendMode) {
        case "normal": self.blendMode = .normal
        case "darken": self.blendMode = .darken
        case "multiply": self.blendMode = .multiply
        case "color_burn": self.blendMode = .colorBurn
        case "plus_darker": self.blendMode = .plusDarker
        case "lighten": self.blendMode = .lighten
        case "screen": self.blendMode = .screen
        case "color_dodge": self.blendMode = .colorDodge
        case "plus_lighter": self.blendMode = .plusLighter
        case "overlay": self.blendMode = .overlay
        case "soft_light": self.blendMode = .softLight
        case "hard_light": self.blendMode = .hardLight
        case "difference": self.blendMode = .difference
        case "exclusion": self.blendMode = .exclusion
        case "hue": self.blendMode = .hue
        case "saturation": self.blendMode = .saturation
        case "color": self.blendMode = .color
        case "luminosity": self.blendMode = .luminosity
        case "source_atop": self.blendMode = .sourceAtop
        case "destination_over": self.blendMode = .destinationOver
        case "destination_out": self.blendMode = .destinationOut
        default:
            throw DecodingError.dataCorruptedError(forKey: .blendMode, in: container, debugDescription: "invalid value for \(CodingKeys.blendMode.rawValue)")
        }
    }
    
    func body(content: Content) -> some View {
        content.blendMode(blendMode)
    }
    
    enum CodingKeys: String, CodingKey {
        case blendMode = "blend_mode"
    }
}
