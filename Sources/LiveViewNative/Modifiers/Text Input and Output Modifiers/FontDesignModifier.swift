//
//  FontDesignModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 4/24/23.
//

import SwiftUI

/// Applies a font design to any element.
///
/// <Text modifiers={font_design(@native, design: :default)}>This text is default</Text>
/// <Text modifiers={font_design(@native, design: :monospaced)}>This text is monospaced</Text>
/// <Text modifiers={font_design(@native, design: :rounded)}>This text is rounded</Text>
/// <Text modifiers={font_design(@native, design: :serif)}>This text is serif</Text>
///
/// ## Arguments
/// * ``design``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct FontDesignModifier: ViewModifier, Decodable {
    /// The font design to apply to the view.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private var design: Font.Design
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let designString = try container.decode(String.self, forKey: .design)

        switch designString {
        case "default":
            design = .default
        case "monospaced":
            design = .monospaced
        case "rounded":
            design = .rounded
        case "serif":
            design = .serif
        default:
            throw DecodingError.dataCorruptedError(forKey: .design, in: container, debugDescription: "expected valid value for Font.Design");
        }
    }

    func body(content: Content) -> some View {
        if #available(iOS 16.1, *) {
            content.fontDesign(design)
        } else {
            content
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case design
    }
}
