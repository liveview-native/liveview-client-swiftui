//
//  AutocorrectionDisabledModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/18/23.
//

import SwiftUI

/// Sets whether to disable autocorrection for this view.
///
/// ```html
/// <TextField modifiers={autocorrection_disabled(@native)}>Enter text</TextField>
/// <TextField modifiers={autocorrection_disabled(@native, disable: false)}>Enter text</TextField>
/// ```
///
/// ## Arguments
/// * ``disable``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct AutocorrectionDisabledModifier: ViewModifier, Decodable {
    /// A Boolean value that indicates whether autocorrection is disabled for this view. The default value is true.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private var disable: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.disable = try container.decode(Bool.self, forKey: .disable)
    }

    func body(content: Content) -> some View {
        content.autocorrectionDisabled(disable)
    }
    
    enum CodingKeys: String, CodingKey {
        case disable
    }
}
