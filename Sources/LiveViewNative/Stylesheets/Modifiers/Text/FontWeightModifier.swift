//
//  FontWeightModifier.swift
//
//
//  Created by Carson Katri on 2/21/24.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.View/fontWeight(_:)`](https://developer.apple.com/documentation/swiftui/view/fontWeight(_:)) for more details on this ViewModifier.
///
/// ### fontWeight(_:)
/// - `weight`: ``SwiftUI/Font/Weight`` or `nil`
///
/// See [`SwiftUI.View/fontWeight(_:)`](https://developer.apple.com/documentation/swiftui/view/fontWeight(_:)) for more details on this ViewModifier.
///
/// Example:
///
/// ```elixir
/// # stylesheet
/// "example" do
///   fontWeight(.ultraLight)
/// end
/// ```
@_documentation(visibility: public)
@ParseableExpression
struct _FontWeightModifier<R: RootRegistry>: TextModifier {
    static var name: String { "fontWeight" }

    let weight: SwiftUI.Font.Weight?

    init(_ weight: SwiftUI.Font.Weight?) {
        self.weight = weight
    }

    func body(content: Content) -> some View {
        content.fontWeight(weight)
    }
    
    func apply(to text: SwiftUI.Text, on element: ElementNode) -> SwiftUI.Text {
        text.fontWeight(weight)
    }
}
