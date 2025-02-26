//
//  ShapeStyle.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/30/25.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

indirect enum StylesheetResolvableShapeStyle: StylesheetResolvable, @preconcurrency ShapeStyle, @preconcurrency Decodable {
    typealias Resolved = AnyShapeStyle
    
    case color(Color.Resolvable)
    case angularGradient(AngularGradient.Resolvable)
    case linearGradient(LinearGradient.Resolvable)
    case radialGradient(RadialGradient.Resolvable)
    case material(MaterialShapeStyle)
    case imagePaint(ImagePaint.Resolvable)
    case hierarchical(HierarchicalShapeStyle.Resolvable)
    case semantic(SemanticShapeStyle)
    case modified(ModifiedShapeStyle)
    
    struct ModifiedShapeStyle: StylesheetResolvable, @preconcurrency Decodable {
        let base: StylesheetResolvableShapeStyle
        let modifier: Modifier
        
        enum Modifier: @preconcurrency Decodable {
            case hierarchical(HierarchicalModifier)
            case blendMode(BlendModeModifier)
            case opacity(OpacityModifier)
            case shadow(ShadowModifier)
            
            @ASTDecodable("blendMode")
            struct BlendModeModifier: @preconcurrency Decodable {
                let blendMode: BlendMode.Resolvable
                
                init(_ blendMode: BlendMode.Resolvable) {
                    self.blendMode = blendMode
                }
            }
            
            @ASTDecodable("opacity")
            struct OpacityModifier: @preconcurrency Decodable {
                let opacity: Double.Resolvable
                
                init(_ opacity: Double.Resolvable) {
                    self.opacity = opacity
                }
            }
            
            @ASTDecodable("shadow")
            struct ShadowModifier: @preconcurrency Decodable {
                let style: ShadowStyle.Resolvable
                
                init(_ style: ShadowStyle.Resolvable) {
                    self.style = style
                }
            }
            
            enum HierarchicalModifier: String, Decodable {
                case secondary
                case tertiary
                case quaternary
                case quinary
            }
            
            init(from decoder: any Decoder) throws {
                let container = try decoder.singleValueContainer()
                
                if let modifier = try? container.decode(HierarchicalModifier.self) {
                    self = .hierarchical(modifier)
                } else if let modifier = try? container.decode(BlendModeModifier.self) {
                    self = .blendMode(modifier)
                } else if let modifier = try? container.decode(OpacityModifier.self) {
                    self = .opacity(modifier)
                } else {
                    self = .shadow(try container.decode(ShadowModifier.self))
                }
            }
        }
        
        init(from decoder: any Decoder) throws {
            var container = try decoder.unkeyedContainer()
            
            _ = try container.decode(ASTNode.Identifiers.MemberAccess.self)
            let annotations = try container.decode(Annotations.self)
            var arguments = try container.nestedUnkeyedContainer()
            
            self.base = try arguments.decode(StylesheetResolvableShapeStyle.self)
            self.modifier = try arguments.decode(Modifier.self)
        }
        
        func resolve(
            on element: ElementNode,
            in context: LiveContext<some RootRegistry>
        ) -> AnyShapeStyle {
            let base = base.resolve(on: element, in: context)
            switch modifier {
            case let .hierarchical(hierarchical):
                if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
                    switch hierarchical {
                    case .secondary:
                        return AnyShapeStyle(base.secondary)
                    case .tertiary:
                        return AnyShapeStyle(base.tertiary)
                    case .quaternary:
                        return AnyShapeStyle(base.quaternary)
                    case .quinary:
                        return AnyShapeStyle(base.quinary)
                    }
                } else {
                    return base
                }
            case let .blendMode(blendMode):
                return AnyShapeStyle(base.blendMode(blendMode.blendMode.resolve(on: element, in: context)))
            case let .opacity(opacity):
                return AnyShapeStyle(base.opacity(opacity.opacity.resolve(on: element, in: context)))
            case let .shadow(shadow):
                return AnyShapeStyle(base.shadow(shadow.style.resolve(on: element, in: context)))
            }
        }
    }
    
    @ASTDecodable("ShapeStyle")
    enum MaterialShapeStyle: StylesheetResolvable, @preconcurrency Decodable {
        case regularMaterial
        case thickMaterial
        case thinMaterial
        case ultraThinMaterial
        case ultraThickMaterial
        #if os(iOS) || os(macOS) || os(visionOS)
        @available(tvOS, unavailable)
        @available(watchOS, unavailable)
        case bar
        #endif
        
        func resolve<R>(on element: ElementNode, in context: LiveContext<R>) -> Material where R : RootRegistry {
            if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *) {
                switch self {
                case .regularMaterial:
                    return .regular
                case .thickMaterial:
                    return .thick
                case .thinMaterial:
                    return .thin
                case .ultraThinMaterial:
                    return .ultraThin
                case .ultraThickMaterial:
                    return .ultraThick
                #if os(iOS) || os(macOS) || os(visionOS)
                case .bar:
                    return .bar
                #endif
                }
            } else {
                fatalError("`Material` is not supported on this platform/version")
            }
        }
    }
    
    @ASTDecodable("ShapeStyle")
    enum SemanticShapeStyle: @preconcurrency Decodable {
        case foreground
        case background
        #if os(iOS) || os(macOS) || os(visionOS)
        @available(tvOS, unavailable)
        @available(watchOS, unavailable)
        case selection
        #endif
        case separator
        case tint
        case placeholder
        case link
        case fill
        case windowBackground
        
        func resolve() -> AnyShapeStyle {
            switch self {
            case .foreground:
                return AnyShapeStyle(ForegroundStyle())
            case .background:
                return AnyShapeStyle(BackgroundStyle())
            #if os(iOS) || os(macOS) || os(visionOS)
            case .selection:
                if #available(iOS 15.0, macOS 10.15, *) {
                    return AnyShapeStyle(SelectionShapeStyle())
                } else {
                    return AnyShapeStyle(ForegroundStyle())
                }
            #endif
            case .separator:
                if #available(iOS 17.0, macOS 10.15, tvOS 17.0, watchOS 10.0, *) {
                    return AnyShapeStyle(SeparatorShapeStyle())
                } else {
                    return AnyShapeStyle(ForegroundStyle())
                }
            case .tint:
                return AnyShapeStyle(TintShapeStyle())
            case .placeholder:
                if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
                    return AnyShapeStyle(PlaceholderTextShapeStyle())
                } else {
                    return AnyShapeStyle(ForegroundStyle())
                }
            case .link:
                if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
                    return AnyShapeStyle(LinkShapeStyle())
                } else {
                    return AnyShapeStyle(ForegroundStyle())
                }
            case .fill:
                if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
                    return AnyShapeStyle(FillShapeStyle())
                } else {
                    return AnyShapeStyle(ForegroundStyle())
                }
            case .windowBackground:
                if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
                    return AnyShapeStyle(WindowBackgroundShapeStyle())
                } else {
                    return AnyShapeStyle(ForegroundStyle())
                }
            }
        }
    }
    
    init(from decoder: any Decoder) throws {
        var container = try decoder.singleValueContainer()
        
        if let color = try? container.decode(Color.Resolvable.self) {
            self = .color(color)
            return
        } else if let linearGradient = try? container.decode(LinearGradient.Resolvable.self) {
            self = .linearGradient(linearGradient)
            return
        } else if let angularGradient = try? container.decode(AngularGradient.Resolvable.self) {
            self = .angularGradient(angularGradient)
            return
        } else if let radialGradient = try? container.decode(RadialGradient.Resolvable.self) {
            self = .radialGradient(radialGradient)
            return
        } else if let material = try? container.decode(MaterialShapeStyle.self) {
            self = .material(material)
            return
        } else if let imagePaint = try? container.decode(ImagePaint.Resolvable.self) {
            self = .imagePaint(imagePaint)
            return
        } else if let hierarchical = try? container.decode(HierarchicalShapeStyle.Resolvable.self) {
            self = .hierarchical(hierarchical)
            return
        } else if let semantic = try? container.decode(SemanticShapeStyle.self) {
            self = .semantic(semantic)
            return
        } else if let modified = try? container.decode(ModifiedShapeStyle.self) {
            self = .modified(modified)
            return
        }
        
        throw MultipleFailures([])
    }
}

