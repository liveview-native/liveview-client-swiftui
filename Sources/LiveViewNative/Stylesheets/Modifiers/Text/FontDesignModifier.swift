//
//  FontDesignModifier.swift
//
//
//  Created by Carson Katri on 2/21/24.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.View/fontDesign(_:)`](https://developer.apple.com/documentation/swiftui/view/fontDesign(_:)) for more details on this ViewModifier.
///
/// ### fontDesign(_:)
/// - `design`: ``SwiftUI/Font/Design`` or `nil`
///
/// See [`SwiftUI.View/fontDesign(_:)`](https://developer.apple.com/documentation/swiftui/view/fontDesign(_:)) for more details on this ViewModifier.
///
/// Example:
///
/// ```elixir
/// # stylesheet
/// "example" do
///   fontDesign(.default)
/// end
/// ```
@_documentation(visibility: public)
@ASTDecodable("fontDesign")
struct _FontDesignModifier<Root: RootRegistry>: TextModifier {
    let design: Any?

    @available(watchOS 9.1,tvOS 16.1,iOS 16.1,macOS 13.0, visionOS 1, *)
    init(_ design: SwiftUI.Font.Design?) {
        self.design = design
    }

    func body(content: Content) -> some View {
        if #available(watchOS 9.1,tvOS 16.1,iOS 16.1,macOS 13.0, visionOS 1, *) {
            content.fontDesign(design as? SwiftUI.Font.Design)
        } else {
            content
        }
    }
    
    func apply<R: RootRegistry>(to text: SwiftUI.Text, on element: ElementNode, in context: LiveContext<R>) -> SwiftUI.Text {
        if #available(watchOS 9.1, tvOS 16.1, iOS 16.1, macOS 13.0, visionOS 1, *) {
            return text.fontDesign(design as? SwiftUI.Font.Design)
        } else {
            return text
        }
    }
}
