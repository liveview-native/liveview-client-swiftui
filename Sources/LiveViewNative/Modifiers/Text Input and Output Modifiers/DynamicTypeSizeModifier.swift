//
//  DynamicTypeSizeModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 4/1/23.
//

import SwiftUI

/// Changes the size of the text for any element based on the user's preferred content size.
///
/// ```html
/// <Text
///     modifiers={
///         dynamicTypeSize(@native, size: .x_large)
///     }
/// >
///  This element has extra large text.
/// </Text>
/// ```
///
/// ## Arguments
/// * ``size``: The size of the dynamic type.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct DynamicTypeSizeModifier: ViewModifier, Decodable, Equatable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let size: DynamicTypeSize

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        switch try container.decode(String.self, forKey: .size) {
        case "x_small":
            self.size = .xSmall
        case "small":
            self.size = .small
        case "medium":
            self.size = .medium
        case "large":
            self.size = .large
        case "x_large":
            self.size = .xLarge
        case "xx_large":
            self.size = .xxLarge
        case "xxx_large":
            self.size = .xxxLarge
        case "accessibility_1":
            self.size = .accessibility1
        case "accessibility_2":
            self.size = .accessibility2
        case "accessibility_3":
            self.size = .accessibility3
        case "accessibility_4":
            self.size = .accessibility4
        case "accessibility_5":
            self.size = .accessibility5
        default:
            throw DecodingError.dataCorruptedError(forKey: .size, in: container, debugDescription: "invalid value for size")
        }
    }

    func body(content: Content) -> some View {
        content.dynamicTypeSize(size)
    }

    enum CodingKeys: String, CodingKey {
        case size
    }
}