//
//  AccessibilityQuickActionStyle.swift
//  LiveViewNative
//
//  Created by Carson Katri on 2/25/25.
//

#if os(watchOS)
import SwiftUI
import LiveViewNativeStylesheet

@ASTDecodable("AccessibilityQuickActionStyle")
enum StylesheetResolvableAccessibilityQuickActionStyle: @preconcurrency Decodable, StylesheetResolvable, AttributeDecodable {
    case outline
    case prompt
}

extension StylesheetResolvableAccessibilityQuickActionStyle {
    func resolve<R>(on element: ElementNode, in context: LiveContext<R>) -> Self where R : RootRegistry {
        return self
    }
}

extension View {
    @_disfavoredOverload
    @ViewBuilder
    func accessibilityQuickAction<Content: View>(
        style: StylesheetResolvableAccessibilityQuickActionStyle,
        @ViewBuilder content: () -> Content
    ) -> some View {
        switch style {
        case .outline:
            self.accessibilityQuickAction(style: .outline, content: content)
        case .prompt:
            self.accessibilityQuickAction(style: .prompt, content: content)
        }
    }
    
    @_disfavoredOverload
    @ViewBuilder
    func accessibilityQuickAction<Content: View>(
        style: StylesheetResolvableAccessibilityQuickActionStyle,
        isActive: Binding<Bool>,
        @ViewBuilder content: () -> Content
    ) -> some View {
        switch style {
        case .outline:
            self.accessibilityQuickAction(style: .outline, isActive: isActive, content: content)
        case .prompt:
            self.accessibilityQuickAction(style: .prompt, isActive: isActive, content: content)
        }
    }
}
#endif
