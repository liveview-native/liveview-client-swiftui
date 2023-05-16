//
//  PrivacySensitiveModifier.swift
//  
//
//  Created by murtza on 16/05/2023.
//

import SwiftUI

/// Marks the view as containing sensitive, private user data.
///
/// ```html
/// <Text modifiers={privacy_sensitive(@native, sensitive: :true)}>Private Information</Text>
/// ```

#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct PrivacySensitiveModifier: ViewModifier, Decodable {
    /// A boolean value.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private var sensitive: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        switch try container.decode(String.self, forKey: .sensitive) {
        case "true":
            sensitive = true
        case "false":
            sensitive = false
        default:
            throw DecodingError.dataCorruptedError(forKey: .sensitive, in: container, debugDescription: "invalid value for sensitive")
        }
    }

    func body(content: Content) -> some View {
        content.privacySensitive(sensitive)
    }
    
    enum CodingKeys: String, CodingKey {
        case sensitive
    }
}
