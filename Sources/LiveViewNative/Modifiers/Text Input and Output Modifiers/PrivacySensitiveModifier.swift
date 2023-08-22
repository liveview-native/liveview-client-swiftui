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
/// <Text modifiers={privacy_sensitive(true)}>Private Information</Text>
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
    
    func body(content: Content) -> some View {
        content.privacySensitive(sensitive)
    }
}
