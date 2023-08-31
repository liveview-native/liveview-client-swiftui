//
//  ListSectionSeparatorTintModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/13/2023.
//

import SwiftUI

/// Sets the color of dividers between ``Section`` elements in a ``List``.
///
/// Apply this modifier to a ``Section`` element in a ``List``.
/// Pass a ``color`` and optionally the target ``edges``.
///
/// Only the dividers on the specified ``edges`` will be tinted.
/// By default, all edges are tinted.
///
/// ```html
/// <List list-style="plain">
///     <Section modifiers={list_section_separator_tint(:blue, edges: :bottom)} id="blue">
///         ...
///     </Section>
///     <Section modifiers={list_section_separator_tint(:green)} id="green">
///         ...
///     </Section>
/// </List>
/// ```
///
/// ## Arguments
/// * ``color``
/// * ``edges``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, macOS 13.0, *)
struct ListSectionSeparatorTintModifier: ViewModifier, Decodable {
    /// The tint color to apply.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let color: SwiftUI.Color?

    /// The edges to tint. Defaults to `all`.
    ///
    /// Possible values:
    /// * `all`
    /// * `bottom`
    /// * `top`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let edges: VerticalEdge.Set

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.color = try container.decodeIfPresent(SwiftUI.Color.self, forKey: .color)
        switch try container.decode(String.self, forKey: .edges) {
        case "all": self.edges = .all
        case "bottom": self.edges = .bottom
        case "top": self.edges = .top
        case let `default`: throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "Unknown edges '\(`default`)'"))
        }
    }

    func body(content: Content) -> some View {
        content
            #if os(iOS) || os(macOS)
            .listSectionSeparatorTint(color, edges: edges)
            #endif
    }

    enum CodingKeys: String, CodingKey {
        case color
        case edges
    }
}
