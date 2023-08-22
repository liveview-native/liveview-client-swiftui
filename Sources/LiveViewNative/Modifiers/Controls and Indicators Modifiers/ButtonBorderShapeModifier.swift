//
//  ButtonBorderShapeModifier.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 4/26/23.
//

import SwiftUI

/// Alters the shape of any bordered buttons' borders.
///
/// ```html
/// <Button modifiers={button_style(:bordered) |> button_border_shape(:capsule)}>
///     Capsule
/// </Button>
/// <Button modifiers={button_style(:bordered) |> button_border_shape(shape: :rounded_rectangle, radius: 15)}>
///     Rounded rectangle
/// </Button>
/// ```
///
/// ## Arguments
/// - ``shape``
/// - `radius`
///     - Only used for rounded rectangles, and only available on iOS and watchOS.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ButtonBorderShapeModifier: ViewModifier, Decodable {
    /// The shape to use.
    ///
    /// Possible values:
    /// - `automatic`
    /// - `capsule` (iOS and watchOS only)
    /// - `rounded_rectangle`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    let shape: ButtonBorderShape
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(String.self, forKey: .shape) {
        case "automatic":
            self.shape = .automatic
        #if os(iOS) || os(watchOS)
        case "capsule":
            self.shape = .capsule
        #endif
        case "rounded_rectangle":
            #if os(iOS) || os(watchOS)
            if let radius = try container.decodeIfPresent(CGFloat.self, forKey: .radius) {
                self.shape = .roundedRectangle(radius: radius)
            } else {
                self.shape = .roundedRectangle
            }
            #else
            self.shape = .roundedRectangle
            #endif
        default:
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Invalid value for button border shape"))
        }
    }
    
    func body(content: Content) -> some View {
        content.buttonBorderShape(shape)
    }
    
    enum CodingKeys: CodingKey {
        case shape
        case radius
    }
}
