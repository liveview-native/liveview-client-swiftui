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
@ASTDecodable("monospacedDigit")
struct _MonospacedDigitModifier<Root: RootRegistry>: TextModifier {
    init() {}

    func body(content: Content) -> some View {
        content.monospacedDigit()
    }
    
    func apply<R: RootRegistry>(to text: SwiftUI.Text, on element: ElementNode, in context: LiveContext<R>) -> SwiftUI.Text {
        text.monospacedDigit()
    }
}
