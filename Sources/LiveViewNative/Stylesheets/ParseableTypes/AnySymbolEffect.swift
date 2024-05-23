//
//  AnySymbolEffect.swift
//
//
//  Created by Carson Katri on 11/21/23.
//

import SwiftUI
import Symbols
import LiveViewNativeStylesheet

/// See [`Symbols.SymbolEffect`](https://developer.apple.com/documentation/symbols/SymbolEffect) for more details.
///
/// Possible values:
/// - `.appear`
/// - `.automatic`
/// - `.bounce`
/// - `.disappear`
/// - `.pulse`
/// - `.replace`
/// - `.scale`
/// - `.variableColor`
///
/// Apply modifiers to the symbol effect to customize it.
///
/// Possible modifiers:
/// - `.down`
/// - `.up`
/// - `.byLayer`
/// - `.wholeSymbol`
///
/// ```swift
/// .appear.down
/// .variableColor.cumulative.reversing.dimInactiveLayers
/// .variableColor.hideInactiveLayers
/// ```
@_documentation(visibility: public)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
struct AnySymbolEffect: SymbolEffect, ContentTransitionSymbolEffect, ParseableModifierValue, IndefiniteSymbolEffect, DiscreteSymbolEffect {
    let configuration: SymbolEffectConfiguration
    
    init(configuration: SymbolEffectConfiguration) {
        self.configuration = configuration
    }
    
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            AppearSymbolEffect.parser(in: context).map({ Self.init(configuration: $0.configuration) })
            AutomaticSymbolEffect.parser(in: context).map({ Self.init(configuration: $0.configuration) })
            BounceSymbolEffect.parser(in: context).map({ Self.init(configuration: $0.configuration) })
            DisappearSymbolEffect.parser(in: context).map({ Self.init(configuration: $0.configuration) })
            PulseSymbolEffect.parser(in: context).map({ Self.init(configuration: $0.configuration) })
            ReplaceSymbolEffect.parser(in: context).map({ Self.init(configuration: $0.configuration) })
            ScaleSymbolEffect.parser(in: context).map({ Self.init(configuration: $0.configuration) })
            VariableColorSymbolEffect.parser(in: context).map({ Self.init(configuration: $0.configuration) })
        }
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension AppearSymbolEffect: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ChainedMemberExpression {
            ConstantAtomLiteral("appear").map({ Self.appear })
        } member: {
            Member.parser(in: context)
        }
        .map { base, members in
            members.reduce(into: base) { $0 = $1.apply(to: $0) }
        }
    }
    
    enum Member: String, CaseIterable, ParseableModifierValue {
        case down
        case up
        case byLayer
        case wholeSymbol
        
        func apply(to effect: AppearSymbolEffect) -> AppearSymbolEffect {
            switch self {
            case .down: effect.down
            case .up: effect.up
            case .byLayer: effect.byLayer
            case .wholeSymbol: effect.wholeSymbol
            }
        }
        
        static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
            OneOf {
                for `case` in Self.allCases {
                    ConstantAtomLiteral(`case`.rawValue).map({ `case` })
                }
            }
        }
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension AutomaticSymbolEffect: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember(["automatic": Self.automatic])
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension BounceSymbolEffect: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ChainedMemberExpression {
            ConstantAtomLiteral("bounce").map({ Self.bounce })
        } member: {
            Member.parser(in: context)
        }
        .map { base, members in
            members.reduce(into: base) { $0 = $1.apply(to: $0) }
        }
    }
    
    enum Member: String, CaseIterable, ParseableModifierValue {
        case down
        case up
        case byLayer
        case wholeSymbol
        
        func apply(to effect: BounceSymbolEffect) -> BounceSymbolEffect {
            switch self {
            case .down: effect.down
            case .up: effect.up
            case .byLayer: effect.byLayer
            case .wholeSymbol: effect.wholeSymbol
            }
        }
        
        static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
            OneOf {
                for `case` in Self.allCases {
                    ConstantAtomLiteral(`case`.rawValue).map({ `case` })
                }
            }
        }
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DisappearSymbolEffect: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ChainedMemberExpression {
            ConstantAtomLiteral("disappear").map({ Self.disappear })
        } member: {
            Member.parser(in: context)
        }
        .map { base, members in
            members.reduce(into: base) { $0 = $1.apply(to: $0) }
        }
    }
    
    enum Member: String, CaseIterable, ParseableModifierValue {
        case down
        case up
        case byLayer
        case wholeSymbol
        
        func apply(to effect: DisappearSymbolEffect) -> DisappearSymbolEffect {
            switch self {
            case .down: effect.down
            case .up: effect.up
            case .byLayer: effect.byLayer
            case .wholeSymbol: effect.wholeSymbol
            }
        }
        
        static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
            OneOf {
                for `case` in Self.allCases {
                    ConstantAtomLiteral(`case`.rawValue).map({ `case` })
                }
            }
        }
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension PulseSymbolEffect: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ChainedMemberExpression {
            ConstantAtomLiteral("pulse").map({ Self.pulse })
        } member: {
            Member.parser(in: context)
        }
        .map { base, members in
            members.reduce(into: base) { $0 = $1.apply(to: $0) }
        }
    }
    
    enum Member: String, CaseIterable, ParseableModifierValue {
        case byLayer
        case wholeSymbol
        
        func apply(to effect: PulseSymbolEffect) -> PulseSymbolEffect {
            switch self {
            case .byLayer: effect.byLayer
            case .wholeSymbol: effect.wholeSymbol
            }
        }
        
        static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
            OneOf {
                for `case` in Self.allCases {
                    ConstantAtomLiteral(`case`.rawValue).map({ `case` })
                }
            }
        }
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension ReplaceSymbolEffect: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ChainedMemberExpression {
            ConstantAtomLiteral("replace").map({ Self.replace })
        } member: {
            Member.parser(in: context)
        }
        .map { base, members in
            members.reduce(into: base) { $0 = $1.apply(to: $0) }
        }
    }
    
    enum Member: String, CaseIterable, ParseableModifierValue {
        case downUp
        case offUp
        case upUp
        case byLayer
        case wholeSymbol
        
        func apply(to effect: ReplaceSymbolEffect) -> ReplaceSymbolEffect {
            switch self {
            case .downUp: effect.downUp
            case .offUp: effect.offUp
            case .upUp: effect.upUp
            case .byLayer: effect.byLayer
            case .wholeSymbol: effect.wholeSymbol
            }
        }
        
        static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
            OneOf {
                for `case` in Self.allCases {
                    ConstantAtomLiteral(`case`.rawValue).map({ `case` })
                }
            }
        }
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension ScaleSymbolEffect: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ChainedMemberExpression {
            ConstantAtomLiteral("scale").map({ Self.scale })
        } member: {
            Member.parser(in: context)
        }
        .map { base, members in
            members.reduce(into: base) { $0 = $1.apply(to: $0) }
        }
    }
    
    enum Member: String, CaseIterable, ParseableModifierValue {
        case down
        case up
        case byLayer
        case wholeSymbol
        
        func apply(to effect: ScaleSymbolEffect) -> ScaleSymbolEffect {
            switch self {
            case .down: effect.down
            case .up: effect.up
            case .byLayer: effect.byLayer
            case .wholeSymbol: effect.wholeSymbol
            }
        }
        
        static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
            OneOf {
                for `case` in Self.allCases {
                    ConstantAtomLiteral(`case`.rawValue).map({ `case` })
                }
            }
        }
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension VariableColorSymbolEffect: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ChainedMemberExpression {
            ConstantAtomLiteral("variableColor").map({ Self.variableColor })
        } member: {
            Member.parser(in: context)
        }
        .map { base, members in
            members.reduce(into: base) { $0 = $1.apply(to: $0) }
        }
    }
    
    enum Member: String, CaseIterable, ParseableModifierValue {
        case cumulative, iterative, nonReversing, reversing, dimInactiveLayers, hideInactiveLayers
        
        func apply(to effect: VariableColorSymbolEffect) -> VariableColorSymbolEffect {
            switch self {
            case .cumulative: effect.cumulative
            case .iterative: effect.iterative
            case .nonReversing: effect.nonReversing
            case .reversing: effect.reversing
            case .dimInactiveLayers: effect.dimInactiveLayers
            case .hideInactiveLayers: effect.hideInactiveLayers
            }
        }
        
        static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
            OneOf {
                for `case` in Self.allCases {
                    ConstantAtomLiteral(`case`.rawValue).map({ `case` })
                }
            }
        }
    }
}

