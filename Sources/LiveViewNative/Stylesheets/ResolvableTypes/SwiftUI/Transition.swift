//
//  Transition.swift
//  LiveViewNative
//
//  Created by Carson.Katri on 1/30/25.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@ASTDecodable("Transition")
enum StylesheetResolvableTransition: Transition, StylesheetResolvable {
    case opacity
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension StylesheetResolvableTransition {
    func body(content: Content, phase: TransitionPhase) -> some View {
        content
    }
    
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Self {
        return self
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension StylesheetResolvableTransition: AttributeDecodable {
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        self = .opacity
    }
}
