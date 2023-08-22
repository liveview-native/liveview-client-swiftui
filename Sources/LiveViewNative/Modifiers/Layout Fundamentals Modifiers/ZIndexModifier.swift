//
//  ZIndexModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 4/21/23.
//

import SwiftUI

/// Sets the drawing order of any element.
///
/// ```html
/// <VStack>
///    <Text modifiers={z_index(2.0)}>This element will be above</Text>
///    <Text modifiers={z_index(1.0)}>This element will be below</Text>
/// </VStack>
///
/// ## Arguments
/// * ``value``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ZIndexModifier: ViewModifier, Decodable {
    /// A relative front-to-back ordering for the view
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private var value: Double

    func body(content: Content) -> some View {
        content.zIndex(value)
    }
}
