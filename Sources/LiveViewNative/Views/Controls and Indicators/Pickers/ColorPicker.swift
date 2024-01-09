//
//  ColorPicker.swift
//
//
//  Created by Carson Katri on 2/14/23.
//

import SwiftUI
import LiveViewNativeCore

/// Presents a system color picker when tapped.
///
/// The color is stored as a map with the keys `r`, `g`, `b`, and optionally `a`.
///
/// ```html
/// <ColorPicker selection={@favorite_color} phx-change="color-changed" supports-opacity>
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
struct ColorPicker<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    /// The currently selected color value.
    ///
    /// The color is stored as a map with the keys `r`, `g`, `b`, and optionally `a`.
    @_documentation(visibility: public)
    @ChangeTracked(attribute: "selection") private var selection = CodableColor(r: 0, g: 0, b: 0, a: 1)
    
    /// Enables the selection of transparent colors.
    @_documentation(visibility: public)
    @Attribute("supports-opacity") private var supportsOpacity: Bool
    
    struct CodableColor: AttributeDecodable, Codable, Equatable {
        init(from attribute: LiveViewNativeCore.Attribute?) throws {
            guard let value = attribute?.value
            else { throw AttributeDecodingError.missingAttribute(Self.self) }
            self = try JSONDecoder().decode(Self.self, from: Data(value.utf8))
        }
        
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
            context.buildChildren(of: element)
        }
        #endif
    }
}
