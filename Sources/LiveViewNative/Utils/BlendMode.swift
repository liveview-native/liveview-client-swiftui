//
//  BlendMode.swift
//  
//
//  Created by Carson Katri on 4/25/23.
//

import SwiftUI

/// Mode for blending colors.
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
extension BlendMode: Decodable {
    public init(from decoder: Decoder) throws {
        switch try decoder.singleValueContainer().decode(String.self) {
        case "normal": self = .normal
        case "darken": self = .darken
        case "multiply": self = .multiply
        case "color_burn": self = .colorBurn
        case "plus_darker": self = .plusDarker
        case "lighten": self = .lighten
        case "screen": self = .screen
        case "color_dodge": self = .colorDodge
        case "plus_lighter": self = .plusLighter
        case "overlay": self = .overlay
        case "soft_light": self = .softLight
        case "hard_light": self = .hardLight
        case "difference": self = .difference
        case "exclusion": self = .exclusion
        case "hue": self = .hue
        case "saturation": self = .saturation
        case "color": self = .color
        case "luminosity": self = .luminosity
        case "source_atop": self = .sourceAtop
        case "destination_over": self = .destinationOver
        case "destination_out": self = .destinationOut
        case let `default`:
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "unknown blend mode '\(`default`)'"))
        }
    }
}
