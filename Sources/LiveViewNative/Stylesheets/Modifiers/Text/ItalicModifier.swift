//
//  ItalicModifier.swift
//
//
//  Created by Carson Katri on 2/21/24.
//

import SwiftUI
import LiveViewNativeStylesheet

@ParseableExpression
struct _ItalicModifier<Root: RootRegistry>: TextModifier {
    static var name: String { "italic" }
    
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
