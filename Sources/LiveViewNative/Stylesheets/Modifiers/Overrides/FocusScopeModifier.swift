//
//  FocusScopeModifier.swift
//
//
//  Created by Carson Katri on 11/22/23.
//

import SwiftUI
import LiveViewNativeStylesheet

@ParseableExpression
struct _FocusScopeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "focusScope" }
    
    let namespace: AttributeReference<String>
    
    @ObservedElement private var element
    @LiveContext<R> private var context
    
    @Environment(\.namespaces) private var namespaces

    @available(watchOS 7.0,macOS 12.0,tvOS 14.0, *)
    init(_ namespace: AttributeReference<String>) {
        self.namespace = namespace
    }

    func body(content: Content) -> some View {
        #if os(watchOS) || os(macOS) || os(tvOS)
        content.focusScope(namespaces[namespace.resolve(on: element, in: context)]!)
        #else
        content
        #endif
    }
}
