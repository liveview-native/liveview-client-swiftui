//
//  InterpolationModifier.swift
//  
//
//  Created by Carson.Katri on 6/1/23.
//

import SwiftUI

/// Set the quality level for an ``Image`` that requires interpolation.
///
/// When an image is resized (such as with the ``ResizableModifier`` modifier), it is interpolated.
/// Use this modifier to set the quality of interpolation.
///
/// ```html
/// <Image
///   name="dot_green"
///   modifiers={resizable([]) |> interpolation(:none)}
/// />
/// <Image
///   name="dot_green"
///   modifiers={resizable([]) |> interpolation(:medium)}
/// />
/// ```
///
/// ## Arguments
/// * ``interpolation``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct InterpolationModifier: ImageModifier, Decodable {
    /// The interpolation quality.
    ///
    /// See ``LiveViewNative/SwiftUI/Image/Interpolation`` for a list of possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let interpolation: SwiftUI.Image.Interpolation
    
    func apply(to image: SwiftUI.Image) -> SwiftUI.Image {
        image.interpolation(interpolation)
    }
}

/// The quality level used to render an interpolated ``Image``.
///
/// Possible values:
/// * `low`
/// * `medium`
/// * `high`
/// * `none`
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension SwiftUI.Image.Interpolation: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "low":
            self = .low
        case "medium":
            self = .medium
        case "high":
            self = .high
        case "none":
            self = .none
        case let `default`: throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "Unknown interpolation '\(`default`)'"))
        }
    }
}
