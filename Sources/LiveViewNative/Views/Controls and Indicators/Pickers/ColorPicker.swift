//
//  ColorPicker.swift
//
//
//  Created by Carson Katri on 2/14/23.
//

#if os(iOS) || os(macOS)
import SwiftUI

/// Presents a system color picker when tapped.
///
/// The color is stored as a map with the keys `r`, `g`, `b`, and optionally `a`.
///
/// ```html
/// <ColorPicker selection="favorite_color" supports-opacity>
///     Favorite Color
/// </ColorPicker>
/// ```
///
/// ```elixir
/// defmodule MyAppWeb.FavoriteColor do
///   native_binding :favorite_color, Map, %{ "r" => 1, "g" => 0, "b" => 1, "a" => 1 }
/// end
/// ```
///
/// > Selected colors are in the sRGB color space.
///
/// ## Attributes
/// ``supportsOpacity``
///
/// ## Bindings
/// * ``selection``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ColorPicker<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    /// The ``LiveBinding`` that stores the color value.
    ///
    /// The color is stored as a map with the keys `r`, `g`, `b`, and optionally `a`.
    ///
    /// ```elixir
    /// defmodule MyAppWeb.FavoriteColor do
    ///   native_binding :favorite_color, Map, %{ "r" => 1, "g" => 0, "b" => 1, "a" => 1 }
    /// end
    /// ```
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @LiveBinding(attribute: "selection") private var selection: CodableColor = .init(r: 0, g: 0, b: 0, a: 1)
    /// Enables the selection of transparent colors.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("supports-opacity") private var supportsOpacity: Bool
    
    struct CodableColor: Codable {
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
        SwiftUI.ColorPicker(
            selection: $selection.cgColor,
            supportsOpacity: supportsOpacity
        ) {
            context.buildChildren(of: element)
        }
    }
}
#endif
