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
///   <ZStack
///     modifier={
///       drawing_group(opaque: false, color_mode: :non_linear)
///       |> opacity(opacity: 0.5)
///     }
///   >
///     <Text>Hello, world!</Text>
///     <Text modifiers={blur(radius: 2)}>Hello, world!</Text>
///   </ZStack>
/// </HStack>
/// ```
///
/// ## Arguments
/// * ``opaque``
/// * ``colorMode``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct DrawingGroupModifier: ViewModifier, Decodable {
    /// A Boolean value that indicates whether the image is opaque. The default is false; if set to true, the alpha channel of the image must be 1.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let opaque: Bool
    
    /// One of the working color space and storage formats. The default is `non_linear`
    ///
    /// See ``LiveViewNative/SwiftUI/ColorRenderingMode`` for a list of possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let colorMode: ColorRenderingMode

    func body(content: Content) -> some View {
        content.drawingGroup(opaque: opaque, colorMode: colorMode)
    }
}
