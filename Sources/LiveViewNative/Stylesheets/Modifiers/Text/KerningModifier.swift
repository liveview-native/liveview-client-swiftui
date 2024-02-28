//
//  KerningModifier.swift
//
//
//  Created by Carson Katri on 2/21/24.
//

import SwiftUI
import LiveViewNativeStylesheet

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
