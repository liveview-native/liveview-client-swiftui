//
//  KerningModifier.swift
//
//
//  Created by Carson Katri on 2/21/24.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.View/kerning(_:)`](https://developer.apple.com/documentation/swiftui/view/kerning(_:)) for more details on this ViewModifier.
///
/// ### kerning(_:)
/// - `kerning`: `attr("...")` or ``CoreFoundation/CGFloat`` (required)
///
/// See [`SwiftUI.View/kerning(_:)`](https://developer.apple.com/documentation/swiftui/view/kerning(_:)) for more details on this ViewModifier.
///
/// Example:
///
/// ```elixir
/// # stylesheet
/// "example" do
///   kerning(attr("kerning"))
/// end
/// ```
///
/// ```heex
/// <%!-- template --%>
/// <Element class="example" kerning={@kerning} />
/// ```
@_documentation(visibility: public)
@ParseableExpression
struct _KerningModifier<R: RootRegistry>: TextModifier {
    static var name: String { "kerning" }

    let kerning: AttributeReference<CoreFoundation.CGFloat>

    @ObservedElement private var element
    @LiveContext<R> private var context
    
    init(_ kerning: AttributeReference<CoreFoundation.CGFloat>) {
        self.kerning = kerning
    }
    
    func body(content: Content) -> some View {
        content
            .kerning(kerning.resolve(on: element, in: context))
    }
    
    func apply(to text: SwiftUI.Text, on element: ElementNode) -> SwiftUI.Text {
        text.kerning(kerning.resolve(on: element))
    }
}