/// See [`Symbols.SymbolEffectOptions`](https://developer.apple.com/documentation/symbols/SymbolEffectOptions) for more details.
///
/// Possible values:
/// - `.repeating`
/// - `.nonRepeating`
/// - `.speed(Double)`
/// - `.repeat(Int)`
@_documentation(visibility: public)
@available(iOS 17.0, macOS 14, tvOS 17, watchOS 10, *)
extension SymbolEffectOptions: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ChainedMemberExpression {
            OneOf {
                ConstantAtomLiteral("default").map({ Self.default })
                ConstantAtomLiteral("repeating").map({ Self.repeating })
                ConstantAtomLiteral("nonRepeating").map({ Self.nonRepeating })
                Speed.parser(in: context).map({ Self.speed($0.speed) })
                Repeat.parser(in: context).map({ Self.repeat($0.count) })
            }
        } member: {
            OneOf {
                ConstantAtomLiteral("repeating").map({ Member.repeating })
                ConstantAtomLiteral("nonRepeating").map({ Member.nonRepeating })
                Speed.parser(in: context).map(Member.speed)
                Repeat.parser(in: context).map(Member.repeat)
            }
        }
        .map { base, members in
            members.reduce(into: base) { $0 = $1.apply(to: $0) }
        }
    }
    
    enum Member {
        case repeating
        case nonRepeating
        case speed(Speed)
        case `repeat`(Repeat)
        
        func apply(to options: SymbolEffectOptions) -> SymbolEffectOptions {
            switch self {
            case .repeating: options.repeating
            case .nonRepeating: options.nonRepeating
            case .speed(let speed): options.speed(speed.speed)
            case .repeat(let `repeat`): options.repeat(`repeat`.count)
            }
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
    struct Repeat {
        static let name = "repeat"
        
        let count: Int?
        
        init(_ count: Int?) {
            self.count = count
        }
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
typealias AnyIndefiniteSymbolEffect = AnySymbolEffect
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
typealias AnyDiscreteSymbolEffect = AnySymbolEffect
