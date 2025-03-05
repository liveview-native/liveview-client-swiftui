//
//  Symbols.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/30/25.
//

import SwiftUI
import Symbols
import LiveViewNativeStylesheet
import LiveViewNativeCore

@ASTDecodable("IndefiniteSymbolEffect")
@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
enum StylesheetResolvableIndefiniteSymbolEffect: StylesheetResolvable, @preconcurrency Decodable {
    case appear
    case bounce
    case breathe
    case disappear
    case pulse
    case rotate
    case scale
    case variableColor
    case wiggle
}

@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
extension StylesheetResolvableIndefiniteSymbolEffect {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Self {
        return self
    }
}

@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
extension StylesheetResolvableIndefiniteSymbolEffect: @preconcurrency AttributeDecodable {
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "appear":
            self = .appear
        case "bounce":
            self = .bounce
        case "breathe":
            self = .breathe
        case "disappear":
            self = .disappear
        case "pulse":
            self = .pulse
        case "rotate":
            self = .rotate
        case "scale":
            self = .scale
        case "variableColor":
            self = .variableColor
        case "wiggle":
            self = .wiggle
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}

@ASTDecodable("DiscreteSymbolEffect")
@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
enum StylesheetResolvableDiscreteSymbolEffect: StylesheetResolvable, @preconcurrency Decodable {
    case bounce
    case breathe
    case pulse
    case rotate
    case variableColor
    case wiggle
}

@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
extension StylesheetResolvableDiscreteSymbolEffect {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Self {
        return self
    }
}

@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
extension StylesheetResolvableDiscreteSymbolEffect: @preconcurrency AttributeDecodable {
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "bounce":
            self = .bounce
        case "breathe":
            self = .breathe
        case "pulse":
            self = .pulse
        case "rotate":
            self = .rotate
        case "variableColor":
            self = .variableColor
        case "wiggle":
            self = .wiggle
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}

@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
extension View {
    @_disfavoredOverload
    @ViewBuilder
    nonisolated func symbolEffect(
        _ effect: StylesheetResolvableIndefiniteSymbolEffect,
        options: SymbolEffectOptions = .default,
        isActive: Bool = true
    ) -> some View {
        switch effect {
        case .appear:
            self.symbolEffect(AppearSymbolEffect.appear, options: options, isActive: isActive)
        case .bounce:
            if #available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
                self.symbolEffect(BounceSymbolEffect.bounce, options: options, isActive: isActive)
            } else {
                self
            }
        case .breathe:
            if #available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
                self.symbolEffect(BreatheSymbolEffect.breathe, options: options, isActive: isActive)
            } else {
                self
            }
        case .disappear:
            self.symbolEffect(DisappearSymbolEffect.disappear, options: options, isActive: isActive)
        case .pulse:
            self.symbolEffect(PulseSymbolEffect.pulse, options: options, isActive: isActive)
        case .rotate:
            if #available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
                self.symbolEffect(RotateSymbolEffect.rotate, options: options, isActive: isActive)
            } else {
                self
            }
        case .scale:
            self.symbolEffect(ScaleSymbolEffect.scale, options: options, isActive: isActive)
        case .variableColor:
            self.symbolEffect(VariableColorSymbolEffect.variableColor, options: options, isActive: isActive)
        case .wiggle:
            if #available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
                self.symbolEffect(WiggleSymbolEffect.wiggle, options: options, isActive: isActive)
            } else {
                self
            }
        }
    }
    
    @_disfavoredOverload
    @ViewBuilder
    nonisolated func symbolEffect(
        _ effect: StylesheetResolvableDiscreteSymbolEffect,
        options: SymbolEffectOptions = .default,
        value: String
    ) -> some View {
        switch effect {
        case .bounce:
            self.symbolEffect(BounceSymbolEffect.bounce, options: options, value: value)
        case .breathe:
            if #available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
                self.symbolEffect(BreatheSymbolEffect.breathe, options: options, value: value)
            } else {
                self
            }
        case .pulse:
            self.symbolEffect(PulseSymbolEffect.pulse, options: options, value: value)
        case .rotate:
            if #available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
                self.symbolEffect(RotateSymbolEffect.rotate, options: options, value: value)
            } else {
                self
            }
        case .variableColor:
            self.symbolEffect(VariableColorSymbolEffect.variableColor, options: options, value: value)
        case .wiggle:
            if #available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
                self.symbolEffect(WiggleSymbolEffect.wiggle, options: options, value: value)
            } else {
                self
            }
        }
    }
}

