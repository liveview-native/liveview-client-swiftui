//
//  CornerRadiusModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/19/23.
//

import SwiftUI

/// Clips this view to its bounding frame, with the specified corner ``radius``.
///
/// ```html
/// <Image name="MyCustomImage" modifiers={corner_radius(@native, radius: 8)} />
/// ```
///
/// ## Arguments
/// * ``radius``
/// * ``antialiased``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct CornerRadiusModifier: ViewModifier, Decodable {
    /// The corner radius in points.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let radius: CGFloat

    /// A Boolean value that indicates whether the rendering system applies smoothing to the edges of the clipping rectangle. Defaults to true.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let antialiased: Bool

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.radius = try container.decode(CGFloat.self, forKey: .radius)
        self.antialiased = try container.decode(Bool.self, forKey: .antialiased)
    }

    func body(content: Content) -> some View {
        content.cornerRadius(radius, antialiased: antialiased)
    }

    enum CodingKeys: String, CodingKey {
        case radius
        case antialiased
    }
}
