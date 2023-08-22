//
//  TruncationModeModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/18/23.
//

import SwiftUI

/// Sets the truncation mode for lines of text that are too long to fit in the available space.
///
/// ```html
/// <Text modifiers={truncation_mode(:tail)}>
///   This text is truncated at the end if it overflows
/// </Text>
/// ```
///
/// ## Arguments
/// * ``mode``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct TruncationModeModifier: ViewModifier, Decodable, Equatable {
    /// One of the `Text.TruncationMode` enumerations.
    ///
    /// Possible values:
    /// * `head`
    /// * `middle`
    /// * `tail`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let mode: SwiftUI.Text.TruncationMode
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        switch try container.decode(String.self, forKey: .mode) {
        case "head":
            mode = .head
        case "middle":
            mode = .middle
        case "tail":
            mode = .tail
        default:
            throw DecodingError.dataCorruptedError(forKey: .mode, in: container, debugDescription: "invalid value for truncation")
        }
    }
    
    func body(content: Content) -> some View {
        content.truncationMode(mode)
    }
    
    enum CodingKeys: String, CodingKey {
        case mode
    }
}
