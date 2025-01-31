//
//  StylesheetResolvableCustomAnimation.swift
//  LiveViewNative
//
//  Created by Carson.Katri on 1/30/25.
//

import SwiftUI
import LiveViewNativeStylesheet

@ASTDecodable("CustomAnimation")
@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
enum StylesheetResolvableCustomAnimation: CustomAnimation, StylesheetResolvable {
    case __never
    
    func animate<V>(value: V, time: TimeInterval, context: inout AnimationContext<V>) -> V? where V : VectorArithmetic {
        value
    }
}

@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
extension StylesheetResolvableCustomAnimation {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Self {
        return self
    }
}
