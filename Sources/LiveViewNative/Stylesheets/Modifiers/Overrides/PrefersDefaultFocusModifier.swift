//
//  PrefersDefaultFocus.swift
//
//
//  Created by Carson Katri on 11/22/23.
//

import SwiftUI
import LiveViewNativeStylesheet

@ParseableExpression
struct _PrefersDefaultFocusModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "prefersDefaultFocus" }

    let prefersDefaultFocus: AttributeReference<Bool>
    let namespace: String

    @ObservedElement private var element
    @LiveContext<R> private var context
    @Environment(\.namespaces) private var namespaces

    @available(tvOS 14.0,macOS 12.0,watchOS 7.0, *)
    init(_ prefersDefaultFocus: AttributeReference<Swift.Bool>, in namespace: String) {
        self.prefersDefaultFocus = prefersDefaultFocus
        self.namespace = namespace
    }

    func body(content: Content) -> some View {
        #if os(tvOS) || os(macOS) || os(watchOS)
        content
            .prefersDefaultFocus(prefersDefaultFocus.resolve(on: element, in: context), in: namespaces[namespace]!)
        #else
        content
        #endif
    }
}
