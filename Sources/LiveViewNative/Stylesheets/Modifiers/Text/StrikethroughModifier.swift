//
//  StrikethroughModifier.swift
//
//
//  Created by Carson Katri on 2/21/24.
//

import SwiftUI
import LiveViewNativeStylesheet

@ParseableExpression
struct _StrikethroughModifier<Root: RootRegistry>: TextModifier {
    static var name: String { "strikethrough" }

    let isActive: AttributeReference<Bool>
    let pattern: SwiftUI.Text.LineStyle.Pattern
    let color: AttributeReference<SwiftUI.Color?>?

    @ObservedElement private var element
    @LiveContext<Root> private var context
    
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
            .strikethrough(
                isActive.resolve(on: element, in: context),
                pattern: pattern,
                color: color?.resolve(on: element, in: context)
            )
    }
    
    func apply<R: RootRegistry>(to text: SwiftUI.Text, on element: ElementNode, in context: LiveContext<R>) -> SwiftUI.Text {
        text
            .strikethrough(
                isActive.resolve(on: element, in: context),
                pattern: pattern,
                color: color?.resolve(on: element, in: context)
            )
    }
}
