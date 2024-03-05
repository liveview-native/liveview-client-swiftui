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
/// ```heex
/// <Element style='baselineOffset(attr("baselineOffset"))' baselineOffset={@baselineOffset} />
/// ```
@_documentation(visibility: public)
@ParseableExpression
struct _BaselineOffsetModifier<Root: RootRegistry>: TextModifier {
    static var name: String { "baselineOffset" }

    let baselineOffset: AttributeReference<CoreFoundation.CGFloat>

    @ObservedElement private var element
    @LiveContext<Root> private var context
    
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
    
    func apply<R: RootRegistry>(to text: SwiftUI.Text, on element: ElementNode, in context: LiveContext<R>) -> SwiftUI.Text {
        text.baselineOffset(baselineOffset.resolve(on: element, in: context))
    }
}
