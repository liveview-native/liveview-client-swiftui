//
//  FocusScopeModifier.swift
//
//
//  Created by Carson Katri on 11/22/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.View/focusScope(_:)`](https://developer.apple.com/documentation/swiftui/view/focusScope(_:)) for more details on this ViewModifier.
///
/// ### focusScope(_:)
/// - `namespace`: `attr("...")` or ``Swift/String`` (required)
///
/// See [`SwiftUI.View/focusScope(_:)`](https://developer.apple.com/documentation/swiftui/view/focusScope(_:)) for more details on this ViewModifier.
///
/// Example:
///
/// ```elixir
/// # stylesheet
/// "example" do
///   focusScope(attr("namespace"))
/// end
/// ```
///
/// ```heex
/// <%!-- template --%>
/// <Element class="example" namespace={@namespace} />
/// ```
@_documentation(visibility: public)
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