@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
extension Symbols.SymbolEffectOptions {
    @ASTDecodable("SymbolEffectOptions")
    @MainActor
    public indirect enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        case __constant(SymbolEffectOptions)
        
        case `default`
        
        case nonRepeating
        case _nonRepeating(Self)
        
        case _repeat(Any)
        @available(iOS 18, macOS 15, tvOS 18, visionOS 2, watchOS 11, *)
        static func `repeat`(_ behavior: AttributeReference<SymbolEffectOptions.RepeatBehavior.Resolvable>) -> Self {
            ._repeat(behavior)
        }
        
        case _repeatMember(Self, Any)
        @available(iOS 18, macOS 15, tvOS 18, visionOS 2, watchOS 11, *)
        func `repeat`(_ behavior: AttributeReference<SymbolEffectOptions.RepeatBehavior.Resolvable>) -> Self {
            ._repeatMember(self, behavior)
        }
        
        case speed(AttributeReference<Double>)
        
        case _speed(Self, AttributeReference<Double>)
        func speed(_ speed: AttributeReference<Double>) -> Self {
            ._speed(self, speed)
        }
    }
}

@available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
extension SymbolEffectOptions.RepeatBehavior.Resolvable: @preconcurrency AttributeDecodable {
    public init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "continuous":
            self = .continuous
        case "periodic":
            self = .periodic
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}

@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
public extension SymbolEffectOptions.Resolvable {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> SymbolEffectOptions {
        switch self {
        case let .__constant(value):
            return value
        case .default:
            return .default
        case .nonRepeating:
            return .nonRepeating
        case let ._nonRepeating(parent):
            return parent.resolve(on: element, in: context).nonRepeating
        case let ._repeat(behavior):
            if #available(iOS 18, macOS 15, tvOS 18, visionOS 2, watchOS 11, *) {
                return .repeat((behavior as! AttributeReference<SymbolEffectOptions.RepeatBehavior.Resolvable>).resolve(on: element, in: context).resolve(on: element, in: context))
            } else {
                return .default
            }
        case let ._repeatMember(parent, behavior):
            if #available(iOS 18, macOS 15, tvOS 18, visionOS 2, watchOS 11, *) {
                return parent.resolve(on: element, in: context).repeat((behavior as! AttributeReference<SymbolEffectOptions.RepeatBehavior.Resolvable>).resolve(on: element, in: context).resolve(on: element, in: context))
            } else {
                return parent.resolve(on: element, in: context)
            }
        case let .speed(speed):
            return .speed(speed.resolve(on: element, in: context))
        case let ._speed(parent, speed):
            return parent.resolve(on: element, in: context).speed(speed.resolve(on: element, in: context))
        }
    }
}

@available(iOS 18, macOS 15, tvOS 18, visionOS 2, watchOS 11, *)
extension SymbolEffectOptions.RepeatBehavior {
    @ASTDecodable("RepeatBehavior")
    @MainActor
    public enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        case continuous
        case periodic
        
        case _periodic(AttributeReference<Int?>, delay: AttributeReference<Double?>)
        func periodic(_ count: AttributeReference<Int?> = .constant(nil), delay: AttributeReference<Double?> = .constant(nil)) -> Self {
            ._periodic(count, delay: delay)
        }
    }
}

@available(iOS 18, macOS 15, tvOS 18, visionOS 2, watchOS 11, *)
public extension SymbolEffectOptions.RepeatBehavior.Resolvable {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> SymbolEffectOptions.RepeatBehavior {
        switch self {
        case .continuous:
            return .continuous
        case .periodic:
            return .periodic
        case let ._periodic(count, delay):
            return .periodic(count.resolve(on: element, in: context), delay: delay.resolve(on: element, in: context))
        }
    }
}
