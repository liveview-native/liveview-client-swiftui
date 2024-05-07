//
//  FontModifier.swift
//
//
//  Created by Carson Katri on 2/21/24.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.View/font(_:)`](https://developer.apple.com/documentation/swiftui/view/font(_:)) for more details on this ViewModifier.
///
/// ### font(_:)
/// - `font`: ``SwiftUI/Font`` or `nil`
///
/// See [`SwiftUI.View/font(_:)`](https://developer.apple.com/documentation/swiftui/view/font(_:)) for more details on this ViewModifier.
///
/// Example:
///
/// ```elixir
/// # stylesheet
/// "example" do
///   font(.body)
/// end
/// ```
@_documentation(visibility: public)
@ParseableExpression
struct _FontModifier<R: RootRegistry>: TextModifier {
    static var name: String { "font" }

    let font: SwiftUI.Font?
    
    init(_ font: SwiftUI.Font?) {
        self.font = font
    }

    func body(content: Content) -> some View {
        content.font(font)
    }
    
    func apply(to text: SwiftUI.Text, on element: ElementNode) -> SwiftUI.Text {
        text.font(font)
    }
}
