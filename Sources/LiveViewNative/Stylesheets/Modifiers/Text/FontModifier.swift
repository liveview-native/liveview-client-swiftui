//
//  FontModifier.swift
//
//
//  Created by Carson Katri on 2/21/24.
//

import SwiftUI
import LiveViewNativeStylesheet

@ParseableExpression
struct _FontModifier<R: RootRegistry>: TextModifier {
    static var name: String { "font" }

    let font: SwiftUI.Font?
    
    init(_ font: SwiftUI.Font?) {
        self.font = font
    }

    func body(content: Content) -> some View {
        content.font(font)
    }
    
    func apply(to text: SwiftUI.Text, on element: ElementNode) -> SwiftUI.Text {
        text.font(font)
    }
}
