//
//  Animation+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 12/4/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.Animation`](https://developer.apple.com/documentation/swiftui/Animation) for more details.
///
/// Standard Animations:
/// - `.default`
/// - `.bouncy`
/// - `.smooth`
/// - `.snappy`
/// - `.spring`
/// - `.interactiveSpring`
/// - `.interpolatingSpring`
///
/// ## Easing Animations
/// Use `.easeIn`, `.easeOut`, `.easeInOut`, and `.linear` with a duration to use a standard easing function.
///
/// ```swift
/// .easeIn(duration: 3)
/// .linear(duration: 1.5)
/// ```
///
/// Use `.timingCurve` to build a custom bezier timing curve.
/// Pass a ``SwiftUI/UnitCurve`` to use a standard curve.
///
/// ```swift
/// .timingCurve(0.1, 0.75, 0.85, 0.35, duration: 2.0)
/// .timingCurve(UnitCurve(0.1, 0.75, 0.85, 0.35), duration: 2.0)
/// .timingCurve(.easeInOut, duration: 2.0)
/// ```
@_documentation(visibility: public)
extension Animation: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ChainedMemberExpression {
            OneOf {
                ConstantAtomLiteral("default").map({ Base.default })
                Base.EaseIn.parser(in: context).map(Base.easeIn)
                Base.EaseOut.parser(in: context).map(Base.easeOut)
                Base.EaseInOut.parser(in: context).map(Base.easeInOut)
                Base.Linear.parser(in: context).map(Base.linear)
                Base.Spring.parser(in: context).map(Base.spring)
                ConstantAtomLiteral("spring").map({ Base.spring(.init()) })
                Base.InteractiveSpring.parser(in: context).map(Base.interactiveSpring)
                ConstantAtomLiteral("interactiveSpring").map({ Base.interactiveSpring(.init()) })
                Base.InterpolatingSpring.parser(in: context).map(Base.interpolatingSpring)
                ConstantAtomLiteral("interpolatingSpring").map({ Base.interpolatingSpring(.init()) })
                Base.TimingCurve.parser(in: context).map(Base.timingCurve)
                
                BouncySpring.parser(in: context).map(Base.bouncy)
                ConstantAtomLiteral("bouncy").map({ Base.bouncy(.init()) })
                SmoothSpring.parser(in: context).map(Base.smooth)
                ConstantAtomLiteral("smooth").map({ Base.smooth(.init()) })
                SnappySpring.parser(in: context).map(Base.snappy)
                ConstantAtomLiteral("snappy").map({ Base.snappy(.init()) })
            }
        } member: {
            OneOf {
                Modifier.Delay.parser(in: context).map(Modifier.delay)
                Modifier.RepeatCount.parser(in: context).map(Modifier.repeatCount)
                Modifier.RepeatForever.parser(in: context).map(Modifier.repeatForever)
                Modifier.Speed.parser(in: context).map(Modifier.speed)
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
            case let .spring(spring):
                spring.value
            case let .interactiveSpring(interactiveSpring):
                interactiveSpring.value
            case let .interpolatingSpring(interpolatingSpring):
                interpolatingSpring.value
            case let .timingCurve(timingCurve):
                timingCurve.value
            case let .bouncy(value):
                Self.bouncy(duration: value.duration, extraBounce: value.extraBounce)
            case let .smooth(value):
                Self.smooth(duration: value.duration, extraBounce: value.extraBounce)
            case let .snappy(value):
                Self.snappy(duration: value.duration, extraBounce: value.extraBounce)
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
        case spring(Spring)
        case interactiveSpring(InteractiveSpring)
        case interpolatingSpring(InterpolatingSpring)
        case timingCurve(TimingCurve)
        case bouncy(BouncySpring)
        case smooth(SmoothSpring)
        case snappy(SnappySpring)
        
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
        
        @ParseableExpression
        struct Spring {
            static let name = "spring"
            
            let value: Animation
            
            init() {
                self.value = .spring
            }
            
            @available(iOS 17.0, macOS 14, tvOS 17, watchOS 10, *)
            init(
                _ spring: SwiftUI.Spring,
                blendDuration: Double = 0.0
            ) {
                self.value = .spring(spring, blendDuration: blendDuration)
            }
            
            init(
                duration: Double = 0.5,
                bounce: Double = 0.0,
                blendDuration: Double = 0
            ) {
                self.value = .spring(duration: duration, bounce: bounce, blendDuration: blendDuration)
            }
            
            init(
                response: Double = 0.5,
                dampingFraction: Double = 0.825,
                blendDuration: TimeInterval = 0
            ) {
                self.value = .spring(response: response, dampingFraction: dampingFraction, blendDuration: blendDuration)
            }
        }
        
        @ParseableExpression
        struct InteractiveSpring {
            static let name = "interactiveSpring"
            
            let value: Animation
            
            init() {
                self.value = .interactiveSpring
            }
            
            init(
                response: Double = 0.15,
                dampingFraction: Double = 0.86,
                blendDuration: TimeInterval = 0.25
            ) {
                self.value = .interactiveSpring(response: response, dampingFraction: dampingFraction, blendDuration: blendDuration)
            }
            
            init(
                duration: TimeInterval = 0.15,
                extraBounce: Double = 0.0,
                blendDuration: TimeInterval = 0.25
            ) {
                self.value = .interactiveSpring(duration: duration, extraBounce: extraBounce, blendDuration: blendDuration)
            }
        }
        
        @ParseableExpression
        struct InterpolatingSpring {
            static let name = "interpolatingSpring"
            
            let value: Animation
            
            init() {
                self.value = .interpolatingSpring
            }
            
            @available(iOS 17.0, macOS 14, tvOS 17, watchOS 10, *)
            init(
                _ spring: SwiftUI.Spring,
                initialVelocity: Double = 0.0
            ) {
                self.value = .interpolatingSpring(spring, initialVelocity: initialVelocity)
            }
            
            init(
                duration: TimeInterval = 0.5,
                bounce: Double = 0.0,
                initialVelocity: Double = 0.0
            ) {
                self.value = .interpolatingSpring(duration: duration, bounce: bounce, initialVelocity: initialVelocity)
            }
            
            init(
                mass: Double = 1.0,
                stiffness: Double,
                damping: Double,
                initialVelocity: Double = 0.0
            ) {
                self.value = .interpolatingSpring(mass: mass, stiffness: stiffness, damping: damping, initialVelocity: initialVelocity)
            }
        }
        
        @ParseableExpression
        struct TimingCurve {
            static let name = "timingCurve"
            
            let value: Animation
            
            init(_ p1x: Double, _ p1y: Double, _ p2x: Double, _ p2y: Double, duration: TimeInterval = 0.35) {
                self.value = .timingCurve(p1x, p1y, p2x, p2y, duration: duration)
            }
            
            @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
            init(_ curve: UnitCurve, duration: TimeInterval) {
                self.value = .timingCurve(curve, duration: duration)
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

@available(iOS 17.0, macOS 14, tvOS 17, watchOS 10, *)
extension Spring: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            _Spring.parser(in: context).map(\.value)
            ImplicitStaticMember {
                OneOf {
                    BouncySpring.parser(in: context).map({ Self.bouncy(duration: $0.duration, extraBounce: $0.extraBounce) })
                    ConstantAtomLiteral("bouncy").map({ Self.bouncy })
                    SmoothSpring.parser(in: context).map({ Self.smooth(duration: $0.duration, extraBounce: $0.extraBounce) })
                    ConstantAtomLiteral("smooth").map({ Self.smooth })
                    SnappySpring.parser(in: context).map({ Self.snappy(duration: $0.duration, extraBounce: $0.extraBounce) })
                    ConstantAtomLiteral("snappy").map({ Self.snappy })
                }
            }
        }
    }
    
    @ParseableExpression
    struct _Spring {
        static let name = "Spring"
        
        let value: Spring
        
        init(
            duration: Double = 0.5,
            bounce: Double = 0.0
        ) {
            self.value = .init(duration: duration, bounce: bounce)
        }
        
        init(
            mass: Double = 1.0,
            stiffness: Double,
            damping: Double,
            allowOverDamping: Bool = false
        ) {
            self.value = .init(mass: mass, stiffness: stiffness, damping: damping, allowOverDamping: allowOverDamping)
        }
        
        init(
            response: Double,
            dampingRatio: Double
        ) {
            self.value = .init(response: response, dampingRatio: dampingRatio)
        }
        
        init(
            settlingDuration: Double,
            dampingRatio: Double,
            epsilon: Double = 0.001
        ) {
            self.value = .init(settlingDuration: settlingDuration, dampingRatio: dampingRatio, epsilon: epsilon)
        }
    }
}

@ParseableExpression
struct BouncySpring {
    static let name = "bouncy"
    
    let duration: Double
    let extraBounce: Double
    
    init(
        duration: Double = 0.5,
        extraBounce: Double = 0.0
    ) {
        self.duration = duration
        self.extraBounce = extraBounce
    }
}

@ParseableExpression
struct SmoothSpring {
    static let name = "smooth"
    
    let duration: Double
    let extraBounce: Double
    
    init(
        duration: Double = 0.5,
        extraBounce: Double = 0.0
    ) {
        self.duration = duration
        self.extraBounce = extraBounce
    }
}

@ParseableExpression
struct SnappySpring {
    static let name = "snappy"
    
    let duration: Double
    let extraBounce: Double
    
    init(
        duration: Double = 0.5,
        extraBounce: Double = 0.0
    ) {
        self.duration = duration
        self.extraBounce = extraBounce
    }
}
