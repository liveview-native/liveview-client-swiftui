//
//  FontWeightModifier.swift
//
//
//  Created by Carson Katri on 2/21/24.
//

import SwiftUI
import LiveViewNativeStylesheet

@ParseableExpression
struct _FontWeightModifier<R: RootRegistry>: TextModifier {
    static var name: String { "fontWeight" }

    let weight: SwiftUI.Font.Weight?

    init(_ weight: SwiftUI.Font.Weight?) {
        self.weight = weight
    }

    func body(content: Content) -> some View {
        content.fontWeight(weight)
    }
    
    func apply(to text: SwiftUI.Text, on element: ElementNode) -> SwiftUI.Text {
        text.fontWeight(weight)
    }
}
