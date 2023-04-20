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
/// <TextField modifiers={autocapitalization(@native, autocapitalization: :words)}>
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
struct TextInputAutocapitalizationModifier: ViewModifier, Decodable, Equatable {
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
    @available(iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    private let autocapitalizationType: UITextAutocapitalizationType?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        switch try container.decodeIfPresent(String.self, forKey: .autocapitalization) {
        case "characters":
            self.autocapitalizationType = .allCharacters
        case "sentences":
            self.autocapitalizationType = .sentences
        case "words":
            self.autocapitalizationType = .words
        case "never":
            self.autocapitalizationType = UITextAutocapitalizationType.none
        case .none:
            self.autocapitalizationType = nil
        default:
            throw DecodingError.dataCorruptedError(forKey: .autocapitalization, in: container, debugDescription: "invalid value for \(CodingKeys.autocapitalization.rawValue)")
        }
    }
    
    func body(content: Content) -> some View {
        #if os(iOS) || os(watchOS) || os(tvOS)
        var autocapitalization: TextInputAutocapitalization?
        if let autocapitalizationType {
            autocapitalization = TextInputAutocapitalization(autocapitalizationType)
        }

        return content.textInputAutocapitalization(autocapitalization)
        #else
        return content
        #endif
    }
    
    enum CodingKeys: String, CodingKey {
        case autocapitalization
    }
}
