//
//  AnyShapeStyle+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 10/17/23.
//

import SwiftUI
import LiveViewNativeStylesheet

extension AnyShapeStyle: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            ChainedMemberExpression {
                baseParser(in: context)
            } member: {
                StyleModifier.parser(in: context)
            }
            .map({ (base: any ShapeStyle, members: [StyleModifier]) in
                (base: base, members: members)
            })
            _ColorParser(context: context) {
                StyleModifier.parser(in: context)
            }
            .map({ (base: SwiftUI.Color, members: [StyleModifier]) in
                (base: base as any ShapeStyle, members: members)
            })
        }
        .map({ (base: any ShapeStyle, modifiers: [StyleModifier]) in
            var result = base
            for modifier in modifiers {
                result = modifier.apply(to: result)
            }
            return AnyShapeStyle(result)
        })
    }
    
    static func baseParser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, any ShapeStyle> {
        OneOf {
            HierarchicalShapeStyle.parser(in: context).map({ $0 as any ShapeStyle })
            
            // gradient
            Gradient.parser(in: context).map({ $0 as any ShapeStyle })
            AnyGradient.parser(in: context).map({ $0 as any ShapeStyle })
            AngularGradient.parser(in: context).map({ $0 as any ShapeStyle })
            _angularGradient.parser(in: context).map(\.value)
            _conicGradient.parser(in: context).map(\.value)
            EllipticalGradient.parser(in: context).map({ $0 as any ShapeStyle })
            _ellipticalGradient.parser(in: context).map(\.value)
            LinearGradient.parser(in: context).map({ $0 as any ShapeStyle })
            _linearGradient.parser(in: context).map(\.value)
            RadialGradient.parser(in: context).map({ $0 as any ShapeStyle })
            _radialGradient.parser(in: context).map(\.value)
        }
    }
    
    @ParseableExpression
    struct _angularGradient {
        static let name = "angularGradient"
        
        let value: any ShapeStyle
        
        init(_ gradient: AnyGradient, center: UnitPoint = .center, startAngle: Angle, endAngle: Angle) {
            self.value = AngularGradient.angularGradient(gradient, center: center, startAngle: startAngle, endAngle: endAngle)
        }
        
        init(_ gradient: Gradient, center: UnitPoint = .center, startAngle: Angle, endAngle: Angle) {
            self.value = AngularGradient.angularGradient(gradient, center: center, startAngle: startAngle, endAngle: endAngle)
        }
        
        init(colors: [Color], center: UnitPoint, startAngle: Angle, endAngle: Angle) {
            self.value = AngularGradient.angularGradient(colors: colors, center: center, startAngle: startAngle, endAngle: endAngle)
        }
        
        init(stops: [Gradient.Stop], center: UnitPoint, startAngle: Angle, endAngle: Angle) {
            self.value = AngularGradient.angularGradient(stops: stops, center: center, startAngle: startAngle, endAngle: endAngle)
        }
    }
    
    @ParseableExpression
    struct _conicGradient {
        static let name = "conicGradient"
        
        let value: any ShapeStyle
        
        init(_ gradient: AnyGradient, center: UnitPoint = .center, angle: Angle = .zero) {
            self.value = AngularGradient.conicGradient(gradient, center: center, angle: angle)
        }
        
        init(_ gradient: Gradient, center: UnitPoint, angle: Angle = .zero) {
            self.value = AngularGradient.conicGradient(gradient, center: center, angle: angle)
        }
        
        init(colors: [Color], center: UnitPoint, angle: Angle = .zero) {
            self.value = AngularGradient.conicGradient(colors: colors, center: center, angle: angle)
        }
        
        init(stops: [Gradient.Stop], center: UnitPoint, angle: Angle = .zero) {
            self.value = AngularGradient.conicGradient(stops: stops, center: center, angle: angle)
        }
    }
    
    @ParseableExpression
    struct _ellipticalGradient {
        static let name = "ellipticalGradient"
        
        let value: any ShapeStyle
        
        init(_ gradient: Gradient, center: UnitPoint = .center, startRadiusFraction: CGFloat = 0, endRadiusFraction: CGFloat = 0.5) {
            self.value = EllipticalGradient.ellipticalGradient(gradient, center: center, startRadiusFraction: startRadiusFraction, endRadiusFraction: endRadiusFraction)
        }
        
        init(colors: [Color], center: UnitPoint = .center, startRadiusFraction: CGFloat = 0, endRadiusFraction: CGFloat = 0.5) {
            self.value = EllipticalGradient.ellipticalGradient(colors: colors, center: center, startRadiusFraction: startRadiusFraction, endRadiusFraction: endRadiusFraction)
        }
        
        init(stops: [Gradient.Stop], center: UnitPoint = .center, startRadiusFraction: CGFloat = 0, endRadiusFraction: CGFloat = 0.5) {
            self.value = EllipticalGradient.ellipticalGradient(stops: stops, center: center, startRadiusFraction: startRadiusFraction, endRadiusFraction: endRadiusFraction)
        }
        
        init(_ gradient: AnyGradient, center: UnitPoint = .center, startRadiusFraction: CGFloat = 0, endRadiusFraction: CGFloat = 0.5) {
            self.value = EllipticalGradient.ellipticalGradient(gradient, center: center, startRadiusFraction: startRadiusFraction, endRadiusFraction: endRadiusFraction)
        }
    }
    
    @ParseableExpression
    struct _linearGradient {
        static let name = "linearGradient"
        
        let value: any ShapeStyle
        
        init(_ gradient: Gradient, startPoint: UnitPoint, endPoint: UnitPoint) {
            self.value = LinearGradient.linearGradient(gradient, startPoint: startPoint, endPoint: endPoint)
        }
        
        init(colors: [Color], startPoint: UnitPoint, endPoint: UnitPoint) {
            self.value = LinearGradient.linearGradient(colors: colors, startPoint: startPoint, endPoint: endPoint)
        }
        
        init(stops: [Gradient.Stop], startPoint: UnitPoint, endPoint: UnitPoint) {
            self.value = LinearGradient.linearGradient(stops: stops, startPoint: startPoint, endPoint: endPoint)
        }
        
        init(_ gradient: AnyGradient, startPoint: UnitPoint, endPoint: UnitPoint) {
            self.value = LinearGradient.linearGradient(gradient, startPoint: startPoint, endPoint: endPoint)
        }
    }
    
    @ParseableExpression
    struct _radialGradient {
        static let name = "radialGradient"
        
        let value: any ShapeStyle
        
        init(_ gradient: Gradient, center: UnitPoint, startRadius: CGFloat, endRadius: CGFloat) {
            self.value = RadialGradient.radialGradient(gradient, center: center, startRadius: startRadius, endRadius: endRadius)
        }
        
        init(colors: [Color], center: UnitPoint, startRadius: CGFloat, endRadius: CGFloat) {
            self.value = RadialGradient.radialGradient(colors: colors, center: center, startRadius: startRadius, endRadius: endRadius)
        }
        
        init(stops: [Gradient.Stop], center: UnitPoint, startRadius: CGFloat, endRadius: CGFloat) {
            self.value = RadialGradient.radialGradient(stops: stops, center: center, startRadius: startRadius, endRadius: endRadius)
        }
        
        init(_ gradient: AnyGradient, center: UnitPoint = .center, startRadius: CGFloat = 0, endRadius: CGFloat) {
            self.value = RadialGradient.radialGradient(gradient, center: center, startRadius: startRadius, endRadius: endRadius)
        }
    }
    
    enum StyleModifier: ParseableModifierValue {
        case opacity(Opacity)
        
        static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
            OneOf {
                Opacity.parser(in: context).map(Self.opacity)
            }
        }
        
        @ParseableExpression
        struct Opacity {
            static let name = "opacity"
            
            let value: Double
            
            init(_ value: Double) {
                self.value = value
            }
        }
        
        func apply(to style: some ShapeStyle) -> any ShapeStyle {
            switch self {
            case let .opacity(opacity):
                style.opacity(opacity.value)
            }
        }
    }
}

extension HierarchicalShapeStyle: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            ConstantAtomLiteral("primary").map({ .primary })
            ConstantAtomLiteral("secondary").map({ .secondary })
            ConstantAtomLiteral("tertiary").map({ .tertiary })
            ConstantAtomLiteral("quaternary").map({ .quaternary })
            if #available(tvOS 17, watchOS 10, *) {
                ConstantAtomLiteral("quinary").map({ .quinary })
            }
        }
    }
}
