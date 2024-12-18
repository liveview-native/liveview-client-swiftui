//
//  ItalicModifier.swift
//
//
//  Created by Carson Katri on 2/21/24.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.View/italic(_:)`](https://developer.apple.com/documentation/swiftui/view/italic(_:)) for more details on this ViewModifier.
///
/// ### italic(_:)
/// - `isActive`: `attr("...")` or ``Swift/Bool``
///
/// See [`SwiftUI.View/italic(_:)`](https://developer.apple.com/documentation/swiftui/view/italic(_:)) for more details on this ViewModifier.
///
/// Example:
///
/// ```heex
/// <Element style='italic(attr("isActive"))' isActive={@isActive} />
/// ```
@_documentation(visibility: public)
@ASTDecodable("italic")
struct _ItalicModifier<Root: RootRegistry>: TextModifier {
    let isActive: AttributeReference<Bool>

    @ObservedElement private var element
    @LiveContext<Root> private var context

    init(_ isActive: AttributeReference<Bool> = .init(storage: .constant(true)) ) {
        self.isActive = isActive
    }
    
    func body(content: Content) -> some View {
        content.italic(isActive.resolve(on: element, in: context))
    }
    
    func apply<R: RootRegistry>(to text: SwiftUI.Text, on element: ElementNode, in context: LiveContext<R>) -> SwiftUI.Text {
        text.italic(isActive.resolve(on: element, in: context))
    }
}
