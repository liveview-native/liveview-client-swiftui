//
//  BlurModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/13/2023.
//

import SwiftUI

/// Applies a Gaussian blur to the element.
///
/// Set the ``radius`` to control the strength of the blur.
///
/// ```html
/// <Text modifiers={blur(radius: 2)}>Hello, world!</Text>
/// ```
///
/// ## Arguments
/// * ``radius``
/// * ``opaque``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct BlurModifier: ViewModifier, Decodable {
    /// The strength of the blur.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let radius: CGFloat

    /// When `true`, disables transparency in the blur. Defaults to `false`.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let opaque: Bool

    func body(content: Content) -> some View {
        content.blur(radius: radius, opaque: opaque)
    }
}

