//
//  TextInputAutocapitalizationModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/18/23.
//

import SwiftUI

/// Sets how often the shift key in the keyboard is automatically enabled.
///
/// ```html
/// <TextField modifiers={text_input_autocapitalization(:words)}>
///     Full name
/// </TextField>
/// ```
///
/// ## Arguments
/// * ``autocapitalization``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, watchOS 9.0, tvOS 16.0, *)
struct TextInputAutocapitalizationModifier: ViewModifier, Decodable {
    /// One of the capitalizing behaviors defined in the `TextInputAutocapitalization` struct or nil.
    ///
    /// Possible values:
    /// * `characters`
    /// * `sentences`
    /// * `words`
    /// * `never`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let autocapitalization: TextInputAutocapitalization?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        #if os(iOS) || os(watchOS) || os(tvOS)
        switch try container.decodeIfPresent(String.self, forKey: .autocapitalization) {
        case "characters":
            self.autocapitalization = .characters
        case "sentences":
            self.autocapitalization = .sentences
        case "words":
            self.autocapitalization = .words
        case "never":
            self.autocapitalization = .never
        case .none:
            self.autocapitalization = nil
        default:
            throw DecodingError.dataCorruptedError(forKey: .autocapitalization, in: container, debugDescription: "invalid value for \(CodingKeys.autocapitalization.rawValue)")
        }
        #else
        throw DecodingError.typeMismatch(Self.self, .init(codingPath: container.codingPath, debugDescription: "`text_input_autocapitalization` modifier not available on this platform"))
        #endif
    }
    
    func body(content: Content) -> some View {
        content
            #if os(iOS) || os(watchOS) || os(tvOS)
            .textInputAutocapitalization(autocapitalization)
            #endif
    }
    
    enum CodingKeys: String, CodingKey {
        case autocapitalization
    }
}

extension TextInputAutocapitalizationModifier {
    #if os(macOS)
    typealias TextInputAutocapitalization = Never
    #endif
}
