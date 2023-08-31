//
//  OffsetModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 4/1/23.
//

import SwiftUI

/// Applies an offset to any element.
///
/// ```html
/// <Text
///     modifiers={
///         offset(x: 24, y: 48)
///     }
/// >
///   This text is offset by 24 on the x axis and 48 on the y axis.
/// </Text>
/// ```
///
/// ## Arguments
/// * ``x``
/// * ``y``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct OffsetModifier: ViewModifier, Decodable, Equatable {
    /// The offset to apply to the x axis.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let x: CGFloat?
    /// The offset to apply to the y axis.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let y: CGFloat?

    func body(content: Content) -> some View {
        content.offset(x: x ?? 0, y: y ?? 0)
    }
}
