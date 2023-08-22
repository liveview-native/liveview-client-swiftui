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
/// <TextField modifiers={autocorrection_disabled()}>Enter text</TextField>
/// <TextField modifiers={autocorrection_disabled(false)}>Enter text</TextField>
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
    
    func body(content: Content) -> some View {
        content.autocorrectionDisabled(disable)
    }
}
