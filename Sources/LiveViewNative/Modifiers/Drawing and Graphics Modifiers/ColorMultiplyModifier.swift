//
//  ColorMultiplyModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/21/23.
//

import SwiftUI

/// Adds a color multiplication effect to this view.
///
/// ```html
/// <Label modifiers={foreground_style({:color, :mint}) |> color_multiply(:blue)}>Color Text</Label>
/// ```
///
/// ## Arguments
/// * ``color``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ColorMultiplyModifier: ViewModifier, Decodable {
    /// The color to bias this view toward.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let color: SwiftUI.Color
    
    func body(content: Content) -> some View {
        content.colorMultiply(color)
    }
}
