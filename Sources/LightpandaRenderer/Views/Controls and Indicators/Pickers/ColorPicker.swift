//
//  ColorPicker.swift
//
//
//  Created by Carson Katri on 2/14/23.
//

import SwiftUI
import LightpandaClient

/// Presents a system color picker when tapped.
///
/// The color is stored as a map with the keys `r`, `g`, `b`, and optionally `a`.
///
/// ```html
/// <ColorPicker selection={@favorite_color} phx-change="color-changed" supportsOpacity>
///     Favorite Color
/// </ColorPicker>
/// ```
///
/// > Selected colors are in the sRGB color space.
///
/// ## Attributes
/// ``supportsOpacity``
///
/// ## Bindings
/// * ``selection``
@_documentation(visibility: public)
@available(iOS 16.0, macOS 13.0, *)
struct ColorPicker<Library: ElementLibrary>: View {
    let node: Node
    
    /// The currently selected color value.
    ///
    /// The color is stored as a map with the keys `r`, `g`, `b`, and optionally `a`.
    @_documentation(visibility: public)
    @ChangeTracked(attribute: "selection") private var selection = CodableColor(r: 0, g: 0, b: 0, a: 1)
    
    /// Enables the selection of transparent colors.
    @_documentation(visibility: public)
    private var supportsOpacity: Bool {
        node.attributeBoolean(for: "supportsOpacity")
    }
    
    struct CodableColor: Codable, Equatable {
        init(
            r: CGFloat,
            g: CGFloat,
            b: CGFloat,
            a: CGFloat?
        ) {
            self.r = r
            self.g = g
            self.b = b
            self.a = a
        }
        
        var r: CGFloat
        var g: CGFloat
        var b: CGFloat
        var a: CGFloat?
        
        var cgColor: CGColor {
            get {
                .init(srgbRed: r, green: g, blue: b, alpha: a ?? 1)
            }
            set {
                guard let components = newValue.components else { return }
                r = components[0]
                g = components[1]
                b = components[2]
                if newValue.numberOfComponents >= 4 {
                    a = components[3]
                } else {
                    a = nil
                }
            }
        }
    }
    
    public var body: some View {
        #if os(iOS) || os(macOS)
        SwiftUI.ColorPicker(
            selection: $selection.cgColor,
            supportsOpacity: supportsOpacity
        ) {
            node.children(library: Library.self)
        }
        #endif
    }
}
