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
/// <Text modifiers={hidden()}>This text is hidden</Text>
/// ```
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct HiddenModifier: ViewModifier, Decodable {
    func body(content: Content) -> some View {
        content.hidden()
    }
}
