//
//  Animation+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 12/4/23.
//

import SwiftUI
import LiveViewNativeStylesheet

extension Animation: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ChainedMemberExpression {
            OneOf {
                ConstantAtomLiteral("default").map({ Base.default })
                Base.EaseIn.parser(in: context).map(Base.easeIn)
                Base.EaseOut.parser(in: context).map(Base.easeOut)
                Base.EaseInOut.parser(in: context).map(Base.easeInOut)
                Base.Linear.parser(in: context).map(Base.linear)
                ConstantAtomLiteral("spring").map({ Base.spring })
                ConstantAtomLiteral("interactiveSpring").map({ Base.interactiveSpring })
                ConstantAtomLiteral("interpolatingSpring").map({ Base.interpolatingSpring })
                Base.TimingCurve.parser(in: context).map(Base.timingCurve)
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
            case let .timingCurve(timingCurve):
                timingCurve.value
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
        case timingCurve(TimingCurve)
        
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
