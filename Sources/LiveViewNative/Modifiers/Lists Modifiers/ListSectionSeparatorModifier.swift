//
//  ListSectionSeparatorModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/13/2023.
//

import SwiftUI

/// Sets the visibility of dividers between ``Section`` elements in a ``List``.
///
/// Apply this modifier to a ``Section`` element to configure the visibility of its dividers.
/// Only the dividers on ``edges`` will be changed. By default the visibility option applies to all edges.
///
/// ```html
/// <List list-style="plain">
///     <Section modifiers={list_section_separator(visibility: :hidden)} id="hidden">
///         ...
///     </Section>
///     <Section id="default">
///         ...
///     </Section>
/// </List>
/// ```
///
/// ## Arguments
/// * ``visibility``
/// * ``edges``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, macOS 13.0, *)
struct ListSectionSeparatorModifier: ViewModifier, Decodable {
    /// The visibility of the dividers.
    ///
    /// See ``LiveViewNative/SwiftUI/Visibility`` for a list of possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let visibility: Visibility

    /// The edges to change.
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

        self.visibility = try container.decode(Visibility.self, forKey: .visibility)

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
            .listSectionSeparator(visibility, edges: edges)
            #endif
    }

    enum CodingKeys: String, CodingKey {
        case visibility
        case edges
    }
}

