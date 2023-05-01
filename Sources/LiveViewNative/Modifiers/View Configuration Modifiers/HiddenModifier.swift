//
//  HiddenModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 4/21/23.
//

import SwiftUI

/// Hides any element.
///
/// ```html
/// <VStack>
///    <Text modifiers={hidden(@native, is_active: true)}>This text is hidden</Text>
///    <Text modifiers={hidden(@native, is_active: false)}>This text is visible</Text>
/// </VStack>
///
/// ## Arguments
/// * ``is_active``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct HiddenModifier: ViewModifier, Decodable {
    /// A boolean indicating whether the view should be hidden.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private var isActive: Bool

    func body(content: Content) -> some View {
        if isActive {
            content.hidden()
        } else {
            content
        }
    }
}
