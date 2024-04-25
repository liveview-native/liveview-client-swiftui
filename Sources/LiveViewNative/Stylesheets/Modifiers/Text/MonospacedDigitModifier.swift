//
//  MonospacedDigitModifier.swift
//
//
//  Created by Carson Katri on 2/21/24.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.View/monospacedDigit()`](https://developer.apple.com/documentation/swiftui/view/monospacedDigit()) for more details on this ViewModifier.
///
/// ### monospacedDigit()
/// See [`SwiftUI.View/monospacedDigit()`](https://developer.apple.com/documentation/swiftui/view/monospacedDigit()) for more details on this ViewModifier.
///
/// Example:
///
/// ```elixir
/// # stylesheet
/// "example" do
///   monospacedDigit()
/// end
/// ```
@_documentation(visibility: public)
@ParseableExpression
struct _MonospacedDigitModifier<R: RootRegistry>: TextModifier {
    static var name: String { "monospacedDigit" }

    init() {}

    func body(content: Content) -> some View {
        content.monospacedDigit()
    }
    
    func apply(to text: SwiftUI.Text, on element: ElementNode) -> SwiftUI.Text {
        text.monospacedDigit()
    }
}
