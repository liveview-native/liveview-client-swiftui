//
//  BoldModifier.swift
//
//
//  Created by Carson Katri on 2/20/24.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.View/bold(_:)`](https://developer.apple.com/documentation/swiftui/view/bold(_:)) for more details on this ViewModifier.
///
/// ### bold(_:)
/// - `isActive`: `attr("...")` or ``Swift/Bool``
///
/// See [`SwiftUI.View/bold(_:)`](https://developer.apple.com/documentation/swiftui/view/bold(_:)) for more details on this ViewModifier.
///
/// Example:
///
/// ```heex
/// <Element style='bold(attr("isActive"))' isActive={@isActive} />
/// ```
@_documentation(visibility: public)
@ASTDecodable("bold")
struct _BoldModifier<Root: RootRegistry>: TextModifier {
    let isActive: AttributeReference<Bool>

    @ObservedElement private var element
    @LiveContext<Root> private var context
    
    init(_ isActive: AttributeReference<Bool> = .init(storage: .constant(true))) {
        self.isActive = isActive
    }
    
    func body(content: Content) -> some View {
        content.bold(isActive.resolve(on: element, in: context))
    }
    
    func apply<R: RootRegistry>(to text: SwiftUI.Text, on element: ElementNode, in context: LiveContext<R>) -> SwiftUI.Text {
        text.bold(isActive.resolve(on: element, in: context))
    }
}
