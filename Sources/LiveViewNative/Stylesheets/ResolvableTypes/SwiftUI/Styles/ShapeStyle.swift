//
//  ShapeStyle.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/30/25.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

enum StylesheetResolvableShapeStyle: StylesheetResolvable, @preconcurrency ShapeStyle, @preconcurrency Decodable {
    typealias Resolved = AnyShapeStyle
    
    case color(Color.Resolvable)
    case angularGradient(AngularGradient.Resolvable)
    case linearGradient(LinearGradient.Resolvable)
    case radialGradient(RadialGradient.Resolvable)
    case material(MaterialShapeStyle)
    case imagePaint(ImagePaint.Resolvable)
    case hierarchical(HierarchicalShapeStyle.Resolvable)
    case semantic(SemanticShapeStyle)
    
    @ASTDecodable("ShapeStyle")
    enum MaterialShapeStyle: StylesheetResolvable, @preconcurrency Decodable {
        case regularMaterial
        case thickMaterial
        case thinMaterial
        case ultraThinMaterial
        case ultraThickMaterial
        case bar
        
        func resolve<R>(on element: ElementNode, in context: LiveContext<R>) -> Material where R : RootRegistry {
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
            case .bar:
                return .bar
            }
        }
    }
    
    @ASTDecodable("ShapeStyle")
    enum SemanticShapeStyle: @preconcurrency Decodable {
        case foreground
        case background
        #if os(iOS) || os(macOS)
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
            #if os(iOS) || os(macOS)
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
                if #available(iOS 17.0, macOS 10.15, tvOS 17.0, watchOS 10.0, *) {
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
                return .quinary
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
