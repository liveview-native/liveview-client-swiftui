//
//  KerningModifier.swift
//
//
//  Created by Carson Katri on 2/21/24.
//

import SwiftUI
import LiveViewNativeStylesheet

@ParseableExpression
struct _KerningModifier<Root: RootRegistry>: TextModifier {
    static var name: String { "kerning" }

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
