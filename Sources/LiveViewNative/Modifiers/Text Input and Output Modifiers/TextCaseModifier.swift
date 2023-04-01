//
//  TextCaseModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 4/1/23.
//

import SwiftUI

/// Changes the capitalization of the text for any element.
///
/// ```html
/// <Text
///     modifiers={
///         textCase(@native, text_case: :uppercase)
///     }
/// >
///   This text is displayed in uppercase.
/// </Text>
/// ```
///
/// ## Arguments
/// * ``textCase``: One of the `Text.Case` enumerations.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct TextCaseModifier: ViewModifier, Decodable, Equatable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let textCase: SwiftUI.Text.Case
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        switch try container.decode(String.self, forKey: .textCase) {
        case "lowercase":
            self.textCase = .lowercase
        case "uppercase":
            self.textCase = .uppercase
        default:
            throw DecodingError.dataCorruptedError(forKey: .textCase, in: container, debugDescription: "invalid value for textCase")
        }
    }
    
    func body(content: Content) -> some View {
        content.textCase(textCase)
    }
    
    enum CodingKeys: String, CodingKey {
        case textCase = "text_case"
    }
}
