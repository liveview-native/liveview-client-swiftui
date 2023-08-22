//
//  DefersSystemGesturesModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/25/2023.
//

import SwiftUI

/// Gives precedence to custom gestures over system gestures along an edge set.
///
/// Provide a set of ``edges`` to defer gestures on.
///
/// ```html
/// <Rectangle modifiers={
///   gesture(...)
///     |> defers_system_gestures(on: :vertical)
/// } />
/// ```
///
/// ## Arguments
/// * ``edges``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, *)
struct DefersSystemGesturesModifier<R: RootRegistry>: ViewModifier, Decodable {
    /// The edges to defer system gestures along.
    ///
    /// See ``LiveViewNative/SwiftUI/Edge/Set`` for a list possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let edges: Edge.Set

    func body(content: Content) -> some View {
        content
            #if os(iOS)
            .defersSystemGestures(on: edges)
            #endif
    }
}