extension StylesheetResolvableShapeStyle {
    func resolve(in environment: EnvironmentValues) -> AnyShapeStyle {
        return AnyShapeStyle(.red)
    }
    
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Resolved {
        switch self {
        case let .semantic(semantic):
            return semantic.resolve()
        case let .hierarchical(hierarchical):
            return AnyShapeStyle(hierarchical.resolve(on: element, in: context))
        case let .color(color):
            return AnyShapeStyle(color.resolve(on: element, in: context))
        case let .angularGradient(angularGradient):
            return AnyShapeStyle(angularGradient.resolve(on: element, in: context))
        case let .linearGradient(linearGradient):
            return AnyShapeStyle(linearGradient.resolve(on: element, in: context))
        case let .radialGradient(radialGradient):
            return AnyShapeStyle(radialGradient.resolve(on: element, in: context))
        case let .imagePaint(imagePaint):
            return AnyShapeStyle(imagePaint.resolve(on: element, in: context))
        case let .material(material):
            return AnyShapeStyle(material.resolve(on: element, in: context))
        case let .modified(modified):
            return modified.resolve(on: element, in: context)
        }
    }
}

extension StylesheetResolvableShapeStyle: @preconcurrency AttributeDecodable {
    init(from attribute: Attribute?, on element: ElementNode) throws {
        fatalError()
    }
}

