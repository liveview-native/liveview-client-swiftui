//
//  SymbolRenderingModeModifier.swift
//  LiveViewNative
//
//  Created by murtza on 03/05/2023.
//

import SwiftUI

/// Sets the rendering mode for symbol images within this view.
///
/// ```html
/// <HStack modifiers={symbol_rendering_mode(:multicolor)}>
///   <Image system-name="heart.circle"></Image>
/// </HStack>
/// ```
///
/// ## Arguments
/// * ``mode``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct SymbolRenderingModeModifier: ViewModifier, Decodable, ImageModifier {
    /// A symbol rendering mode.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private var mode: SwiftUI.SymbolRenderingMode
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        switch try container.decode(String.self, forKey: .mode) {
        case "hierarchical":
            mode = .hierarchical
        case "monochrome":
            mode = .monochrome
        case "multicolor":
            mode = .multicolor
        case "palette":
            mode = .palette
        default:
            throw DecodingError.dataCorruptedError(forKey: .mode, in: container, debugDescription: "invalid value for mode")
        }
    }

    func body(content: Content) -> some View {
        content.symbolRenderingMode(mode)
    }
    
    func apply(to image: SwiftUI.Image) -> SwiftUI.Image {
        image.symbolRenderingMode(mode)
    }
    
    enum CodingKeys: String, CodingKey {
        case mode
    }
}
