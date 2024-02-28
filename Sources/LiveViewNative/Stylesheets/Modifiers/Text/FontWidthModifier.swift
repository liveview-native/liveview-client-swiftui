//
//  FontWidthModifier.swift
//
//
//  Created by Carson Katri on 2/21/24.
//

import SwiftUI
import LiveViewNativeStylesheet

@ParseableExpression
struct _FontWidthModifier<R: RootRegistry>: TextModifier {
    static var name: String { "fontWidth" }

    let width: SwiftUI.Font.Width?
    
    init(_ width: SwiftUI.Font.Width?) {
        self.width = width
    }

    func body(content: Content) -> some View {
        content.fontWidth(width)
    }
    
    func apply(to text: SwiftUI.Text, on element: ElementNode) -> SwiftUI.Text {
        text.fontWidth(width)
    }
}
