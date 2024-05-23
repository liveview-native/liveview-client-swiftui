//
//  BaselineOffsetModifier.swift
//
//
//  Created by Carson Katri on 2/21/24.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.View/baselineOffset(_:)`](https://developer.apple.com/documentation/swiftui/view/baselineOffset(_:)) for more details on this ViewModifier.
///
/// ### baselineOffset(_:)
/// - `baselineOffset`: `attr("...")` or ``CoreFoundation/CGFloat`` (required)
///
/// See [`SwiftUI.View/baselineOffset(_:)`](https://developer.apple.com/documentation/swiftui/view/baselineOffset(_:)) for more details on this ViewModifier.
///
/// Example:
///
/// ```elixir
/// # stylesheet
/// "example" do
///   baselineOffset(attr("baselineOffset"))
/// end
/// ```
///
/// ```heex
/// <%!-- template --%>
/// <Element class="example" baselineOffset={@baselineOffset} />
/// ```
@_documentation(visibility: public)
@ParseableExpression
struct _BaselineOffsetModifier<R: RootRegistry>: TextModifier {
    static var name: String { "baselineOffset" }

    let baselineOffset: AttributeReference<CoreFoundation.CGFloat>

    @ObservedElement private var element
    @LiveContext<R> private var context
    
    init(_ baselineOffset: AttributeReference<CoreFoundation.CGFloat>) {
        self.baselineOffset = baselineOffset
    }
    
    init(_ baselineOffset: AttributeReference<String>) {
        self.baselineOffset = .init(storage: .constant(0))
    }
    
    func body(content: Content) -> some View {
        content
            .baselineOffset(baselineOffset.resolve(on: element, in: context))
    }
    
    func apply(to text: SwiftUI.Text, on element: ElementNode) -> SwiftUI.Text {
        text.baselineOffset(baselineOffset.resolve(on: element))
    }
}
