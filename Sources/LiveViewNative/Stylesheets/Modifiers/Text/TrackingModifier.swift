//
//  TrackingModifier.swift
//
//
//  Created by Carson Katri on 2/21/24.
//

import SwiftUI
import LiveViewNativeStylesheet

@ParseableExpression
struct _TrackingModifier<R: RootRegistry>: TextModifier {
    static var name: String { "tracking" }

    let tracking: AttributeReference<CoreFoundation.CGFloat>

    @ObservedElement private var element
    @LiveContext<R> private var context
    
    init(_ tracking: AttributeReference<CoreFoundation.CGFloat>) {
        self.tracking = tracking
    }

    func body(content: Content) -> some View {
        content
            .tracking(tracking.resolve(on: element, in: context))
    }
    
    func apply(to text: SwiftUI.Text, on element: ElementNode) -> SwiftUI.Text {
        text
            .tracking(tracking.resolve(on: element))
    }
}
