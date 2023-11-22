//
//  FocusScopeModifier.swift
//
//
//  Created by Carson Katri on 11/22/23.
//

import SwiftUI
import LiveViewNativeStylesheet

@ParseableExpression
struct _FocusScopeModifier: ViewModifier {
    static let name = "focusScope"

    @Environment(\.namespaces) private var namespaces
    
    let namespace: String

    @available(watchOS 7.0,macOS 12.0,tvOS 14.0, *)
    init(_ namespace: String) {
        self.namespace = namespace
    }

    func body(content: Content) -> some View {
        #if os(watchOS) || os(macOS) || os(tvOS)
        content.focusScope(namespaces[namespace]!)
        #else
        content
        #endif
    }
}
