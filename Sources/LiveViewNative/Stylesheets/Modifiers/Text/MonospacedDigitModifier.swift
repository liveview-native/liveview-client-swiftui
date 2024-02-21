//
//  MonospacedDigitModifier.swift
//
//
//  Created by Carson Katri on 2/21/24.
//

import SwiftUI
import LiveViewNativeStylesheet

@ParseableExpression
struct _MonospacedDigitModifier<R: RootRegistry>: TextModifier {
    static var name: String { "monospacedDigit" }

    init() {}

    func body(content: Content) -> some View {
        content.monospacedDigit()
    }
    
    func apply(to text: SwiftUI.Text, on element: ElementNode) -> SwiftUI.Text {
        text.monospacedDigit()
    }
}
