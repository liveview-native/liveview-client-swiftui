//
//  AnyShapeStyle.swift
// LiveViewNative
//
//  Created by May Matyi on 3/1/23.
//

import SwiftUI

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
/// ### :angular_gradient
/// See ``LiveViewNative/SwiftUI/AngularGradient`` for details on creating this style.
///
/// ```elixir
/// {:angular_gradient, [gradient: {:stops, [{:pink, 0.8}, {:blue, 0.9}]}, angle: {:degrees, 45}]}
/// ```
///
/// ### :linear_gradient
/// See ``LiveViewNative/SwiftUI/LinearGradient`` for details on creating this style.
///
/// ```elixir
/// {:linear_gradient, [gradient: {:stops, [{:pink, 0.8}, {:blue, 0.9}]}]}
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
/// ```elixir
/// {:material, :regular}
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
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension AnyShapeStyle: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        switch try container.decode(ConcreteStyle.self, forKey: .concreteStyle) {
        case .color:
            self = Self(try container.decode(SwiftUI.Color.self, forKey: .style))
        case .angularGradient:
            self = Self(try container.decode(AngularGradient.self, forKey: .style))
        case .ellipticalGradient:
            self = Self(try container.decode(EllipticalGradient.self, forKey: .style))
        case .linearGradient:
            self = Self(try container.decode(LinearGradient.self, forKey: .style))
        case .hierarchical:
            self = Self(try container.decode(HierarchicalShapeStyle.self, forKey: .style))
        case .material:
            self = Self(try container.decode(Material.self, forKey: .style))
        }
        
        var modifiers = try container.nestedUnkeyedContainer(forKey: .modifiers)
        while !modifiers.isAtEnd {
            let modifier = try modifiers.nestedContainer(keyedBy: CodingKeys.Modifier.self)
            switch try modifier.decode(Modifier.self, forKey: .type) {
            case .opacity:
                self = Self(self.opacity(try modifier.decode(Double.self, forKey: .properties)))
            }
        }
    }
    enum CodingKeys: String, CodingKey {
        case concreteStyle = "concrete_style"
        case style
        case modifiers
        
        enum Modifier: CodingKey {
            case type
            case properties
        }
    }
    
    enum ConcreteStyle: String, Decodable {
        case color
        case angularGradient = "angular_gradient"
        case ellipticalGradient = "elliptical_gradient"
        case linearGradient = "linear_gradient"
        case hierarchical
        case material
    }
    
    enum Modifier: String, Decodable {
        case opacity
    }
}
