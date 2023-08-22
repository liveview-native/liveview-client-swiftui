//
//  AllowsHitTestingModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 5/1/23.
//

import SwiftUI

/// Configures whether this view participates in hit test operations.
///
/// ```html
/// <Circle
///     modifiers={
///         frame(width: 32, height: 32)
///         |> allows_hit_testing(true)
///     }
/// />
/// ```
///
/// ## Arguments
/// * ``enabled``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct AllowsHitTestingModifier: ViewModifier, Decodable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let enabled: Bool
    
    func body(content: Content) -> some View {
        content.allowsHitTesting(enabled)
    }
}
