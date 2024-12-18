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
@ASTDecodable("font")
struct _FontModifier<Root: RootRegistry>: TextModifier {
    let font: SwiftUI.Font?
    
    init(_ font: SwiftUI.Font?) {
        self.font = font
    }

    func body(content: Content) -> some View {
        content.font(font)
    }
    
    func apply<R: RootRegistry>(to text: SwiftUI.Text, on element: ElementNode, in context: LiveContext<R>) -> SwiftUI.Text {
        text.font(font)
    }
}
