//
//  ZIndexModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 4/21/23.
//

import SwiftUI

/// Sets the drawing order of any element.
///
/// ```html
/// <VStack>
///    <Text modifiers={z_index(@native, value: 2.0)}>This element will be above</Text>
///    <Text modifiers={z_index(@native, value: 1.0)}>This element will be below</Text>
/// </VStack>
///
/// ## Arguments
/// * ``value``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ZIndexModifier: ViewModifier, Decodable {
    /// A relative front-to-back ordering for the view
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private var value: Double

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.value = try container.decode(Double.self, forKey: .value)
    }

    func body(content: Content) -> some View {
        content.zIndex(value)
    }

    enum CodingKeys: String, CodingKey {
        case value
    }
}
