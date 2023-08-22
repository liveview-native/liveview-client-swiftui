//
//  BaselineOffsetModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/13/2023.
//

import SwiftUI

/// Offsets ``Text`` vertically.
/// 
/// The offset will be applied to any child ``Text`` element.
/// 
/// ```html
/// <Text modifiers={baseline_offset(10)}
/// ```
/// 
/// ## Arguments
/// * ``offset``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct BaselineOffsetModifier: ViewModifier, Decodable, TextModifier {
    /// The vertical offset to apply.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let offset: CGFloat

    func body(content: Content) -> some View {
        content.baselineOffset(offset)
    }
    
    func apply(to text: SwiftUI.Text) -> SwiftUI.Text {
        text.baselineOffset(offset)
    }
}

