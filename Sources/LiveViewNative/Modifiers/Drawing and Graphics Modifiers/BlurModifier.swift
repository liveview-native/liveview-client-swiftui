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
/// <Text modifiers={blur(@native, radius: 2)}>Hello, world!</Text>
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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.radius = try container.decode(CGFloat.self, forKey: .radius)
        self.opaque = try container.decode(Bool.self, forKey: .opaque)
    }

    func body(content: Content) -> some View {
        content.blur(radius: radius, opaque: opaque)
    }

    enum CodingKeys: String, CodingKey {
        case radius
        case opaque
    }
}

