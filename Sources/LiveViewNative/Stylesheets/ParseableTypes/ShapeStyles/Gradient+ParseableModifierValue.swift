//
//  Gradient.swift
//
//
//  Created by Carson Katri on 1/16/24.
//

import SwiftUI
import LiveViewNativeStylesheet

extension AnyGradient: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        _ThrowingParse { (base: SwiftUI.Color, members: [()]) in
            guard !members.isEmpty else {
                throw ModifierParseError(error: .missingRequiredArgument("gradient"), metadata: context.metadata)
            }
            return base.gradient
        } with: {
            _ColorParser(context: context) {
                ConstantAtomLiteral("gradient")
            }
        }
    }
}

extension Gradient: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        _Gradient.parser(in: context).map(\.value)
    }
    
    @ParseableExpression
    struct _Gradient {
        static let name = "Gradient"
        
        let value: Gradient
        
        init(colors: [Color]) {
            self.value = .init(colors: colors)
        }
        
        init(stops: [Gradient.Stop]) {
            self.value = .init(stops: stops)
        }
    }
}

extension Gradient.Stop: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        MemberExpression {
            ConstantAtomLiteral("Gradient")
        } member: {
            _Stop.parser(in: context).map(\.value)
        }
        .map({ _, member in
            member
        })
    }
    
    @ParseableExpression
    struct _Stop {
        static let name = "Stop"
        
        let value: Gradient.Stop
        
        init(color: Color, location: CGFloat) {
            self.value = .init(color: color, location: location)
        }
    }
}

extension AngularGradient: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        _AngularGradient.parser(in: context).map(\.value)
    }
    
    @ParseableExpression
    struct _AngularGradient {
        static let name = "AngularGradient"
        
        let value: AngularGradient
        
        public init(gradient: Gradient, center: UnitPoint, startAngle: Angle = .zero, endAngle: Angle = .zero) {
            self.value = .init(gradient: gradient, center: center, startAngle: startAngle, endAngle: endAngle)
        }
        
        public init(colors: [Color], center: UnitPoint, startAngle: Angle, endAngle: Angle) {
            self.value = .init(colors: colors, center: center, startAngle: startAngle, endAngle: endAngle)
        }
        
        public init(stops: [Gradient.Stop], center: UnitPoint, startAngle: Angle, endAngle: Angle) {
            self.value = .init(stops: stops, center: center, startAngle: startAngle, endAngle: endAngle)
        }
        
        public init(gradient: Gradient, center: UnitPoint, angle: Angle = .zero) {
            self.value = .init(gradient: gradient, center: center, angle: angle)
        }
        
        public init(colors: [Color], center: UnitPoint, angle: Angle = .zero) {
            self.value = .init(colors: colors, center: center, angle: angle)
        }
        
        public init(stops: [Gradient.Stop], center: UnitPoint, angle: Angle = .zero) {
            self.value = .init(stops: stops, center: center, angle: angle)
        }
    }
}

extension EllipticalGradient: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        _EllipticalGradient.parser(in: context).map(\.value)
    }
    
    @ParseableExpression
    struct _EllipticalGradient {
        static let name = "EllipticalGradient"
        
        let value: EllipticalGradient
        
        init(gradient: Gradient, center: UnitPoint = .center, startRadiusFraction: CGFloat = 0, endRadiusFraction: CGFloat = 0.5) {
            self.value = .init(gradient: gradient, center: center, startRadiusFraction: startRadiusFraction, endRadiusFraction: endRadiusFraction)
        }
        
        init(colors: [Color], center: UnitPoint = .center, startRadiusFraction: CGFloat = 0, endRadiusFraction: CGFloat = 0.5) {
            self.value = .init(colors: colors, center: center, startRadiusFraction: startRadiusFraction, endRadiusFraction: endRadiusFraction)
        }
        
        init(stops: [Gradient.Stop], center: UnitPoint = .center, startRadiusFraction: CGFloat = 0, endRadiusFraction: CGFloat = 0.5) {
            self.value = .init(stops: stops, center: center, startRadiusFraction: startRadiusFraction, endRadiusFraction: endRadiusFraction)
        }
    }
}

extension LinearGradient: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        _LinearGradient.parser(in: context).map(\.value)
    }
    
    @ParseableExpression
    struct _LinearGradient {
        static let name = "LinearGradient"
        
        let value: LinearGradient
        
        init(gradient: Gradient, startPoint: UnitPoint, endPoint: UnitPoint) {
            self.value = .init(gradient: gradient, startPoint: startPoint, endPoint: endPoint)
        }
        init(colors: [Color], startPoint: UnitPoint, endPoint: UnitPoint) {
            self.value = .init(colors: colors, startPoint: startPoint, endPoint: endPoint)
        }
        init(stops: [Gradient.Stop], startPoint: UnitPoint, endPoint: UnitPoint) {
            self.value = .init(stops: stops, startPoint: startPoint, endPoint: endPoint)
        }
    }
}

extension RadialGradient: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        _RadialGradient.parser(in: context).map(\.value)
    }
    
    @ParseableExpression
    struct _RadialGradient {
        static let name = "RadialGradient"
        
        let value: RadialGradient
        
        init(gradient: Gradient, center: UnitPoint, startRadius: CGFloat, endRadius: CGFloat) {
            self.value = .init(gradient: gradient, center: center, startRadius: startRadius, endRadius: endRadius)
        }
        
        init(colors: [Color], center: UnitPoint, startRadius: CGFloat, endRadius: CGFloat) {
            self.value = .init(colors: colors, center: center, startRadius: startRadius, endRadius: endRadius)
        }
        
        init(stops: [Gradient.Stop], center: UnitPoint, startRadius: CGFloat, endRadius: CGFloat) {
            self.value = .init(stops: stops, center: center, startRadius: startRadius, endRadius: endRadius)
        }
    }
}
