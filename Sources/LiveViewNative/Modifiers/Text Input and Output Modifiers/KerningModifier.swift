//
//  KerningModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/18/23.
//

import SwiftUI

/// Sets whether this view mirrors its contents horizontally when the layout direction is right-to-left.
///
/// ```html
/// <Text modifiers={kerning(@native, kerning: true)}>
///     Hello, world!
/// </Text>
/// ```
///
/// ## Arguments
/// * ``kerning``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct KerningModifier: ViewModifier, Decodable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let kerning: CGFloat

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.kerning = try container.decode(CGFloat.self, forKey: .kerning)
    }

    func body(content: Content) -> some View {
        content.kerning(kerning)
    }

    enum CodingKeys: String, CodingKey {
        case kerning
    }
}
