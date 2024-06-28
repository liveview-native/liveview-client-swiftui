//
//  MatchedTransitionSourceModifier.swift
//  
//
//  Created by Carson Katri on 6/18/24.
//

import SwiftUI
import LiveViewNativeStylesheet

@_documentation(visibility: public)
@ParseableExpression
struct _MatchedTransitionSourceModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "matchedTransitionSource" }

    @ObservedElement private var element
    @LiveContext<R> private var context
    @Environment(\.namespaces) private var namespaces

    let id: AttributeReference<String>
    let namespace: AttributeReference<String>

    @available(visionOS 2.0, iOS 18.0, tvOS 18.0, macOS 15.0, watchOS 11.0, *)
    init(id: AttributeReference<String>, in namespace: AttributeReference<String>) {
        self.id = id
        self.namespace = namespace
    }

    func body(content __content: Content) -> some View {
        if #available(visionOS 2.0,iOS 18.0,tvOS 18.0,macOS 15.0,watchOS 11.0, *) {
            __content
                .matchedTransitionSource(
                    id: id.resolve(on: element, in: context),
                    in: namespaces[namespace.resolve(on: element, in: context)]!
                )
        } else { __content }
    }
}
