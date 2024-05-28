//
//  PrefersDefaultFocus.swift
//
//
//  Created by Carson Katri on 11/22/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.View/prefersDefaultFocus(_:in:)`](https://developer.apple.com/documentation/swiftui/view/prefersDefaultFocus(_:in:)) for more details on this ViewModifier.
///
/// ### prefersDefaultFocus(_:in:)
/// - `prefersDefaultFocus`: `attr("...")` or ``Swift/Bool`` (required)
/// - `in`: `attr("...")` or ``Swift/String`` (required)
///
/// See [`SwiftUI.View/prefersDefaultFocus(_:in:)`](https://developer.apple.com/documentation/swiftui/view/prefersDefaultFocus(_:in:)) for more details on this ViewModifier.
///
/// Example:
///
/// ```heex
/// <Element style='prefersDefaultFocus(attr("prefersDefaultFocus"), in: attr("namespace"))' prefersDefaultFocus={@prefersDefaultFocus} namespace={@namespace} />
/// ```
@_documentation(visibility: public)
@ParseableExpression
struct _PrefersDefaultFocusModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "prefersDefaultFocus" }

    let prefersDefaultFocus: AttributeReference<Bool>
    let namespace: AttributeReference<String>

    @ObservedElement private var element
    @LiveContext<R> private var context
    @Environment(\.namespaces) private var namespaces

    @available(tvOS 14.0,macOS 12.0,watchOS 7.0, *)
    init(_ prefersDefaultFocus: AttributeReference<Bool>, in namespace: AttributeReference<String>) {
        self.prefersDefaultFocus = prefersDefaultFocus
        self.namespace = namespace
    }

    func body(content: Content) -> some View {
        #if os(tvOS) || os(macOS) || os(watchOS)
        content
            .prefersDefaultFocus(
                prefersDefaultFocus.resolve(on: element, in: context),
                in: namespaces[namespace.resolve(on: element, in: context)]!
            )
        #else
        content
        #endif
    }
}
