
//
//  MonospacedModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 4/1/23.
//

import SwiftUI

/// Changes the font within any element to be monospaced.
///
/// ```html
/// <Text
///     modifiers={
///         monospaced(@native, is_active: true)
///     }
/// >
///   This text is monospaced.
/// </Text>
/// ```
///
/// ## Arguments
/// * ``isActive``: A boolean that indicates whether the monospaced font should be used.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct MonospacedModifier: ViewModifier, Decodable, Equatable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let isActive: Bool

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.isActive = try container.decode(Bool.self, forKey: .isActive)
    }

    func body(content: Content) -> some View {
        return content.monospaced(isActive)
    }
    
    enum CodingKeys: String, CodingKey {
        case isActive = "is_active"
    }
}
