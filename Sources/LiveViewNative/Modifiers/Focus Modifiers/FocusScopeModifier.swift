//
//  FocusScopeModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 5/18/2023.
//
import SwiftUI

/// Associates an element hierarchy with a namespace.
///
/// Use a ``NamespaceContext`` element to create a focus namespace.
/// Provide the `id` of the namespace to the ``namespace`` argument.
///
/// ```html
/// <NamespaceContext id={:my_namespace}>
///     <VStack modifiers={focus_scope(:my_namespace)}>
///         <TextField>Username</TextField>
///         <TextField modifiers={prefers_default_focus(in: :my_namespace)}>Password</TextField>
///     </VStack>
/// </NamespaceContext>
/// ```
///
/// ## Arguments
/// * ``namespace``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(macOS 13.0, tvOS 14.0, watchOS 7.0, *)
struct FocusScopeModifier: ViewModifier, Decodable {
    /// The namespace to associate this hierarchy with.
    ///
    /// Use a ``NamespaceContext`` element to create a namespace.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let namespace: String

    @Environment(\.namespaces) private var namespaces

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.namespace = try container.decode(String.self, forKey: .namespace)
    }

    func body(content: Content) -> some View {
        #if !os(iOS)
        if let namespace = namespaces[namespace] {
            content
                .focusScope(namespace)
        } else {
            content
        }
        #else
        content
        #endif
    }

    enum CodingKeys: CodingKey {
        case namespace
    }
}
