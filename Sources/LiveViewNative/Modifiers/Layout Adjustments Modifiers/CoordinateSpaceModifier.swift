//
//  CoordinateSpaceModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/20/2023.
//

import SwiftUI

/// Creates a new named ``LiveViewNative/SwiftUI/CoordinateSpace``.
///
/// Specify a ``name`` for the coordinate space.
///
/// ```html
/// <VStack modifiers={coordinate_space("stack")}>
///     ...
/// </VStack>
/// ```
///
/// This space can then be referenced wherever a ``LiveViewNative/SwiftUI/CoordinateSpace`` type is expected.
///
/// ## Arguments
/// * ``name``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct CoordinateSpaceModifier<R: RootRegistry>: ViewModifier, Decodable {
    /// The custom name of the coordinate space.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let name: String

    func body(content: Content) -> some View {
        content.coordinateSpace(name: name)
    }
}
