//
//  DrawingGroupModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/26/23.
//

import SwiftUI

/// Composites this view’s contents into an offscreen image before final display.
///
/// ```html
/// <HStack>
///     <ZStack
///         modifier={
///             @native
///                 |> drawing_group(opaque: false, color_mode: :non_linear)
///                 |> opacity(opacity: 0.5)
///         }
///     >
///         <Text>Hello, world!</Text>
///         <Text modifiers={blur(@native, radius: 2)}>Hello, world!</Text>
///     </ZStack>
/// </HStack>
/// ```
///
/// ## Arguments
/// * ``opaque``
/// * ``color_mode``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct DrawingGroupModifier: ViewModifier, Decodable {
    /// A Boolean value that indicates whether the image is opaque. The default is false; if set to true, the alpha channel of the image must be 1.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let opaque: Bool
    
    /// One of the working color space and storage formats. The default is ``non_linear``
    ///
    /// Possible values:
    /// * `extended_linear`
    /// * `linear`
    /// * `non_linear`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let colorMode: ColorRenderingMode

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.opaque = try container.decode(Bool.self, forKey: .opaque)
        switch try container.decode(String.self, forKey: .colorMode) {
        case "extended_linear": self.colorMode = .extendedLinear
        case "linear": self.colorMode = .linear
        case "non_linear": self.colorMode = .nonLinear
        default:
            throw DecodingError.dataCorruptedError(forKey: .colorMode, in: container, debugDescription: "invalid value for \(CodingKeys.colorMode.rawValue)")
        }
    }
    
    func body(content: Content) -> some View {
        content.drawingGroup(opaque: opaque, colorMode: colorMode)
    }
    
    enum CodingKeys: String, CodingKey {
        case opaque
        case colorMode = "color_mode"
    }
}
