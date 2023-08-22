//
//  AntialiasedModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 6/1/23.
//

import SwiftUI

/// Enables/disables antialiasing.
///
/// ```html
/// <Image system-name="heart.fill" modifiers={antialiased(true)} />
/// ```
///
/// ## Arguments
/// * ``isActive``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct AntialiasedModifier: ImageModifier, Decodable {
    /// Specifies if antialiasing is enabled.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let isActive: Bool
    
    func apply(to image: SwiftUI.Image) -> SwiftUI.Image {
        image.antialiased(isActive)
    }
}