extension HierarchicalShapeStyle {
    @ASTDecodable("HierarchicalShapeStyle")
    enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        case primary
        case secondary
        case tertiary
        case quaternary
        case quinary
        
        func resolve<R>(on element: ElementNode, in context: LiveContext<R>) -> HierarchicalShapeStyle where R : RootRegistry {
            switch self {
            case .primary:
                return .primary
            case .secondary:
                return .secondary
            case .tertiary:
                return .tertiary
            case .quaternary:
                return .quaternary
            case .quinary:
                if #available(iOS 16, macOS 12, tvOS 17, watchOS 10, *) {
                    return .quinary
                } else {
                    return .quaternary
                }
            }
        }
    }
}

extension AngularGradient {
    @ASTDecodable("AngularGradient")
    enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        case _angularGradient(gradient: Gradient.Resolvable, center: UnitPoint.Resolvable, startAngle: Angle.Resolvable, endAngle: Angle.Resolvable)
        case _angularColors(colors: [Color.Resolvable], center: UnitPoint.Resolvable, startAngle: Angle.Resolvable, endAngle: Angle.Resolvable)
        case _angularStops(stops: [Gradient.Stop.Resolvable], center: UnitPoint.Resolvable, startAngle: Angle.Resolvable, endAngle: Angle.Resolvable)
        case _conicGradient(gradient: Gradient.Resolvable, center: UnitPoint.Resolvable, angle: Angle.Resolvable)
        case _conicColors(colors: [Color.Resolvable], center: UnitPoint.Resolvable, angle: Angle.Resolvable)
        case _conicStops(stops: [Gradient.Stop.Resolvable], center: UnitPoint.Resolvable, angle: Angle.Resolvable)
        
        init(gradient: Gradient.Resolvable, center: UnitPoint.Resolvable = .__constant(.center), startAngle: Angle.Resolvable, endAngle: Angle.Resolvable) {
            self = ._angularGradient(gradient: gradient, center: center, startAngle: startAngle, endAngle: endAngle)
        }

        init(colors: [Color.Resolvable], center: UnitPoint.Resolvable = .__constant(.center), startAngle: Angle.Resolvable, endAngle: Angle.Resolvable) {
            self = ._angularColors(colors: colors, center: center, startAngle: startAngle, endAngle: endAngle)
        }

        init(stops: [Gradient.Stop.Resolvable], center: UnitPoint.Resolvable = .__constant(.center), startAngle: Angle.Resolvable, endAngle: Angle.Resolvable) {
            self = ._angularStops(stops: stops, center: center, startAngle: startAngle, endAngle: endAngle)
        }
        
        init(gradient: Gradient.Resolvable, center: UnitPoint.Resolvable, angle: Angle.Resolvable = .__constant(.zero)) {
            self = ._conicGradient(gradient: gradient, center: center, angle: angle)
        }

        init(colors: [Color.Resolvable], center: UnitPoint.Resolvable, angle: Angle.Resolvable = .__constant(.zero)) {
            self = ._conicColors(colors: colors, center: center, angle: angle)
        }

        init(stops: [Gradient.Stop.Resolvable], center: UnitPoint.Resolvable, angle: Angle.Resolvable = .__constant(.zero)) {
            self = ._conicStops(stops: stops, center: center, angle: angle)
        }
        
