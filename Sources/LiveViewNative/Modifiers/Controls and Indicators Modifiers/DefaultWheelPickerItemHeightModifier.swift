//
//  DefaultWheelPickerItemHeightModifier.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 4/26/23.
//

import SwiftUI

/// Sets the default height of items in wheel style ``Picker``s.
///
/// ## Attributes
/// - ``height``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(watchOS 9.0, *)
struct DefaultWheelPickerItemHeightModifier: ViewModifier, Decodable {
    /// The item height.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    let height: CGFloat
    
    func body(content: Content) -> some View {
        content
            #if os(watchOS)
            .defaultWheelPickerItemHeight(height)
            #endif
    }
}
