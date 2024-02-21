//
//  BoldModifier.swift
//
//
//  Created by Carson Katri on 2/20/24.
//

import SwiftUI
import LiveViewNativeStylesheet

@ParseableExpression
struct _BoldModifier<R: RootRegistry>: TextModifier {
    static var name: String { "bold" }

    let isActive: AttributeReference<Bool>

    @ObservedElement private var element
    @LiveContext<R> private var context
    
    init(_ isActive: AttributeReference<Bool> = .init(storage: .constant(true))) {
        self.isActive = isActive
    }
    
    func body(content: Content) -> some View {
        content.bold(isActive.resolve(on: element, in: context))
    }
    
    func apply(to text: SwiftUI.Text, on element: ElementNode) -> SwiftUI.Text {
        text.bold(isActive.resolve(on: element))
    }
}
