//
//  MatchedGeometryEffectModifier.swift
//  
//
//  Created by Carson Katri on 4/3/23.
//

import SwiftUI

/// Applies an effect that transitions between two Views.
///
/// Use the ``NamespaceContext`` element to establish a namespace.
///
/// ```html
/// <NamespaceContext id="animation">
///     ...
/// </NamespaceContext>
/// ```
///
/// Within that context, this modifier can be applied to any two elements that should transition between each other when some value changes.
/// Use the same `id` argument for elements that should be paired.
///
/// ```html
/// <VStack modifiers={animation(value: Atom.to_string(@is_flipped))}>
///     <%= if @is_flipped do %>
///         <Text id="a" modifiers={matched_geometry_effect(id: "a", namespace: :animation)}>A</Text>
///         <Text id="b" modifiers={matched_geometry_effect(id: "b", namespace: :animation)}>B</Text>
///     <% else %>
///         <Text id="b" modifiers={matched_geometry_effect(id: "b", namespace: :animation)}>B</Text>
///         <Text id="a" modifiers={matched_geometry_effect(id: "a", namespace: :animation)}>A</Text>
///     <% end %>
///     <Button phx-click="flip">Flip</Button>
/// </VStack>
/// ```
///
/// ```elixir
/// defmodule MyAppWeb.FlipLive do
///     def handle_event("flip", _params, socket) do
///       {:noreply, assign(socket, :is_flipped, !socket.assigns.is_flipped)}
///     end
/// end
/// ```
///
/// When the button is tapped, the `A` and `B` text will swap positions with a default animation.
///
/// - Note: The elements the modifier is applied to cannot be visible at the same time. For example, keep them in opposite sides of an `if`/`else` branch.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct MatchedGeometryEffectModifier: ViewModifier, Decodable {
    /// The unique identifier for the pair of elements to transition between.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let id: String

    /// An atom that matches the ``NamespaceContext`` element's ``NamespaceContext/id``.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let namespace: String

    /// The properties of the elements to animate.
    ///
    /// Possible values:
    /// * `frame` - both `position` and `size`
    /// * `size`
    /// * `position`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let properties: MatchedGeometryProperties

    /// The location within the element to use for the shared position.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let anchor: UnitPoint

    /// If this element is the source geometry for the pair.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let isSource: Bool
    
    @Environment(\.namespaces) private var namespaces: [String:Namespace.ID]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        
        self.namespace = try container.decode(String.self, forKey: .namespace)
        
        switch try container.decode(String.self, forKey: .properties) {
        case "frame": self.properties = .frame
        case "position": self.properties = .position
        case "size": self.properties = .size
        case let `default`: throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "Unknown properties '\(`default`)'"))
        }

        self.anchor = try container.decodeIfPresent(UnitPoint.self, forKey: .anchor) ?? .center

        self.isSource = try container.decode(Bool.self, forKey: .isSource)
    }

    func body(content: Content) -> some View {
        content.matchedGeometryEffect(
            id: id,
            in: namespaces[namespace]!,
            properties: properties,
            anchor: anchor,
            isSource: isSource
        )
    }

    enum CodingKeys: String, CodingKey {
        case id
        case namespace
        case properties
        case anchor
        case isSource
    }
}

extension EnvironmentValues {
    private enum NamespacesKey: EnvironmentKey {
        static let defaultValue = [String:Namespace.ID]()
    }
    
    var namespaces: [String:Namespace.ID] {
        get { self[NamespacesKey.self] }
        set { self[NamespacesKey.self] = newValue }
    }
}
