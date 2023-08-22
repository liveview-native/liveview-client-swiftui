//
//  ImageScaleModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 4/24/23.
//

import SwiftUI

/// Adjusts the scaling of images within an element.
///
/// ```html
/// <HStack modifiers={image_scale(:large)}>
///   <Image system-name="heart.fill"></Image>
/// </HStack>
/// ```
///
/// ## Arguments
/// * ``scale``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ImageScaleModifier: ViewModifier, Decodable {
    /// A relative size to scale images within the view.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private var scale: SwiftUI.Image.Scale
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        switch try container.decode(String.self, forKey: .scale) {
        case "small":
            scale = .small
        case "medium":
            scale = .medium
        case "large":
            scale = .large
        default:
            throw DecodingError.dataCorruptedError(forKey: .scale, in: container, debugDescription: "invalid value for scale")
        }
    }

    func body(content: Content) -> some View {
        content.imageScale(scale)
    }
    
    enum CodingKeys: String, CodingKey {
        case scale
    }
}
