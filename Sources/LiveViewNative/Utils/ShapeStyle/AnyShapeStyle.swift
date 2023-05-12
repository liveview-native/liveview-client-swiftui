//
//  AnyShapeStyle.swift
// LiveViewNative
//
//  Created by May Matyi on 3/1/23.
//

import SwiftUI
import LiveViewNativeCore

/// A color, gradient, or other style.
///
/// Create a shape style with a type, options, and modifiers.
///
/// ```elixir
/// {:color, :blue}
/// {:color, :red, [{:opacity, 0.5}]}
/// ```
///
/// ## Shape Styles
/// To create a shape style, use a tuple where the first element is an atom for the style type, and the second element is the style value.
///
/// ```elixir
/// {type, value}
/// ```
///
/// ### :color
/// See ``LiveViewNative/SwiftUI/Color/init(from:)`` for a list of possible color values.
///
/// ```elixir
/// {:color, :blue}
/// ```
/// 
/// ### :gradient
/// Creates a gradient from a single color.
/// See ``LiveViewNative/SwiftUI/Color/init(from:)`` for a list of possible color values.
/// 
/// ```elixir
/// {:gradient, :blue}
/// ```
///
/// ### :angular_gradient
/// See ``LiveViewNative/SwiftUI/AngularGradient`` for details on creating this style.
///
/// ```elixir
/// {:angular_gradient, [gradient: {:colors, [:pink, :blue]}, angle: {:degrees, 45}]}
/// ```
///
/// ### :elliptical_gradient
/// See ``LiveViewNative/SwiftUI/EllipticalGradient`` for details on creating this style.
///
/// ```elixir
/// {:elliptical_gradient, [gradient: {:colors, [:pink, :blue]}]}
/// ```
///
/// ### :linear_gradient
/// See ``LiveViewNative/SwiftUI/LinearGradient`` for details on creating this style.
///
/// ```elixir
/// {:linear_gradient, [gradient: {:colors, [:pink, :blue]}]}
/// ```
///
/// ### :radial_gradient
/// See ``LiveViewNative/SwiftUI/RadialGradient`` for details on creating this style.
///
/// ```elixir
/// {:radial_gradient, [gradient: {:colors, [:pink, :blue]}, start_radius: 0, end_radius: 100]}
/// ```
///
/// ### :hierarchical
/// See ``LiveViewNative/SwiftUI/HierarchicalShapeStyle`` for a list of possible values.
///
/// ```elixir
/// {:hierarchical, :tertiary}
/// ```
///
/// ### :material
/// See ``LiveViewNative/SwiftUI/Material`` for a list of possible values.
///
/// - Note: Materials are only available on iOS and macOS.
///
/// ```elixir
/// {:material, :regular}
/// ```
///
/// ### :image
/// See ``LiveViewNative/SwiftUI/ImagePaint`` for details on creating this style.
///
/// ```elixir
/// {:image, [image: {:system, "basketball.fill"}]}
/// ```
///
/// ### :selection
/// The selection color in the current context.
///
/// - Note: Only available on iOS and macOS
///
/// ```elixir
/// :selection
/// ```
///
/// ### :separator
/// The separator color in the current context.
///
/// - Note: Only available on macOS
///
/// ```elixir
/// :separator
/// ```
///
/// ### :tint
/// The tint color in the current context.
///
/// ```elixir
/// :tint
/// ```
///
/// ### :foreground
/// The foreground style in the current context.
///
/// ```elixir
/// :foreground
/// ```
///
/// ### :background
/// The background style in the current context.
///
/// ```elixir
/// :background
/// ```
///
/// ## Modifiers
/// A third element can be contained in the style tuple. This element is a list of modifiers.
///
/// ```elixir
/// {type, value, [modifier1, modifier2, ...]}
/// ```
///
/// Modifiers are created with tuples as well, with the first element being the name of the modifier and the second being any options.
///
/// ```elixir
/// {:opacity, 0.5}
/// ```
///
/// Modifiers with only one option can have the value directly as the second element.
/// If a modifier has multiply options, use a keyword list to set the values.
///
/// ### :opacity
/// Arguments:
/// * `opacity` (required) - The transparency of the style, from 0-1.
///
/// ```elixir
/// {:opacity, 0.5}
/// ```
///
/// ### :blend_mode
/// Arguments:
/// * `blend_mode` (required) - The ``LiveViewNative/SwiftUI/BlendMode`` to use for this style.
///
/// ```elixir
/// {:blend_mode, :multiply}
/// ```
///
/// ### :shadow
/// Arguments:
/// * `shadow_style` (required) - The ``LiveViewNative/SwiftUI/ShadowStyle`` to apply.
///
/// ```elixir
/// {:shadow, {:drop, [radius: 10]}}
/// ```
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension AnyShapeStyle: Decodable {
    public init(from attribute: LiveViewNativeCore.Attribute?) throws {
        guard let string = attribute?.value
        else { throw AttributeDecodingError.missingAttribute(Self.self) }
        self = try makeJSONDecoder().decode(Self.self, from: Data(string.utf8))
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        switch try container.decode(ConcreteStyle.self, forKey: .concreteStyle) {
        case .color:
            self = Self(try container.decode(SwiftUI.Color.self, forKey: .style))
        case .gradient:
            self = Self(try container.decode(SwiftUI.Color.self, forKey: .style).gradient)
        case .angularGradient:
            self = Self(try container.decode(AngularGradient.self, forKey: .style))
        case .ellipticalGradient:
            self = Self(try container.decode(EllipticalGradient.self, forKey: .style))
        case .linearGradient:
            self = Self(try container.decode(LinearGradient.self, forKey: .style))
        case .radialGradient:
            self = Self(try container.decode(RadialGradient.self, forKey: .style))
        case .hierarchical:
            self = Self(try container.decode(HierarchicalShapeStyle.self, forKey: .style))
        #if os(iOS) || os(macOS)
        case .material:
            self = Self(try container.decode(Material.self, forKey: .style))
        #endif
        case .image:
            self = Self(try container.decode(ImagePaint.self, forKey: .style))
        #if os(iOS) || os(macOS)
        case .selection:
            self = Self(SelectionShapeStyle())
        #endif
        #if os(macOS)
        case .separator:
            self = Self(SeparatorShapeStyle())
        #endif
        case .tint:
            self = Self(TintShapeStyle())
        case .foreground:
            self = Self(ForegroundStyle())
        case .background:
            self = Self(BackgroundStyle())
        }
        
        var modifiers = try container.nestedUnkeyedContainer(forKey: .modifiers)
        while !modifiers.isAtEnd {
            let modifier = try modifiers.nestedContainer(keyedBy: CodingKeys.Modifier.self)
            switch try modifier.decode(Modifier.self, forKey: .type) {
            case .opacity:
                self = Self(self.opacity(try modifier.decode(Double.self, forKey: .properties)))
            case .blendMode:
                self = Self(self.blendMode(try modifier.decode(BlendMode.self, forKey: .properties)))
            case .shadow:
                self = Self(self.shadow(try modifier.decode(ShadowStyle.self, forKey: .properties)))
            }
        }
    }
    enum CodingKeys: String, CodingKey {
        case concreteStyle
        case style
        case modifiers
        
        enum Modifier: CodingKey {
            case type
            case properties
        }
    }
    
    enum ConcreteStyle: String, Decodable {
        case color
        case gradient
        case angularGradient = "angular_gradient"
        case ellipticalGradient = "elliptical_gradient"
        case linearGradient = "linear_gradient"
        case radialGradient = "radial_gradient"
        case hierarchical
        #if os(iOS) || os(macOS)
        case material
        #endif
        case image
        #if os(iOS) || os(macOS)
        case selection
        #endif
        #if os(macOS)
        case separator
        #endif
        case tint
        case foreground
        case background
    }
    
    enum Modifier: String, Decodable {
        case opacity
        case blendMode = "blend_mode"
        case shadow
    }
}
