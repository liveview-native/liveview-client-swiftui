//
//  ColorInvertModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/20/23.
//

import SwiftUI

/// Inverts the colors in this view.
///
/// ```html
/// <Circle modifiers={foreground_style({:color, :red}) |> color_invert()} />
/// ```
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ColorInvertModifier: ViewModifier, Decodable {
    func body(content: Content) -> some View {
        content.colorInvert()
    }
}
