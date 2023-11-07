//
//  Animation.swift
//  
//
//  Created by Carson Katri on 4/3/23.
//

import SwiftUI
import LiveViewNativeStylesheet

extension Animation: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ChainedMemberExpression {
            OneOf {
                "default".utf8.map({ Base.default })
                Base.EaseIn.parser(in: context).map(Base.easeIn)
                Base.EaseOut.parser(in: context).map(Base.easeOut)
                Base.EaseInOut.parser(in: context).map(Base.easeInOut)
                Base.Linear.parser(in: context).map(Base.linear)
                "spring".utf8.map({ Base.spring })
                "interactiveSpring".utf8.map({ Base.interactiveSpring })
                "interpolatingSpring".utf8.map({ Base.interpolatingSpring })
//                "timingCurve".utf8.map({ Base.timingCurve })
//                "keyframe".utf8.map({ Base.keyframe })
            }
        } member: {
            OneOf {
                Modifier.Delay.parser(in: context).map(Modifier.delay)
            }
        }
        .map { (base: Base, members: [Modifier]) in
            var animation: Self = switch base {
            case .default:
                Self.default
            case let .easeIn(base):
                if let duration = base.duration {
                    Self.easeIn(duration: duration)
                } else {
                    Self.easeIn
                }
            case let .easeOut(base):
                if let duration = base.duration {
                    Self.easeOut(duration: duration)
                } else {
                    Self.easeOut
                }
            case let .easeInOut(base):
                if let duration = base.duration {
                    Self.easeInOut(duration: duration)
                } else {
                    Self.easeInOut
                }
            case let .linear(base):
                if let duration = base.duration {
                    Self.linear(duration: duration)
                } else {
                    Self.linear
                }
            case .spring:
                Self.spring
            case .interactiveSpring:
                Self.interactiveSpring
            case .interpolatingSpring:
                Self.interpolatingSpring
//            case .timingCurve:
//                Self.timingCurve
//            case .keyframe:
//                Self.keyframe
            }
            for modifier in members {
                switch modifier {
                case let .delay(modifier):
                    animation = animation.delay(modifier.delay)
                case let .repeatCount(modifier):
                    animation = animation.repeatCount(modifier.repeatCount, autoreverses: modifier.autoreverses)
                case let .repeatForever(modifier):
                    animation = animation.repeatForever(autoreverses: modifier.autoreverses)
                case let .speed(modifier):
                    animation = animation.speed(modifier.speed)
                }
            }
            return animation
        }
    }
    
    enum Base {
        case `default`
        case easeIn(EaseIn)
        case easeOut(EaseOut)
        case easeInOut(EaseInOut)
        case linear(Linear)
        case spring
        case interactiveSpring
        case interpolatingSpring
//        case timingCurve
//        case keyframe
        // ...
        
        @ParseableExpression
        struct EaseIn {
            static let name = "easeIn"
            
            let duration: Double?
            
            init(duration: Double?) {
                self.duration = duration
            }
        }
        
        @ParseableExpression
        struct EaseOut {
            static let name = "easeOut"
            
            let duration: Double?
            
            init(duration: Double?) {
                self.duration = duration
            }
        }
        
        @ParseableExpression
        struct EaseInOut {
            static let name = "easeInOut"
            
            let duration: Double?
            
            init(duration: Double?) {
                self.duration = duration
            }
        }
        
        @ParseableExpression
        struct Linear {
            static let name = "linear"
            
            let duration: Double?
            
            init(duration: Double?) {
                self.duration = duration
            }
        }
    }
    
    enum Modifier {
        case delay(Delay)
        case repeatCount(RepeatCount)
        case repeatForever(RepeatForever)
        case speed(Speed)
        
        @ParseableExpression
        struct Delay {
            static let name = "delay"
            
            let delay: Double
            
            init(_ delay: Double) {
                self.delay = delay
            }
        }
        
        @ParseableExpression
        struct Speed {
            static let name = "speed"
            
            let speed: Double
            
            init(_ speed: Double) {
                self.speed = speed
            }
        }
        
        @ParseableExpression
        struct RepeatCount {
            static let name = "repeatCount"
            
            let repeatCount: Int
            let autoreverses: Bool
            
            init(_ repeatCount: Int, autoreverses: Bool?) {
                self.repeatCount = repeatCount
                self.autoreverses = autoreverses ?? true
            }
        }
        
        @ParseableExpression
        struct RepeatForever {
            static let name = "repeatForever"
            
            let autoreverses: Bool
            
            init(autoreverses: Bool?) {
                self.autoreverses = autoreverses ?? true
            }
        }
    }
}

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
/// #### :keyframe
/// Pass a ``KeyframeAnimation`` as the second element in the tuple.
/// ```elixir
/// {:keyframe, [initial_value: 1.0, keyframes: [
///   {:linear, 1.0, [duration: 0.36]},
///   {:spring, 1.5, [duration: 0.8, spring: :bouncy]},
///   {:spring, 1.0, [spring: :bouncy]}
/// ]]}
/// ```
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
        case .keyframe:
            if #available(iOS 17, macOS 14, tvOS 17, watchOS 10, *) {
                #if swift(>=5.9)
                base = .init(try container.decode(KeyframeAnimation.self, forKey: .properties))
                #else
                base = .default
                #endif
            } else {
                base = .default
            }
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
        case keyframe
        
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

