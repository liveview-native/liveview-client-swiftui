//
//  ClippedModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/19/23.
//

import SwiftUI

/// Clips this view to its bounding rectangular frame.
///
/// ```html
/// <Text modifiers={clipped(@native, antialiased: true)}>Hello, world!</Text>
/// ```
///
/// ## Arguments
/// * ``antialiased``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ClippedModifier: ViewModifier, Decodable {
    /// A Boolean value that indicates whether the rendering system applies smoothing to the edges of the clipping rectangle. Defaults to false.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let antialiased: Bool

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.antialiased = try container.decodeIfPresent(Bool.self, forKey: .antialiased) ?? false
    }

    func body(content: Content) -> some View {
        content.clipped(antialiased: antialiased)
    }

    enum CodingKeys: String, CodingKey {
        case antialiased
    }
}
