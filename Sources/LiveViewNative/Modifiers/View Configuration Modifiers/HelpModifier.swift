//
//  HelpModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 5/23/2023.
//

import SwiftUI

/// Adds help text to an element.
///
/// Help text is used as the element's accessibility hint, and displayed as a tooltip on macOS.
///
/// ```html
/// <Button modifiers={hint("Performs a cool action when clicked")}>
///   Click Me
/// </Button>
/// ```
///
/// ## Arguments
/// * ``text``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct HelpModifier: ViewModifier, Decodable {
    /// The element's help text string.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let text: String

    func body(content: Content) -> some View {
        content.help(text)
    }
}