#if swift(>=5.9)
/// An animation that plays a list of keyframes.
///
/// ```elixir
/// [
///   initial_value: 0.0,
///   keyframes: [
///     {:linear, 1.0, [duration: 0.36]},
///     {:spring, 1.5, [duration: 0.8, spring: :bouncy]},
///     {:spring, 1.0, [spring: :bouncy]}
///   ]
/// ]
/// ```
///
/// See ``LiveViewNative/KeyframeAnimation/Keyframe`` for more details.
@_documentation(visibility: public)
@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
struct KeyframeAnimation: CustomAnimation, Decodable {
    let initialValue: Double
    let keyframes: [Keyframe]
    
    func animate<V>(value: V, time: TimeInterval, context: inout AnimationContext<V>) -> V? where V : VectorArithmetic {
        let timeline = KeyframeTimeline(initialValue: initialValue) {
            KeyframeTrack(\Double.self) {
                KeyframeTrackContentBuilder.buildArray(keyframes.map(\.value))
            }
        }
        guard time <= timeline.duration else { return nil }
        return value.scaled(by: timeline.value(time: time))
    }
    
    /// A single keyframe in an animation.
    ///
    /// There are several types of keyframe.
    ///
    /// ### :move
    /// Moves to a particular value without interpolating.
    ///
    /// ```elixir
    /// {:move, 1.0}
    /// ```
    ///
    /// ### :linear
    /// Linear interpolation to a value.
    /// See ``LiveViewNative/SwiftUI/UnitCurve`` for a list of possible values.
    ///
    /// ```elixir
    /// {:linear, 1.0, [duration: 1.0]}
    /// {:linear, 1.0, [duration: 0.5, timing_curve: :ease_in_out]}
    /// ```
    ///
    /// ### :cubic
    /// A cubic bezier curve interpolation.
    ///
    /// ```elixir
    /// {:cubic, [duration: 0.5]}
    /// {:cubic, [duration: 1.0, start_velocity: 1.0, end_velocity: 0.1]}
    /// ```
    ///
    /// ### :spring
    /// A spring function interpolation.
    /// See ``LiveViewNative/SwiftUI/Spring`` for more details.
    ///
    /// ```elixir
    /// {:spring, [spring: :bouncy]}
    /// {:spring, [duration: 0.5, spring: :snappy, start_velocity: 1.0]}
    /// ```
    @_documentation(visibility: public)
    enum Keyframe: Hashable, Decodable {
        case move(_ value: Double)
        case linear(_ value: Double, duration: Double, timingCurve: UnitCurve = .linear)
        case cubic(_ value: Double, duration: Double, startVelocity: Double?, endVelocity: Double?)
        case spring(_ value: Double, duration: Double?, spring: Spring, startVelocity: Double?)
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let value = try container.decode(Double.self, forKey: .value)
            switch try container.decode(KeyframeType.self, forKey: .type) {
            case .move:
                self = .move(value)
            case .linear:
                let properties = try container.nestedContainer(keyedBy: CodingKeys.LinearKeys.self, forKey: .properties)
                self = .linear(
                    value,
                    duration: try properties.decode(Double.self, forKey: .duration),
                    timingCurve: try properties.decodeIfPresent(UnitCurve.self, forKey: .timingCurve) ?? .linear
                )
            case .cubic:
                let properties = try container.nestedContainer(keyedBy: CodingKeys.CubicKeys.self, forKey: .properties)
                self = .cubic(
                    value,
                    duration: try properties.decode(Double.self, forKey: .duration),
                    startVelocity: try properties.decodeIfPresent(Double.self, forKey: .startVelocity),
                    endVelocity: try properties.decodeIfPresent(Double.self, forKey: .endVelocity)
                )
            case .spring:
                let properties = try container.nestedContainer(keyedBy: CodingKeys.SpringKeys.self, forKey: .properties)
                self = .spring(
                    value,
                    duration: try properties.decodeIfPresent(Double.self, forKey: .duration),
                    spring: try properties.decode(Spring.self, forKey: .spring),
                    startVelocity: try properties.decodeIfPresent(Double.self, forKey: .startVelocity)
                )
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case type
            case value
            case properties
            
            enum LinearKeys: String, CodingKey {
                case value
                case duration
                case timingCurve
            }
            
            enum CubicKeys: String, CodingKey {
                case value
                case duration
                case startVelocity
                case endVelocity
            }
            
            enum SpringKeys: String, CodingKey {
                case value
                case duration
                case spring
                case startVelocity
            }
        }
        
