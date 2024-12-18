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
/// ```heex
/// <Element style='kerning(attr("kerning"))' kerning={@kerning} />
/// ```
@_documentation(visibility: public)
@ASTDecodable("kerning")
struct _KerningModifier<Root: RootRegistry>: TextModifier {
    let kerning: AttributeReference<CoreFoundation.CGFloat>

    @ObservedElement private var element
    @LiveContext<Root> private var context
    
    init(_ kerning: AttributeReference<CoreFoundation.CGFloat>) {
        self.kerning = kerning
    }
    
    func body(content: Content) -> some View {
        content
            .kerning(kerning.resolve(on: element, in: context))
    }
    
    func apply<R: RootRegistry>(to text: SwiftUI.Text, on element: ElementNode, in context: LiveContext<R>) -> SwiftUI.Text {
        text.kerning(kerning.resolve(on: element, in: context))
    }
}
