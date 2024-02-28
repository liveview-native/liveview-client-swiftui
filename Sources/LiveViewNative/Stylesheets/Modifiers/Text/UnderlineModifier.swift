//
//  UnderlineModifier.swift
//  
//
//  Created by Carson Katri on 2/21/24.
//

import SwiftUI
import LiveViewNativeStylesheet

@ParseableExpression
struct _UnderlineModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "underline" }

    let isActive: AttributeReference<Bool>
    let pattern: SwiftUI.Text.LineStyle.Pattern
    let color: AttributeReference<SwiftUI.Color?>?

    @ObservedElement private var element
    @LiveContext<R> private var context
    
    init(
        _ isActive: AttributeReference<Bool> = .init(storage: .constant(true)),
        pattern: SwiftUI.Text.LineStyle.Pattern = .solid,
        color: AttributeReference<SwiftUI.Color?>? = .init(storage: .constant(nil))
    ) {
        self.isActive = isActive
        self.pattern = pattern
        self.color = color
    }
    
    func body(content: Content) -> some View {
        content
            .underline(
                isActive.resolve(on: element, in: context),
                pattern: pattern,
                color: color?.resolve(on: element, in: context)
            )
    }
    
    func apply(to text: SwiftUI.Text, on element: ElementNode) -> SwiftUI.Text {
        text
            .underline(
                isActive.resolve(on: element),
                pattern: pattern,
                color: color?.resolve(on: element)
            )
    }
}
