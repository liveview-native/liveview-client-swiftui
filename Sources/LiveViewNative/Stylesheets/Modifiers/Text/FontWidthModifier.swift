//
//  FontWidthModifier.swift
//
//
//  Created by Carson Katri on 2/21/24.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.View/fontWidth(_:)`](https://developer.apple.com/documentation/swiftui/view/fontWidth(_:)) for more details on this ViewModifier.
///
/// ### fontWidth(_:)
/// - `width`: ``SwiftUI/Font/Width`` or `nil`
///
/// See [`SwiftUI.View/fontWidth(_:)`](https://developer.apple.com/documentation/swiftui/view/fontWidth(_:)) for more details on this ViewModifier.
///
/// Example:
///
/// ```elixir
/// # stylesheet
/// "example" do
///   fontWidth(.compressed)
/// end
/// ```
@_documentation(visibility: public)
@ParseableExpression
struct _FontWidthModifier<R: RootRegistry>: TextModifier {
    static var name: String { "fontWidth" }

    let width: SwiftUI.Font.Width?
    
    init(_ width: SwiftUI.Font.Width?) {
        self.width = width
    }

    func body(content: Content) -> some View {
        content.fontWidth(width)
    }
    
    func apply(to text: SwiftUI.Text, on element: ElementNode) -> SwiftUI.Text {
        text.fontWidth(width)
    }
}
