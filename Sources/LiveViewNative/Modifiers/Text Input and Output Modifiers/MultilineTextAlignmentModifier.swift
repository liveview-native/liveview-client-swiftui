//
//  MultilineTextAlignmentModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/18/23.
//

import SwiftUI

/// Sets the alignment of a text view that contains multiple lines of text.
///
/// ```html
/// <Text modifiers={multiline_text_alignment(:trailing)}>
///   Hello world.
///   Goodbye cruel world.
/// </Text>
/// ```
///
/// ## Arguments
/// * ``alignment``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct MultilineTextAlignmentModifier: ViewModifier, Decodable, Equatable {
    /// One of the `TextAlignment` enumerations.
    ///
    /// Possible values:
    /// * `center`
    /// * `leading`
    /// * `trailing`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let alignment: SwiftUI.TextAlignment
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        switch try container.decode(String.self, forKey: .alignment) {
        case "center":
            self.alignment = .center
        case "leading":
            self.alignment = .leading
        case "trailing":
            self.alignment = .trailing
        default:
            throw DecodingError.dataCorruptedError(forKey: .alignment, in: container, debugDescription: "invalid value for \(CodingKeys.alignment.rawValue)")
        }
    }
    
    func body(content: Content) -> some View {
        content.multilineTextAlignment(alignment)
    }
    
    enum CodingKeys: String, CodingKey {
        case alignment
    }
}
