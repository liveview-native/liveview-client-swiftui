
//
//  MonospacedModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 4/1/23.
//

import SwiftUI

/// Changes the font within any element to be monospaced.
///
/// ```html
/// <Text
///     modifiers={
///         monospaced(true)
///     }
/// >
///   This text is monospaced.
/// </Text>
/// ```
///
/// ## Arguments
/// * ``isActive``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct MonospacedModifier: ViewModifier, Decodable, Equatable, TextModifier {
    /// A boolean that indicates whether the monospaced font should be used.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let isActive: Bool

    func body(content: Content) -> some View {
        return content.monospaced(isActive)
    }
    
    func apply(to text: SwiftUI.Text) -> SwiftUI.Text {
        if #available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *) {
            return text.monospaced(isActive)
        } else {
            return text
        }
    }
}
