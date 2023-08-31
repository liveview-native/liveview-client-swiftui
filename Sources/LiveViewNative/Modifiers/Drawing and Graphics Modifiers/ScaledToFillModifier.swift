//
//  ScaledToFillModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/19/23.
//

import SwiftUI

/// Scales this view to fill its parent, maintaining this view’s aspect ratio.
///
/// ```html
/// <Text modifiers={scaled_to_fill([])}>
///   This view will fill its parent.
/// </Text>
/// ```
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ScaledToFillModifier: ViewModifier, Decodable, Equatable {
    func body(content: Content) -> some View {
        return content.scaledToFill()
    }
}