        enum KeyframeType: String, Decodable {
            case move
            case linear
            case cubic
            case spring
        }
        
        @KeyframeTrackContentBuilder<Double>
        var value: some KeyframeTrackContent<Double> {
            switch self {
            case let .move(value):
                MoveKeyframe(value)
            case let .linear(value, duration, timingCurve):
                LinearKeyframe(value, duration: duration, timingCurve: timingCurve)
            case let .cubic(value, duration, startVelocity, endVelocity):
                CubicKeyframe(value, duration: duration, startVelocity: startVelocity, endVelocity: endVelocity)
            case let .spring(value, duration, spring, startVelocity):
                SpringKeyframe(value, duration: duration, spring: spring, startVelocity: startVelocity)
            }
        }
    }
}

/// A timing curve.
///
/// Possible values:
/// * `ease_in_out`
/// * `ease_in`
/// * `ease_out`
/// * `circular_ease_in`
/// * `circular_ease_out`
/// * `circular_ease_in_out`
/// * `linear`
/// * `[start, end]` - where `start` and `end` are ``LiveViewNative/SwiftUI/UnitPoint`` values.
@_documentation(visibility: public)
@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
extension UnitCurve: Decodable {
    public init(from decoder: Decoder) throws {
        if let container = try? decoder.singleValueContainer() {
            switch try container.decode(String.self) {
            case "ease_in_out": self = .easeInOut
            case "ease_in": self = .easeIn
            case "ease_out": self = .easeOut
            case "circular_ease_in": self = .circularEaseIn
            case "circular_ease_out": self = .circularEaseOut
            case "circular_ease_in_out": self = .circularEaseInOut
            case "linear": self = .linear
            case let `default`: throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "Unknown unit curve '\(`default`)'"))
            }
        } else {
            var container = try decoder.unkeyedContainer()
            let start = try container.decode(UnitPoint.self)
            let end = try container.decode(UnitPoint.self)
            self = .bezier(startControlPoint: start, endControlPoint: end)
        }
    }
}

