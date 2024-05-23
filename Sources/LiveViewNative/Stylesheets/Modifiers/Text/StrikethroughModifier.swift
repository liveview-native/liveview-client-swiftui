//
//  StrikethroughModifier.swift
//
//
//  Created by Carson Katri on 2/21/24.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.View/strikethrough(_:pattern:color:)`](https://developer.apple.com/documentation/swiftui/view/strikethrough(_:pattern:color:)) for more details on this ViewModifier.
///
/// ### strikethrough(_:pattern:color:)
/// - `isActive`: `attr("...")` or ``Swift/Bool``
/// - `pattern`: ``SwiftUI/Text/LineStyle/Pattern``
/// - `color`: `attr("...")` or ``SwiftUI/Color`` or `nil`
///
/// See [`SwiftUI.View/strikethrough(_:pattern:color:)`](https://developer.apple.com/documentation/swiftui/view/strikethrough(_:pattern:color:)) for more details on this ViewModifier.
///
/// Example:
///
/// ```elixir
/// # stylesheet
/// "example" do
///   strikethrough(attr("isActive"), pattern: .solid, color: attr("color"))
/// end
/// ```
///
/// ```heex
/// <%!-- template --%>
/// <Element class="example" isActive={@isActive} color={@color} />
/// ```
@_documentation(visibility: public)
@ParseableExpression
struct _StrikethroughModifier<R: RootRegistry>: TextModifier {
    static var name: String { "strikethrough" }

    let isActive: AttributeReference<Bool>
    let pattern: SwiftUI.Text.LineStyle.Pattern
    let color: AttributeReference<SwiftUI.Color?>?

    @ObservedElement private var element
    @LiveContext<R> private var context
    
    init(
        _ isActive: AttributeReference<Bool> = .init(storage: .constant(true)),
        pattern: SwiftUI.Text.LineStyle.Pattern = .solid,
        color: AttributeReference<SwiftUI.Color?>? = .init(storage: .constant(nil))
    ) {
        self.isActive = isActive
        self.pattern = pattern
        self.color = color
    }
    
    func body(content: Content) -> some View {
        content
            .strikethrough(
                isActive.resolve(on: element, in: context),
                pattern: pattern,
                color: color?.resolve(on: element, in: context)
            )
    }
    
    func apply(to text: SwiftUI.Text, on element: ElementNode) -> SwiftUI.Text {
        text
            .strikethrough(
                isActive.resolve(on: element),
                pattern: pattern,
                color: color?.resolve(on: element)
            )
    }
}
