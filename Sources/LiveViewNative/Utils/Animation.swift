//
//  Animation.swift
//  
//
//  Created by Carson Katri on 4/3/23.
//

import SwiftUI

/// Configuration for the ``AnimationModifier`` modifier.
///
/// In their simplest form, animations can be created with an atom. More complex animations can have properties and modifiers.
///
/// ```elixir
/// :ease_in_out
/// {:ease_out, [duration: 3]} # a 3 second animation
/// {:spring, [response: 0.55, damping_fraction: 0.825, blend_duration: 0]} # a customized spring
/// {:linear, [], [{:speed, 3}]} # a sped-up animation.
/// ```
///
/// ## Animations
/// Animations with no required arguments can be represented with an atom.
///
/// ```elixir
/// :interactive_spring
/// ```
///
/// To pass arguments, use a tuple with a keyword list as the second element.
///
/// ```elixir
/// {:interactive_spring, [response: 0.3, blend_duration: 0.5]}
/// ```
///
/// ### :default
/// See [`SwiftUI.Animation.default`](https://developer.apple.com/documentation/swiftui/animation/default) for more details on this animation.
///
/// ### :ease_in
/// Arguments:
/// * `duration` - The number of seconds this animation lasts.
///
/// See [`SwiftUI.Animation.easeIn`](https://developer.apple.com/documentation/swiftui/animation/easeIn(duration:)) for more details on this animation.
///
/// ### :ease_out
/// Arguments:
/// * `duration` - The number of seconds this animation lasts.
///
/// See [`SwiftUI.Animation.easeOut`](https://developer.apple.com/documentation/swiftui/animation/easeOut(duration:)) for more details on this animation.
///
/// ### :ease_in_out
/// Arguments:
/// * `duration` - The number of seconds this animation lasts.
///
/// See [`SwiftUI.Animation.easeInOut`](https://developer.apple.com/documentation/swiftui/animation/easeInOut(duration:)) for more details on this animation.
///
/// ### :linear
/// Arguments:
/// * `duration` - The number of seconds this animation lasts.
///
/// See [`SwiftUI.Animation.linear`](https://developer.apple.com/documentation/swiftui/animation/linear(duration:)) for more details on this animation.
///
/// #### :spring
/// Arguments:
/// * `response`
/// * `damping_fraction`
/// * `blend_duration`
///
/// See [`SwiftUI.Animation.spring`](https://developer.apple.com/documentation/swiftui/animation/spring(response:dampingfraction:blendduration:)) for more details on this animation.
///
/// #### :interactive_spring
/// Arguments:
/// * `response`
/// * `damping_fraction`
/// * `blend_duration`
///
/// See [`SwiftUI.Animation.interactiveSpring`](https://developer.apple.com/documentation/swiftui/animation/interactivespring(response:dampingfraction:blendduration:)) for more details on this animation.
///
/// #### :interpolating_spring
/// Arguments:
/// * `mass`
/// * `stiffness` (required)
/// * `damping` (required)
/// * `initial_velocity`
///
/// See [`SwiftUI.Animation.interpolatingSpring`](https://developer.apple.com/documentation/swiftui/animation/interpolatingspring(mass:stiffness:damping:initialvelocity:)) for more details on this animation.
///
/// ### Animation Modifiers
/// Modifiers can be applied to any animation as the third tuple element.
///
/// ```elixir
/// {:interactive_spring, [], [ <animation modifiers> ]}
/// ```
///
/// A modifier is represented as a tuple where the first element is an atom with the name of the modifier, and the second is a keyword list or argument if the modifier only takes one.
///
/// ```elixir
/// {:interactive_spring, [], [{:speed, 0.25}]}
/// ```
///
/// ### :delay
/// Arguments:
/// * `delay` (required)
///
/// ```elixir
/// {:delay, 3}
/// ```
///
/// See [`SwiftUI.Animation.delay`](https://developer.apple.com/documentation/swiftui/animation/delay(_:)) for more details on this animation.
///
/// ### :repeat_count
/// Arguments:
/// * `repeat_count` (required)
/// * `autoreverses`
///
/// ```elixir
/// {:repeat_count, [repeat_count: 3, autoreverses: false]}
/// ```
///
/// See [`SwiftUI.Animation.repeatCount`](https://developer.apple.com/documentation/swiftui/animation/repeatcount(_:autoreverses:)) for more details on this animation.
///
/// ### :repeat_forever
/// Arguments:
/// * `autoreverses`
///
/// ```elixir
/// {:repeat_count, [autoreverses: false]}
/// ```
///
/// See [`SwiftUI.Animation.repeatForever`](https://developer.apple.com/documentation/swiftui/animation/repeatforever(autoreverses:)) for more details on this animation.
///
/// ### :speed
/// Arguments:
/// * `speed` (required)
///
/// ```elixir
/// {:speed, 0.25}
/// ```
///
/// See [`SwiftUI.Animation.speed`](https://developer.apple.com/documentation/swiftui/animation/speed(_:)) for more details on this animation.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension Animation: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var base: Self
        
        switch try container.decode(AnimationType.self, forKey: .type) {
        case .default:
            base = .default
        case .easeIn:
            let properties = try container.nestedContainer(keyedBy: AnimationType.EasingProperties.self, forKey: .properties)
            if let duration = try properties.decodeIfPresent(Double.self, forKey: .duration) {
                base = .easeIn(duration: duration)
            } else {
                base = .easeIn
            }
        case .easeOut:
            let properties = try container.nestedContainer(keyedBy: AnimationType.EasingProperties.self, forKey: .properties)
            if let duration = try properties.decodeIfPresent(Double.self, forKey: .duration) {
                base = .easeOut(duration: duration)
            } else {
                base = .easeOut
            }
        case .easeInOut:
            let properties = try container.nestedContainer(keyedBy: AnimationType.EasingProperties.self, forKey: .properties)
            if let duration = try properties.decodeIfPresent(Double.self, forKey: .duration) {
                base = .easeInOut(duration: duration)
            } else {
                base = .easeInOut
            }
        case .linear:
            let properties = try container.nestedContainer(keyedBy: AnimationType.EasingProperties.self, forKey: .properties)
            if let duration = try properties.decodeIfPresent(Double.self, forKey: .duration) {
                base = .linear(duration: duration)
            } else {
                base = .linear
            }
        case .spring:
            let properties = try container.nestedContainer(keyedBy: AnimationType.SpringProperties.self, forKey: .properties)
            base = .spring(
                response: try properties.decodeIfPresent(Double.self, forKey: .response) ?? 0.55,
                dampingFraction: try properties.decodeIfPresent(Double.self, forKey: .dampingFraction) ?? 0.825,
                blendDuration: try properties.decodeIfPresent(Double.self, forKey: .blendDuration) ?? 0
            )
        case .interactiveSpring:
            let properties = try container.nestedContainer(keyedBy: AnimationType.SpringProperties.self, forKey: .properties)
            base = .interactiveSpring(
                response: try properties.decodeIfPresent(Double.self, forKey: .response) ?? 0.15,
                dampingFraction: try properties.decodeIfPresent(Double.self, forKey: .dampingFraction) ?? 0.86,
                blendDuration: try properties.decodeIfPresent(Double.self, forKey: .blendDuration) ?? 0.25
            )
        case .interpolatingSpring:
            let properties = try container.nestedContainer(keyedBy: AnimationType.InterpolatingSpringProperties.self, forKey: .properties)
            base = .interpolatingSpring(
                mass: try properties.decodeIfPresent(Double.self, forKey: .mass) ?? 1,
                stiffness: try properties.decode(Double.self, forKey: .stiffness),
                damping: try properties.decode(Double.self, forKey: .damping),
                initialVelocity: try properties.decodeIfPresent(Double.self, forKey: .initialVelocity) ?? 0
            )
        case .timingCurve:
            let properties = try container.nestedContainer(keyedBy: AnimationType.TimingCurveProperties.self, forKey: .properties)
            base = .timingCurve(
                try properties.decode(Double.self, forKey: .c0x),
                try properties.decode(Double.self, forKey: .c0y),
                try properties.decode(Double.self, forKey: .c1x),
                try properties.decode(Double.self, forKey: .c1y),
                duration: try properties.decodeIfPresent(Double.self, forKey: .duration) ?? 0.35
            )
        }
        
        var modifiers = try container.nestedUnkeyedContainer(forKey: .modifiers)
        while let modifier = try? modifiers.nestedContainer(keyedBy: AnimationModifierCodingKeys.self) {
            switch try modifier.decode(AnimationModifier.self, forKey: .type) {
            case .delay:
                base = base.delay(try modifier.decode(Double.self, forKey: .properties))
            case .repeatCount:
                let properties = try modifier.nestedContainer(keyedBy: AnimationModifier.RepeatCountKeys.self, forKey: .properties)
                base = base.repeatCount(
                    try properties.decode(Int.self, forKey: .repeatCount),
                    autoreverses: try properties.decodeIfPresent(Bool.self, forKey: .autoreverses) ?? true
                )
            case .repeatForever:
                let properties = try modifier.nestedContainer(keyedBy: AnimationModifier.RepeatForeverKeys.self, forKey: .properties)
                base = base.repeatForever(autoreverses: try properties.decodeIfPresent(Bool.self, forKey: .autoreverses) ?? true)
            case .speed:
                base = base.speed(try modifier.decode(Double.self, forKey: .properties))
            }
        }
        self = base
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case properties
        case modifiers
    }
    
    enum AnimationType: String, Decodable {
        case `default`
        case easeOut = "ease_out"
        case easeInOut = "ease_in_out"
        case easeIn = "ease_in"
        case linear
        case spring
        case interactiveSpring = "interactive_spring"
        case interpolatingSpring = "interpolating_spring"
        case timingCurve = "timing_curve"
        
        enum EasingProperties: String, CodingKey {
            case duration
        }
        
        enum SpringProperties: String, CodingKey {
            case response
            case dampingFraction = "damping_fraction"
            case blendDuration = "blend_duration"
        }
        
        enum InterpolatingSpringProperties: String, CodingKey {
            case mass
            case stiffness
            case damping
            case initialVelocity = "initial_velocity"
        }
        
        enum TimingCurveProperties: String, CodingKey {
            case c0x
            case c0y
            case c1x
            case c1y
            case duration
        }
    }
    
    enum AnimationModifierCodingKeys: String, CodingKey {
        case type
        case properties
    }
    
    enum AnimationModifier: String, Decodable {
        case delay
        case repeatCount = "repeat_count"
        case repeatForever = "repeat_forever"
        case speed = "speed"
        
        enum RepeatCountKeys: String, CodingKey {
            case repeatCount = "repeat_count"
            case autoreverses
        }
        
        enum RepeatForeverKeys: String, CodingKey {
            case autoreverses
        }
    }
}
