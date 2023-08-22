//
//  DisabledModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 3/29/23.
//

import SwiftUI

/// Disables interaction for any element.
///
/// ```html
/// <Button
///     modifiers={
///         disabled(true)
///     }
/// >
///  <Label>This button is disabled</Label>
/// </Button>
/// ```
///
/// ## Arguments
/// * ``disabled``
struct DisabledModifier: ViewModifier, Decodable, Equatable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let disabled: Bool
    
    func body(content: Content) -> some View {
        content.disabled(disabled)
    }
}