/// A configurable spring.
///
/// There are many ways to create a spring.
///
/// The simplest method is to use a preset spring with an atom name.
///
/// ```elixir
/// :smooth
/// :snappy
/// :bouncy
/// ```
///
/// It can be further configured with the `duration` and `extra_bounce` properties.
///
/// ```elixir
/// {:smooth, [duration: 1.0, extra_bounce: 1.0]}
/// {:bouncy, [extra_bounce: 0.2]}
/// ```
///
/// Custom springs can also be created with a variety of properties.
///
/// ### duration, bounce
/// ```elixir
/// [duration: 1.0]
/// [bounce: 0.3]
/// [duration: 1.0, bounce: 0.3]
/// ```
///
/// ### response, damping_ratio
/// ```elixir
/// [response: 1.0, damping_ratio: 0.5]
/// ```
///
/// ### settling_duration, damping_ratio, epsilon
/// ```elixir
/// [settling_duration: 0.3, damping_ratio: 0.5]
/// [settling_duration: 0.3, damping_ratio: 0.5, epsilon: 0.01]
/// ```
///
/// ### mass, stiffness, damping, allow_over_damping
/// ```elixir
/// [stiffness: 0.5, damping: 0.3]
/// [mass: 0.75, stiffness: 0.5, damping: 0.3, allow_over_damping: true]
/// ```
@_documentation(visibility: public)
@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
extension Spring: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if container.allKeys.contains(.type) {
            switch try container.decode(SpringType.self, forKey: .type) {
            case .smooth:
                self = .smooth(
                    duration: try container.decodeIfPresent(Double.self, forKey: .duration) ?? 0.5,
                    extraBounce: try container.decodeIfPresent(Double.self, forKey: .extraBounce) ?? 0
                )
            case .snappy:
                self = .snappy(
                    duration: try container.decodeIfPresent(Double.self, forKey: .duration) ?? 0.5,
                    extraBounce: try container.decodeIfPresent(Double.self, forKey: .extraBounce) ?? 0
                )
            case .bouncy:
                self = .bouncy(
                    duration: try container.decodeIfPresent(Double.self, forKey: .duration) ?? 0.5,
                    extraBounce: try container.decodeIfPresent(Double.self, forKey: .extraBounce) ?? 0
                )
            }
        } else if container.allKeys.isEmpty {
            self.init()
        } else if container.allKeys.contains(.duration) || container.allKeys.contains(.bounce) {
            self.init(
                duration: try container.decodeIfPresent(Double.self, forKey: .duration) ?? 0.5,
                bounce: try container.decodeIfPresent(Double.self, forKey: .bounce) ?? 0
            )
        } else if container.allKeys.contains([.response, .dampingRatio]) {
            self.init(
                response: try container.decode(Double.self, forKey: .response),
                dampingRatio: try container.decode(Double.self, forKey: .dampingRatio)
            )
        } else if container.allKeys.contains([.settlingDuration, .dampingRatio]) {
            self.init(
                settlingDuration: try container.decode(Double.self, forKey: .settlingDuration),
                dampingRatio: try container.decode(Double.self, forKey: .dampingRatio),
                epsilon: try container.decodeIfPresent(Double.self, forKey: .epsilon) ?? 0.001
            )
        } else {
            self.init(
                mass: try container.decodeIfPresent(Double.self, forKey: .mass) ?? 1.0,
                stiffness: try container.decode(Double.self, forKey: .stiffness),
                damping: try container.decode(Double.self, forKey: .damping),
                allowOverDamping: try container.decodeIfPresent(Bool.self, forKey: .allowOverDamping) ?? false
            )
        }
    }
    
    enum SpringType: String, Decodable {
        case smooth
        case snappy
        case bouncy
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case extraBounce
        
        case duration
        case bounce
        
        case response
        case dampingRatio
        
        case settlingDuration
        case epsilon
        
        case mass
        case stiffness
        case damping
        case allowOverDamping
    }
}
#endif