        static func angularGradient(_ gradient: Gradient.Resolvable, center: UnitPoint.Resolvable = .__constant(.center), startAngle: Angle.Resolvable, endAngle: Angle.Resolvable) -> Self {
            ._angularGradient(gradient: gradient, center: center, startAngle: startAngle, endAngle: endAngle)
        }
        static func angularGradient(colors: [Color.Resolvable], center: UnitPoint.Resolvable = .__constant(.center), startAngle: Angle.Resolvable, endAngle: Angle.Resolvable) -> Self {
            ._angularColors(colors: colors, center: center, startAngle: startAngle, endAngle: endAngle)
        }
        static func angularGradient(stops: [Gradient.Stop.Resolvable], center: UnitPoint.Resolvable = .__constant(.center), startAngle: Angle.Resolvable, endAngle: Angle.Resolvable) -> Self {
            ._angularStops(stops: stops, center: center, startAngle: startAngle, endAngle: endAngle)
        }
        
        static func conicGradient(_ gradient: Gradient.Resolvable, center: UnitPoint.Resolvable, angle: Angle.Resolvable = .__constant(.zero)) -> Self {
            ._conicGradient(gradient: gradient, center: center, angle: angle)
        }
        static func conicGradient(colors: [Color.Resolvable], center: UnitPoint.Resolvable, angle: Angle.Resolvable = .__constant(.zero)) -> Self {
            ._conicColors(colors: colors, center: center, angle: angle)
        }
        static func conicGradient(stops: [Gradient.Stop.Resolvable], center: UnitPoint.Resolvable, angle: Angle.Resolvable = .__constant(.zero)) -> Self {
            ._conicStops(stops: stops, center: center, angle: angle)
        }
        
        func resolve<R>(on element: ElementNode, in context: LiveContext<R>) -> AngularGradient where R : RootRegistry {
            switch self {
            case let ._angularGradient(gradient, center, startAngle, endAngle):
                return .init(
                    gradient: gradient.resolve(on: element, in: context),
                    center: center.resolve(on: element, in: context),
                    startAngle: startAngle.resolve(on: element, in: context),
                    endAngle: endAngle.resolve(on: element, in: context)
                )
            case let ._angularColors(colors, center, startAngle, endAngle):
                return .init(
                    colors: colors.resolve(on: element, in: context),
                    center: center.resolve(on: element, in: context),
                    startAngle: startAngle.resolve(on: element, in: context),
                    endAngle: endAngle.resolve(on: element, in: context)
                )
            case let ._angularStops(stops, center, startAngle, endAngle):
                return .init(
                    stops: stops.resolve(on: element, in: context),
                    center: center.resolve(on: element, in: context),
                    startAngle: startAngle.resolve(on: element, in: context),
                    endAngle: endAngle.resolve(on: element, in: context)
                )
            case let ._conicGradient(gradient, center, angle):
                return .init(
                    gradient: gradient.resolve(on: element, in: context),
                    center: center.resolve(on: element, in: context),
                    angle: angle.resolve(on: element, in: context)
                )
            case let ._conicColors(colors, center, angle):
                return .init(
                    colors: colors.resolve(on: element, in: context),
                    center: center.resolve(on: element, in: context),
                    angle: angle.resolve(on: element, in: context)
                )
            case let ._conicStops(stops, center, angle):
                return .init(
                    stops: stops.resolve(on: element, in: context),
                    center: center.resolve(on: element, in: context),
                    angle: angle.resolve(on: element, in: context)
                )
            }
        }
    }
}

extension LinearGradient {
    @ASTDecodable("LinearGradient")
    enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        case _initGradient(gradient: Gradient.Resolvable, startPoint: UnitPoint.Resolvable, endPoint: UnitPoint.Resolvable)
        case _initColors(colors: [Color.Resolvable], startPoint: UnitPoint.Resolvable, endPoint: UnitPoint.Resolvable)
        case _initStops(stops: [Gradient.Stop.Resolvable], startPoint: UnitPoint.Resolvable, endPoint: UnitPoint.Resolvable)
        
        init(gradient: Gradient.Resolvable, startPoint: UnitPoint.Resolvable, endPoint: UnitPoint.Resolvable) {
            self = ._initGradient(gradient: gradient, startPoint: startPoint, endPoint: endPoint)
        }

        init(colors: [Color.Resolvable], startPoint: UnitPoint.Resolvable, endPoint: UnitPoint.Resolvable) {
            self = ._initColors(colors: colors, startPoint: startPoint, endPoint: endPoint)
        }

