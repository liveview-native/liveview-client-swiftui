//
//  TrackingModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/18/23.
//

import SwiftUI

/// Sets the tracking for the text in this view.
///
/// The amount of additional space, in points, that the view should add to each character cluster after layout. Value of 0 sets the tracking to the system default value.
///
/// ```html
/// <Text modifiers={tracking(0.5)}>Hello, world!</Text>
/// ```
///
/// ## Arguments
/// * ``tracking``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct TrackingModifier: ViewModifier, Decodable, Equatable, TextModifier {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let tracking: CGFloat
    
    func body(content: Content) -> some View {
        content.tracking(tracking)
    }
    
    func apply(to text: SwiftUI.Text) -> SwiftUI.Text {
        text.tracking(tracking)
    }
}
