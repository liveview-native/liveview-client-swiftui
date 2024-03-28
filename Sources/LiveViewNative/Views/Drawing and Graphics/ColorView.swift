//
//  Color.swift
// LiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI
import LiveViewNativeCore

/// A rectangle with a particular fill color.
///
/// Color's appearance is equivalent to a <doc:Rectangle> with a `fill-color`.
///
/// Create a color with ``red``, ``green``, ``blue``, and ``opacity`` components.
///
/// ```html
/// <Color red={1} green={0} blue={0.5} />
/// ```
///
/// A color can also be created by its ``name``. Named colors can be declared in the app's asset catalog.
///
/// ```html
/// <Color name="MyAppColor" opacity={0.5} />
/// ```
///
/// The ``name`` attribute can also be used to create a system color or a CSS hex color.
///
/// ```html
/// <Color name="system-red" />
/// <Color name="#ff0000" />
/// ```
///
/// See ``LiveViewNative/SwiftUI/Color/init(fromNamedOrCSSHex:)`` for more details.
///
/// ## Attributes
/// * ``red``
/// * ``green``
/// * ``blue``
/// * ``name``
/// * ``opacity``
/// * ``colorSpace``
@_documentation(visibility: public)
struct ColorView: View {
    @ObservedElement private var element: ElementNode
    
    /// The alpha channel of the color, in the range `0` to `1`.
    @_documentation(visibility: public)
    @Attribute(.init(name: "opacity")) private var opacity: Double = 1
    
    /// A named color in the project's asset catalog, system color, or CSS hex color.
    ///
    /// ## See Also
    /// ### Color
    /// - ``LiveViewNative/SwiftUI/Color/init(fromNamedOrCSSHex:)``
    @_documentation(visibility: public)
    @Attribute(.init(name: "name")) private var name: String?
    
    /// The red channel of the color, in the range `0` to `1`.
    @_documentation(visibility: public)
    @Attribute(.init(name: "red")) private var red: Double?
    /// The green channel of the color, in the range `0` to `1`.
    @_documentation(visibility: public)
    @Attribute(.init(name: "green")) private var green: Double?
    /// The blue channel of the color, in the range `0` to `1`.
    @_documentation(visibility: public)
    @Attribute(.init(name: "blue")) private var blue: Double?
    
    /// The color space this color is in.
    ///
    /// Possible values:
    /// * `srgb`
    /// * `srgb-linear`
    /// * `display-p3`
    @_documentation(visibility: public)
    @Attribute(.init(name: "colorSpace")) private var colorSpace: SwiftUI.Color.RGBColorSpace = .sRGB
    
    var body: some View {
        if let named = name.flatMap(SwiftUI.Color.init(fromNamedOrCSSHex:)) {
            named.opacity(opacity)
        } else if let red,
                  let green,
                  let blue
        {
            SwiftUI.Color(
                colorSpace,
                red: red,
                green: green,
                blue: blue,
                opacity: opacity
            )
        }
    }
}

extension SwiftUI.Color.RGBColorSpace: AttributeDecodable, Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        
        if let rgbColorSpace = Self(string: string) {
            self = rgbColorSpace
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "expected valid value for RGBColorSpace"))
        }
    }

    public init(from attribute: LiveViewNativeCore.Attribute?, on element: ElementNode) throws {
        if let string = attribute?.value, let rgbColorSpace = Self(string: string) {
            self = rgbColorSpace
        } else {
            throw AttributeDecodingError.missingAttribute(Self.self)
        }
    }

    init?(string: String) {
        switch string {
        case "sRGB": self = .sRGB
        case "sRGBLinear": self = .sRGBLinear
        case "displayP3": self = .displayP3
        default: return nil
        }
    }
}

