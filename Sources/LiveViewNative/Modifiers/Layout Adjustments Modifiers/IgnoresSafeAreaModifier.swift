//
//  IgnoresSafeAreaModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 5/23/23.
//

import SwiftUI

/// Expands the view out of its safe area.
///
/// ```html
/// <Text modifiers={ignores_safe_area(:container, edges: :top)}>
///     ...
/// </Text>
/// ```
///
/// ## Arguments
/// * ``regions``
/// * ``edges``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct IgnoresSafeAreaModifier: ViewModifier, Decodable {
    /// The kinds of rectangles removed from the safe area that should be ignored (i.e. added back to the safe area of the new child view). Defaults to `all`.
    ///
    /// See ``SafeAreaRegions`` for the list of possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let regions: SafeAreaRegions
    /// The edges to inset. Defaults to `all`.
    ///
    /// See ``LiveViewNative/SwiftUI/Edge/Set`` for more details on creating insets.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let edges: Edge.Set
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.regions = try container.decode(SafeAreaRegions.self, forKey: .regions)
        self.edges = try container.decodeIfPresent(Edge.Set.self, forKey: .edges) ?? .all
    }
    
    func body(content: Content) -> some View {
        switch regions {
        case .all:
            content.ignoresSafeArea(SwiftUI.SafeAreaRegions.all, edges: edges)
        case .container:
            content.ignoresSafeArea(SwiftUI.SafeAreaRegions.container, edges: edges)
        case .keyboard:
            content.ignoresSafeArea(SwiftUI.SafeAreaRegions.keyboard, edges: edges)
        }
    }
    
    enum CodingKeys: CodingKey {
        case regions
        case edges
    }
}

/// A set of symbolic safe area regions.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
private enum SafeAreaRegions: String, Decodable {
    /// All safe area regions.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case all
    /// The safe area defined by the device and containers within the user interface, including elements such as top and bottom bars.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case container
    /// The safe area matching the current extent of any software keyboard displayed over the view content.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case keyboard
}
