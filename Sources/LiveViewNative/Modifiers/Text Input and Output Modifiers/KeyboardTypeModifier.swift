//
//  KeyboardTypeModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/18/23.
//

import SwiftUI

/// Sets the keyboard type for this view.
///
/// ```html
/// <TextField modifiers={keyboard_type(@native, type: :email_address)}>
///     Email
/// </TextField>
/// ```
///
/// ## Arguments
/// * ``type``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, tvOS 16.0, *)
struct KeyboardTypeModifier: ViewModifier, Decodable, Equatable {
    /// One of the `UIKeyboardType` enumerations.
    ///
    /// Possible values:
    /// * `default`
    /// * `ascii_capable`
    /// * `numbers_and_punctuation`
    /// * `url`
    /// * `number_pad`
    /// * `name_phone_pad`
    /// * `email_address`
    /// * `decimal_pad`
    /// * `twitter`
    /// * `web_search`
    /// * `ascii_capable_number_pad`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let type: UIKeyboardType
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        switch try container.decode(String.self, forKey: .type) {
        case "default":
            self.type = .default
        case "ascii_capable":
            self.type = .asciiCapable
        case "numbers_and_punctuation":
            self.type = .numbersAndPunctuation
        case "url":
            self.type = .URL
        case "number_pad":
            self.type = .numberPad
        case "name_phone_pad":
            self.type = .namePhonePad
        case "email_address":
            self.type = .emailAddress
        case "decimal_pad":
            self.type = .decimalPad
        case "twitter":
            self.type = .twitter
        case "web_search":
            self.type = .webSearch
        case "ascii_capable_number_pad":
            self.type = .asciiCapableNumberPad
        default:
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "invalid value for \(CodingKeys.type.rawValue)")
        }
    }
    
    func body(content: Content) -> some View {
        content
            #if os(iOS) || os(tvOS)
            .keyboardType(type)
            #endif
    }
    
    enum CodingKeys: String, CodingKey {
        case type
    }
}