        init(stops: [Gradient.Stop.Resolvable], startPoint: UnitPoint.Resolvable, endPoint: UnitPoint.Resolvable) {
            self = ._initStops(stops: stops, startPoint: startPoint, endPoint: endPoint)
        }
        
        static func linearGradient(_ gradient: Gradient.Resolvable, startPoint: UnitPoint.Resolvable, endPoint: UnitPoint.Resolvable) -> Self {
            ._initGradient(gradient: gradient, startPoint: startPoint, endPoint: endPoint)
        }
        static func linearGradient(colors: [Color.Resolvable], startPoint: UnitPoint.Resolvable, endPoint: UnitPoint.Resolvable) -> Self {
            ._initColors(colors: colors, startPoint: startPoint, endPoint: endPoint)
        }
        static func linearGradient(stops: [Gradient.Stop.Resolvable], startPoint: UnitPoint.Resolvable, endPoint: UnitPoint.Resolvable) -> Self {
            ._initStops(stops: stops, startPoint: startPoint, endPoint: endPoint)
        }
        
        func resolve<R>(on element: ElementNode, in context: LiveContext<R>) -> LinearGradient where R : RootRegistry {
            switch self {
            case ._initGradient(let gradient, let startPoint, let endPoint):
                return .init(
                    gradient: gradient.resolve(on: element, in: context),
                    startPoint: startPoint.resolve(on: element, in: context),
                    endPoint: endPoint.resolve(on: element, in: context)
                )
            case ._initColors(let colors, let startPoint, let endPoint):
                return .init(
                    colors: colors.resolve(on: element, in: context),
                    startPoint: startPoint.resolve(on: element, in: context),
                    endPoint: endPoint.resolve(on: element, in: context)
                )
            case ._initStops(let stops, let startPoint, let endPoint):
                return .init(
                    stops: stops.resolve(on: element, in: context),
                    startPoint: startPoint.resolve(on: element, in: context),
                    endPoint: endPoint.resolve(on: element, in: context)
                )
            }
        }
    }
}

extension RadialGradient {
    @ASTDecodable("RadialGradient")
    enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        case _initGradient(gradient: Gradient.Resolvable, center: UnitPoint.Resolvable, startRadius: CGFloat.Resolvable, endRadius: CGFloat.Resolvable)
        case _initColors(colors: [Color.Resolvable], center: UnitPoint.Resolvable, startRadius: CGFloat.Resolvable, endRadius: CGFloat.Resolvable)
        case _initStops(stops: [Gradient.Stop.Resolvable], center: UnitPoint.Resolvable, startRadius: CGFloat.Resolvable, endRadius: CGFloat.Resolvable)
        
        init(gradient: Gradient.Resolvable, center: UnitPoint.Resolvable, startRadius: CGFloat.Resolvable, endRadius: CGFloat.Resolvable) {
            self = ._initGradient(gradient: gradient, center: center, startRadius: startRadius, endRadius: endRadius)
        }

        init(colors: [Color.Resolvable], center: UnitPoint.Resolvable, startRadius: CGFloat.Resolvable, endRadius: CGFloat.Resolvable) {
            self = ._initColors(colors: colors, center: center, startRadius: startRadius, endRadius: endRadius)
        }

        init(stops: [Gradient.Stop.Resolvable], center: UnitPoint.Resolvable, startRadius: CGFloat.Resolvable, endRadius: CGFloat.Resolvable) {
            self = ._initStops(stops: stops, center: center, startRadius: startRadius, endRadius: endRadius)
        }
        
        static func radialGradient(_ gradient: Gradient.Resolvable, center: UnitPoint.Resolvable = .__constant(.center), startRadius: CGFloat.Resolvable = .__constant(0), endRadius: CGFloat.Resolvable) -> Self {
            ._initGradient(gradient: gradient, center: center, startRadius: startRadius, endRadius: endRadius)
        }
        static func radialGradient(colors: [Color.Resolvable], center: UnitPoint.Resolvable = .__constant(.center), startRadius: CGFloat.Resolvable = .__constant(0), endRadius: CGFloat.Resolvable) -> Self {
            ._initColors(colors: colors, center: center, startRadius: startRadius, endRadius: endRadius)
        }
        static func radialGradient(stops: [Gradient.Stop.Resolvable], center: UnitPoint.Resolvable = .__constant(.center), startRadius: CGFloat.Resolvable = .__constant(0), endRadius: CGFloat.Resolvable) -> Self {
            ._initStops(stops: stops, center: center, startRadius: startRadius, endRadius: endRadius)
        }
        
