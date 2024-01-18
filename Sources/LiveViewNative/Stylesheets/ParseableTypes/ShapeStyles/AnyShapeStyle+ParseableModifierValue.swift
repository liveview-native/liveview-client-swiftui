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
            
            Material.parser(in: context).map({ $0 as any ShapeStyle })
            
            ConstantAtomLiteral("foreground").map({ ForegroundStyle() as any ShapeStyle })
            ConstantAtomLiteral("background").map({ BackgroundStyle() as any ShapeStyle })
            ConstantAtomLiteral("selection").map({ SelectionShapeStyle() as any ShapeStyle })
            ConstantAtomLiteral("tint").map({ TintShapeStyle() as any ShapeStyle })
            if #available(iOS 17, macOS 14, tvOS 17, watchOS 10, visionOS 1, *) {
                ConstantAtomLiteral("separator").map({ SeparatorShapeStyle() as any ShapeStyle })
                ConstantAtomLiteral("placeholder").map({ PlaceholderTextShapeStyle() as any ShapeStyle })
                ConstantAtomLiteral("link").map({ LinkShapeStyle() as any ShapeStyle })
                ConstantAtomLiteral("fill").map({ FillShapeStyle() as any ShapeStyle })
            }
            if #available(iOS 17, macOS 14, tvOS 17, watchOS 10, *) {
                ConstantAtomLiteral("windowBackground").map({ WindowBackgroundShapeStyle() as any ShapeStyle })
            }
            
            ImagePaint.parser(in: context).map({ $0 as any ShapeStyle })
            _image.parser(in: context).map(\.value)
            
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
    
    @ParseableExpression
    struct _image {
        static let name = "image"
        
        let value: any ShapeStyle
        
        init(_ image: Image, sourceRect: CGRect = .init(x: 0, y: 0, width: 1, height: 1), scale: CGFloat = 1) {
            self.value = ImagePaint.image(image, sourceRect: sourceRect, scale: scale)
        }
    }
    
    enum StyleModifier: ParseableModifierValue {
        case opacity(Opacity)
        case hierarchical(HierarchicalLevel)
        
        static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
            OneOf {
                Opacity.parser(in: context).map(Self.opacity)
                HierarchicalLevel.parser(in: context).map(Self.hierarchical)
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
        
        enum HierarchicalLevel: String, CaseIterable, ParseableModifierValue {
            typealias _ParserType = EnumParser<Self>
            
            static func parser(in context: ParseableModifierContext) -> EnumParser<Self> {
                .init(Dictionary(uniqueKeysWithValues: Self.allCases.map({ ($0.rawValue, $0) })))
            }
            
            case secondary
            case tertiary
            case quaternary
            case quinary
        }
        
        func apply(to style: some ShapeStyle) -> any ShapeStyle {
            switch self {
            case let .opacity(opacity):
                return style.opacity(opacity.value)
            case let .hierarchical(level):
                if #available(iOS 17, macOS 14, tvOS 17, watchOS 10, visionOS 1, *) {
                    switch level {
                    case .secondary:
                        return style.secondary
                    case .tertiary:
                        return style.tertiary
                    case .quaternary:
                        return style.quaternary
                    case .quinary:
                        return style.quinary
                    }
                } else {
                    return style
                }
            }
        }
    }
}

extension HierarchicalShapeStyle: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            ConstantAtomLiteral("primary").map({ Self.primary })
            ConstantAtomLiteral("secondary").map({ Self.secondary })
            ConstantAtomLiteral("tertiary").map({ Self.tertiary })
            ConstantAtomLiteral("quaternary").map({ Self.quaternary })
            if #available(tvOS 17, watchOS 10, *) {
                ConstantAtomLiteral("quinary").map({ Self.quinary })
            }
        }
    }
}

extension Material: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            ConstantAtomLiteral("ultraThinMaterial").map({ Self.ultraThinMaterial })
            ConstantAtomLiteral("thinMaterial").map({ Self.thinMaterial })
            ConstantAtomLiteral("regularMaterial").map({ Self.regularMaterial })
            ConstantAtomLiteral("thickMaterial").map({ Self.thickMaterial })
            ConstantAtomLiteral("ultraThickMaterial").map({ Self.ultraThickMaterial })
            if #available(iOS 15, macOS 12, visionOS 1.0, *) {
                ConstantAtomLiteral("bar").map({ Self.bar })
            }
        }
    }
}
