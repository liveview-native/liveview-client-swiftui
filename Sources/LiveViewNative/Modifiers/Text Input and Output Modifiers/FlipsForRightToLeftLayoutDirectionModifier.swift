//
//  FlipsForRightToLeftLayoutDirectionModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/18/23.
//

import SwiftUI

/// Sets whether this view mirrors its contents horizontally when the layout direction is right-to-left.
///
/// ```html
/// <Text modifiers={flips_for_right_to_left_layout_direction(true)}>
///     Hello, world!
/// </Text>
/// ```
///
/// ## Arguments
/// * ``enabled``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct FlipsForRightToLeftLayoutDirectionModifier: ViewModifier, Decodable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let enabled: Bool

    func body(content: Content) -> some View {
        content.flipsForRightToLeftLayoutDirection(enabled)
    }
}
