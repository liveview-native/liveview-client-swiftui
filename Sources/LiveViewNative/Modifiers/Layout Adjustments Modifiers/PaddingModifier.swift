//
//  PaddingModifier.swift
// LiveViewNative
//
//  Created by Shadowfacts on 9/12/22.
//

import SwiftUI

/// Adds space around the element.
///
/// Pass ``LiveViewNative/SwiftUI/EdgeInsets`` to the ``insets`` argument to set different padding amounts for each edge.
///
/// ```html
/// <Text modifiers={padding(insets: [top: 10, bottom: 20])}>
///     ...
/// </Text>
/// ```
///
/// Set a ``length`` value to inset a set of ``edges`` by the same amount.
///
/// ```html
/// <Text modifiers={padding(10)}>
///     ...
/// </Text>
/// <Text modifiers={padding(:horizontal, 10)}>
///     ...
/// </Text>
/// ```
///
/// To use the system padding amount, omit the ``length`` argument.
///
/// ```html
/// <Text modifiers={padding([])}>
///     ...
/// </Text>
/// ```
///
/// ## Arguments
/// * ``insets``
/// * ``edges``
/// * ``length``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct PaddingModifier: ViewModifier, Decodable, Equatable {
    /// The amount to inset by.
    ///
    /// This argument takes precedence over other options.
    ///
    /// See ``LiveViewNative/SwiftUI/EdgeInsets`` for more details on creating insets.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let insets: EdgeInsets?
    
    /// The edges to inset. Defaults to `all`.
    ///
    /// See ``LiveViewNative/SwiftUI/Edge/Set`` for more details on creating insets.
#if swift(>=5.8)
    @_documentation(visibility: public)
#endif
    private let edges: Edge.Set
    
    /// The amount to inset all ``edges`` by.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let length: CGFloat?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.insets = try container.decodeIfPresent(EdgeInsets.self, forKey: .insets)
        self.edges = try container.decodeIfPresent(Edge.Set.self, forKey: .edges) ?? .all
        self.length = try container.decodeIfPresent(CGFloat.self, forKey: .length)
    }
    
    func body(content: Content) -> some View {
        if let insets {
            content.padding(insets)
        } else {
            content.padding(edges, length)
        }
    }
    
    enum CodingKeys: CodingKey {
        case insets
        case edges
        case length
    }
}
