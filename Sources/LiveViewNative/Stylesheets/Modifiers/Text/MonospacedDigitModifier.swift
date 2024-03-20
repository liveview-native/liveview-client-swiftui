//
//  MonospacedDigitModifier.swift
//
//
//  Created by Carson Katri on 2/21/24.
//

import SwiftUI
import LiveViewNativeStylesheet

@ParseableExpression
struct _MonospacedDigitModifier<Root: RootRegistry>: TextModifier {
    static var name: String { "monospacedDigit" }

    init() {}

    func body(content: Content) -> some View {
        content.monospacedDigit()
    }
    
    func apply<R: RootRegistry>(to text: SwiftUI.Text, on element: ElementNode, in context: LiveContext<R>) -> SwiftUI.Text {
        text.monospacedDigit()
    }
}
