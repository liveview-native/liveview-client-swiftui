//
//  UnredactedModifier.swift
//  LiveViewNative
//
//  Created by murtza on 11/05/2023.
//

import SwiftUI

/// Removes any reason to apply a redaction to this view hierarchy.
///
/// ```html
/// <VStack modifiers={unredacted([])}>
///   ...
/// </VStack>
/// ```
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct UnredactedModifier: ViewModifier, Decodable {
    func body(content: Content) -> some View {
        content.unredacted()
    }
}
