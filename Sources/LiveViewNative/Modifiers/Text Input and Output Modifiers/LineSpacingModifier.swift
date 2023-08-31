//
//  LineSpacingModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/18/23.
//

import SwiftUI

/// Sets the amount of space between lines of text in this view.
///
/// ```html
/// <Text modifiers={line_spacing(0.2)}>
///     Hello, world!
/// </Text>
/// ```
///
/// ## Arguments
/// * ``lineSpacing``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct LineSpacingModifier: ViewModifier, Decodable {
    /// The amount of space between the bottom of one line and the top of the next line in points.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let lineSpacing: CGFloat

    func body(content: Content) -> some View {
        content.lineSpacing(lineSpacing)
    }
}
