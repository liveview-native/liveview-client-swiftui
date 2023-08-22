//
//  PrefersDefaultFocusModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 5/16/2023.
//
import SwiftUI

/// Gives default focus to the element in a ``NamespaceContext``.
///
/// Use a ``NamespaceContext`` element to create a focus namespace.
/// Provide the `id` of the namespace to the ``namespace`` argument.
///
/// ```html
/// <NamespaceContext id={:my_namespace}>
///     <VStack modifiers={focus_scope(:my_namespace)}>
///         <TextField>Username</TextField>
///         <TextField modifiers={prefers_default_focus(in: :my_namespace)}>Password</TextField>
///         <Button phx-click="reset_focus" phx-value-namespace={:my_namespace}>Reset Focus</Button>
///     </VStack>
/// </NamespaceContext>
/// ```
///
/// Push the `reset_focus` event to set focus back to the preferred defaults.
///
/// ```elixir
/// def handle_event("reset_focus", %{ "namespace" => namespace }, socket) do
///   {:noreply, push_event(socket, :reset_focus, %{ namespace: namespace })}
/// end
/// ```
///
/// ## Arguments
/// * ``prefersDefaultFocus``
/// * ``namespace``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(macOS 13.0, tvOS 14.0, watchOS 7.0, *)
struct PrefersDefaultFocusModifier: ViewModifier, Decodable {
    /// Enables/disables the effect of this modifier. Defaults to `true`.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let prefersDefaultFocus: Bool

    /// The namespace where this element prefers default focus.
    ///
    /// Use a ``NamespaceContext`` element to create a namespace.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let namespace: String

    @Environment(\.namespaces) private var namespaces

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.prefersDefaultFocus = try container.decode(Bool.self, forKey: .prefersDefaultFocus)
        self.namespace = try container.decode(String.self, forKey: .namespace)
    }

    func body(content: Content) -> some View {
        #if !os(iOS)
        if let namespace = namespaces[namespace] {
            content
                .prefersDefaultFocus(prefersDefaultFocus, in: namespace)
        } else {
            content
        }
        #else
        content
        #endif
    }

    enum CodingKeys: CodingKey {
        case prefersDefaultFocus
        case namespace
    }
}
