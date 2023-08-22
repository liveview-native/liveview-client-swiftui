
//
//  MonospacedDigitModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 4/1/23.
//

import SwiftUI

/// Changes any element to use fixed-width digits.
///
/// ```html
/// <Text
///     modifiers={
///         monospaced_digit([])
///     }
/// >
///   The following numbers are monospaced: 1234567890
/// </Text>
/// ```
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct MonospacedDigitModifier: ViewModifier, Decodable, Equatable, TextModifier {
    init(from decoder: Decoder) throws {
    }

    func body(content: Content) -> some View {
        return content.monospacedDigit()
    }
    
    func apply(to text: SwiftUI.Text) -> SwiftUI.Text {
        text.monospacedDigit()
    }
}
