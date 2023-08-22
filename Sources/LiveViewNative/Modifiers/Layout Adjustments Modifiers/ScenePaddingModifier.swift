//
//  ScenePaddingModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 5/23/23.
//

import SwiftUI

/// Adds a specified kind of padding to the specified edges of this view using an amount that’s appropriate for the current scene.
///
/// ```html
/// <Text modifiers={scene_padding(:minimum, edges: :top)}>
///     ...
/// </Text>
/// ```
///
/// ## Arguments
/// * ``padding``
/// * ``edges``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ScenePaddingModifier: ViewModifier, Decodable {
    /// The kind of padding to add. Defaults to `automatic`.
    ///
    /// See ``ScenePadding`` for the list of possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let padding: ScenePadding
    /// The edges to inset. Defaults to `all`.
    ///
    /// See ``LiveViewNative/SwiftUI/Edge/Set`` for more details on creating insets.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let edges: Edge.Set
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.padding = try container.decode(ScenePadding.self, forKey: .padding)
        self.edges = try container.decodeIfPresent(Edge.Set.self, forKey: .edges) ?? .all
    }
    
    func body(content: Content) -> some View {
        switch padding {
        case .automatic:
            content.scenePadding(edges)
        case .minimum:
            content.scenePadding(SwiftUI.ScenePadding.minimum, edges: edges)
        case .navigationBar:
            content
                #if os(watchOS)
                .scenePadding(SwiftUI.ScenePadding.navigationBar, edges: edges)
                #endif
        }
    }
    
    enum CodingKeys: CodingKey {
        case padding
        case edges
    }
}


/// The padding used to space a view from its containing scene.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
private enum ScenePadding: String, Decodable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case automatic
    /// The minimum scene padding value.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case minimum
    /// The navigation bar content scene padding.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(watchOS 9.0, *)
    case navigationBar = "navigation_bar"
}