        func resolve<R>(on element: ElementNode, in context: LiveContext<R>) -> RadialGradient where R : RootRegistry {
            switch self {
            case ._initGradient(let gradient, let center, let startRadius, let endRadius):
                return .init(
                    gradient: gradient.resolve(on: element, in: context),
                    center: center.resolve(on: element, in: context),
                    startRadius: startRadius.resolve(on: element, in: context),
                    endRadius: endRadius.resolve(on: element, in: context)
                )
            case ._initColors(let colors, let center, let startRadius, let endRadius):
                return .init(
                    colors: colors.resolve(on: element, in: context),
                    center: center.resolve(on: element, in: context),
                    startRadius: startRadius.resolve(on: element, in: context),
                    endRadius: endRadius.resolve(on: element, in: context)
                )
            case ._initStops(let stops, let center, let startRadius, let endRadius):
                return .init(
                    stops: stops.resolve(on: element, in: context),
                    center: center.resolve(on: element, in: context),
                    startRadius: startRadius.resolve(on: element, in: context),
                    endRadius: endRadius.resolve(on: element, in: context)
                )
            }
        }
    }
}

extension ImagePaint {
    @ASTDecodable("ImagePaint")
    enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        case _init(image: Image.Resolvable, sourceRect: CGRect.Resolvable, scale: CGFloat.Resolvable)
        
        init(image: Image.Resolvable, sourceRect: CGRect.Resolvable = .__constant(CGRect(x: 0, y: 0, width: 1, height: 1)), scale: CGFloat.Resolvable = .__constant(1)) {
            self = ._init(image: image, sourceRect: sourceRect, scale: scale)
        }
        
        static func image(_ image: Image.Resolvable, sourceRect: CGRect.Resolvable = .__constant(CGRect(x: 0, y: 0, width: 1, height: 1)), scale: CGFloat.Resolvable = .__constant(1)) -> Self {
            ._init(image: image, sourceRect: sourceRect, scale: scale)
        }
        
        func resolve<R>(on element: ElementNode, in context: LiveContext<R>) -> ImagePaint where R : RootRegistry {
            switch self {
            case let ._init(image, sourceRect, scale):
                return .init(
                    image: image.resolve(on: element, in: context),
                    sourceRect: sourceRect.resolve(on: element, in: context),
                    scale: scale.resolve(on: element, in: context)
                )
            }
        }
    }
}

extension ShadowStyle {
    @ASTDecodable("ShadowStyle")
    enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        case __constant(ShadowStyle)
        case _drop(
            color: Color.Resolvable,
            radius: CGFloat.Resolvable,
            x: CGFloat.Resolvable,
            y: CGFloat.Resolvable
        )
        case _inner(
            color: Color.Resolvable,
            radius: CGFloat.Resolvable,
            x: CGFloat.Resolvable,
            y: CGFloat.Resolvable
        )
        
        static func drop(
            color: Color.Resolvable = .__constant(Color(.sRGBLinear, white: 0, opacity: 0.33)),
            radius: CGFloat.Resolvable,
            x: CGFloat.Resolvable = .__constant(0),
            y: CGFloat.Resolvable = .__constant(0)
        ) -> Self {
            ._drop(color: color, radius: radius, x: x, y: y)
        }
        
        static func inner(
            color: Color.Resolvable = .__constant(Color(.sRGBLinear, white: 0, opacity: 0.55)),
            radius: CGFloat.Resolvable,
            x: CGFloat.Resolvable = .__constant(0),
            y: CGFloat.Resolvable = .__constant(0)
        ) -> Self {
            ._inner(color: color, radius: radius, x: x, y: y)
        }
        
        func resolve<R>(on element: ElementNode, in context: LiveContext<R>) -> ShadowStyle where R : RootRegistry {
            switch self {
            case .__constant(let style):
                return style
            case ._drop(let color, let radius, let x, let y):
                return .drop(
                    color: color.resolve(on: element, in: context),
                    radius: radius.resolve(on: element, in: context),
                    x: x.resolve(on: element, in: context),
                    y: y.resolve(on: element, in: context)
                )
            case ._inner(let color, let radius, let x, let y):
                return .inner(
                    color: color.resolve(on: element, in: context),
                    radius: radius.resolve(on: element, in: context),
                    x: x.resolve(on: element, in: context),
                    y: y.resolve(on: element, in: context)
                )
            }
        }
    }
}