/// Helpers for creating a SwiftUI `Color`.
extension SwiftUI.Color: Decodable {
    /// Decodes a color from one of several possible formats.
    ///
    /// The encoded value may be a dictionary containing an RGB color space (one of `srgb`, `srgb-linear`, or `display-p3`) in the `rgb_color_space_key`.
    /// The dictionary must also contain either:
    /// - The `red`, `green`, and `blue` keys, each with a double value between 0 and 1.
    /// - The `white` key with a double value between 0 and 1.
    /// 
    /// The dictionary may also contain an `opacity` key with a double between 0 and 1.
    ///
    /// The encoded value may also be a string, which is decoded using ``init(fromNamedOrCSSHex:)``.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let rgbColorSpace = try container.decodeIfPresent(SwiftUI.Color.RGBColorSpace?.self, forKey: .rgbColorSpace) {
            var opacity: Double = 1

            if let number = try container.decodeIfPresent(Double?.self, forKey: .opacity) {
                opacity = number!
            }
            if let red = try container.decodeIfPresent(Double?.self, forKey: .red), let green = try container.decodeIfPresent(Double?.self, forKey: .green), let blue = try container.decodeIfPresent(Double?.self, forKey: .blue) {
                self = SwiftUI.Color(rgbColorSpace!, red: red!, green: green!, blue: blue!)
            } else if let white = try container.decodeIfPresent(Double?.self, forKey: .white) {
                self = SwiftUI.Color(rgbColorSpace!, white: white!, opacity: opacity)
            } else {
                throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "expected valid value for Color"))
            }
        } else if let string = try container.decodeIfPresent(String?.self, forKey: .string) {
            self = SwiftUI.Color(fromNamedOrCSSHex: string)!
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "expected valid value for Color"))
        }
    }
    
    /// Constructs a Color from a CSS-style hex color (e.g., `#f2cb49`).
    public init?(fromCSSHex string: String?) {
        guard let string = string else {
            return nil
        }
        
        if string.count == 7 && string.first == "#",
           let r = Int(string[string.index(string.startIndex, offsetBy: 1)..<string.index(string.startIndex, offsetBy: 3)], radix: 16),
           let g = Int(string[string.index(string.startIndex, offsetBy: 3)..<string.index(string.startIndex, offsetBy: 5)], radix: 16),
           let b = Int(string[string.index(string.startIndex, offsetBy: 5)..<string.index(string.startIndex, offsetBy: 7)], radix: 16)
        {
            self.init(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255)
        } else {
            return nil
        }
    }
    
    /// Constructs a Color from a named color or a CSS hex color (see ``init(fromCSSHex:)``).
    ///
    /// The named system colors supported are:
    /// - `system-black`
    /// - `system-blue`
    /// - `system-brown`
    /// - `system-clear`
    /// - `system-cyan`
    /// - `system-gray`
    /// - `system-green`
    /// - `system-indigo`
    /// - `system-mint`
    /// - `system-orange`
    /// - `system-pink`
    /// - `system-purple`
    /// - `system-red`
    /// - `system-teal`
    /// - `system-white`
    /// - `system-yellow`
    /// - `system-accent`
    /// - `system-primary`
    /// - `system-secondary`
    ///
    /// A color that is neither a system name nor a hex color is interpreted as a named color defined in the application's asset catalog.
    /// See the SwiftUI documentation for more information.
    public init?(fromNamedOrCSSHex string: String?) {
        switch string {
        case nil:
            return nil
        case "system-black":
            self = .black
        case "system-blue":
            self = .blue
        case "system-brown":
            self = .brown
        case "system-clear":
            self = .clear
        case "system-cyan":
            self = .cyan
        case "system-gray":
            self = .gray
        case "system-green":
            self = .green
        case "system-indigo":
            self = .indigo
        case "system-mint":
            self = .mint
        case "system-orange":
            self = .orange
        case "system-pink":
            self = .pink
        case "system-purple":
            self = .purple
        case "system-red":
            self = .red
        case "system-teal":
            self = .teal
        case "system-white":
            self = .white
        case "system-yellow":
            self = .yellow
        case "system-accent":
            self = .accentColor
        case "system-primary":
            self = .primary
        case "system-secondary":
            self = .secondary
        case let string?:
            if let hexColor = Self(fromCSSHex: string) {
                self = hexColor
            } else {
                self = .init(string)
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case blue
        case brightness
        case green
        case hue
        case opacity
        case red
        case rgbColorSpace
        case saturation
        case string
        case white
    }
}
