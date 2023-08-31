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
///     <Color name="system-yellow" modifiers={frame(width: 50, height: 50, alignment: :center)} />
///     <Color name="system-red"
///         modifiers={
///             frame(width: 50, height: 50, alignment: :center)
///             |> rotation_effect({:degrees, 45})
///             |> padding(-20)
///             |> blend_mode(:color_burn)
///         }
///     />
/// </HStack>
/// ```
///
/// ## Arguments
/// * ``blendMode``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct BlendModeModifier: ViewModifier, Decodable {
    /// Modes for compositing a view with overlapping content.
    ///
    /// See ``LiveViewNative/SwiftUI/BlendMode`` for a list of possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let blendMode: BlendMode
    
    func body(content: Content) -> some View {
        content.blendMode(blendMode)
    }
}
