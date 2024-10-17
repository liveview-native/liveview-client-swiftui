//
//  AnyShapeStyle+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 10/17/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.ShapeStyle`](https://developer.apple.com/documentation/swiftui/ShapeStyle) for more details.
///
/// A color/pattern used to render content.
///
/// ### Colors
/// See ``SwiftUI/Color`` for more details on available color styles.
///
/// ### Hierarchical Styles
/// A level of the foreground style.
///
/// Possible values:
/// - `.primary`
/// - `.secondary`
/// - `.tertiary`
/// - `.quaternary`
/// - `.quinary`
///
/// Hierarchical styles can also be applied to another style to modify it.
///
/// ```swift
/// .blue.secondary
/// .tint.tertiary
/// ```
///
/// ### Materials
/// A background blur effect.
///
/// Possible values:
/// - `.ultraThinMaterial`
/// - `.thinMaterial`
/// - `.regularMaterial`
/// - `.thickMaterial`
/// - `.ultraThickMaterial`
/// - `.bar`
///
/// ### Semantic Styles
/// Styles with a semantic meaning.
/// These styles can typically be set with a modifier, such as ``_tintModifier`` or ``ForegroundStyleModifier``.
///
/// Possible values:
/// - `.foreground`
/// - `.background`
/// - `.selection`
/// - `.tint`
/// - `.separator`
/// - `.placeholder`
/// - `.link`
/// - `.fill`
/// - `.windowBackground`
///
/// ### Image Paint
/// Use an ``SwiftUI/Image`` as a style.
///
/// ```swift
/// .image(Image("MyImage"))
/// .image(Image(systemName: "circle.fill"), sourceRect: CGRect(x: 10, y: 10, width: 50, height: 50), scale: 0.5)
/// ```
///
/// ### Gradients
/// See ``SwiftUI/Gradient`` for more details on creating gradient styles.
///
/// ### Angular Gradients
/// Create a gradient with a ``SwiftUI/UnitPoint`` `center`, a `start`/`end` ``SwiftUI/Angle``, and a set of ``SwiftUI/Color`` values or gradient ``SwiftUI/Gradient/Stop`` points.
///
/// ```swift
/// .angularGradient(colors: [.red, .blue], startAngle: .zero, endAngle: .degrees(180))
/// .angularGradient(stops: [Gradient.Stop(color: .red, location: 0), Gradient.Stop(color: .red, location: 1)], center: .bottom, startAngle: .radians(0), endPoint: .radians(3.14))
/// .angularGradient(Gradient(colors: [.red, .blue]), startAngle: .degrees(-180), endPoint: .degrees(90))
/// ```
///
/// ### Conic Gradients
/// Create a gradient with a ``SwiftUI/UnitPoint`` `center`, an ``SwiftUI/Angle``, and a set of ``SwiftUI/Color`` values or gradient ``SwiftUI/Gradient/Stop`` points.
///
/// ```swift
/// .conicGradient(colors: [.red, .blue], center: .center)
/// .conicGradient(stops: [Gradient.Stop(color: .red, location: 0), Gradient.Stop(color: .red, location: 1)], center: .bottom)
/// .conicGradient(Gradient(colors: [.red, .blue]), center: .top, angle: .degrees(90))
/// ```
///
/// ### Elliptical Gradients
/// Create a gradient with a ``SwiftUI/UnitPoint`` `center`, a start/end radius fraction, and a set of ``SwiftUI/Color`` values or gradient ``SwiftUI/Gradient/Stop`` points.
///
/// ```swift
/// .ellipticalGradient(colors: [.red, .blue])
/// .ellipticalGradient(stops: [Gradient.Stop(color: .red, location: 0), Gradient.Stop(color: .red, location: 1)], endRadiusFraction: 1)
/// .ellipticalGradient(Gradient(colors: [.red, .blue]), center: .bottom, startRadiusFraction: 0.5, endRadiusFraction: 0.75)
/// ```
///
/// ### Linear Gradients
/// Create a gradient with ``SwiftUI/UnitPoint`` start/end points, and a set of ``SwiftUI/Color`` values or gradient ``SwiftUI/Gradient/Stop`` points.
///
/// ```swift
/// .linearGradient(colors: [.red, .blue], startPoint: .leading, endPoint: .trailing)
/// .linearGradient(stops: [Gradient.Stop(color: .red, location: 0), Gradient.Stop(color: .red, location: 1)], startPoint: .topLeading, endPoint: .bottomTrailing)
/// .linearGradient(Gradient(colors: [.red, .blue]), startPoint: .top, endPoint: .bottom)
/// ```
///
/// ### Radial Gradients
/// Create a gradient with a ``SwiftUI/UnitPoint`` `center`, a start/end radius, and a set of ``SwiftUI/Color`` values or gradient ``SwiftUI/Gradient/Stop`` points.
///
/// ```swift
/// .radialGradient(colors: [.red, .blue], center: .bottom, startRadius: 0, endRadius: 50)
/// .radialGradient(stops: [Gradient.Stop(color: .red, location: 0), Gradient.Stop(color: .red, location: 1)], center: .center, startRadius: 25, endRadius: 75)
/// .radialGradient(Gradient(colors: [.red, .blue]), center: .bottom, startRadiusFraction: 0.5, endRadiusFraction: 0.75, center: .top, startRadius: 0, endRadius: 50)
/// ```
///
/// ### Blend Mode
/// Pass a ``SwiftUI/BlendMode`` to be used as a style, or applied to another style.
///
/// ```swift
/// .blendMode(.multiply)
/// .blue.blendMode(.softLight)
/// ```
///
/// ### Opacity
/// Pass an opacity amount to be used as a style, or applied to another style.
///
/// ```swift
/// .opacity(0.5)
/// .blue.opacity(0.8)
/// ```
///
/// ### Shadow
/// Pass a ``SwiftUI/ShadowStyle`` to be used as a style, or applied to another style.
///
/// ```swift
/// .shadow(.drop(radius: 10))
/// .blue.shadow(.inner(radius: 8, y: 8))
/// ```
@_documentation(visibility: public)
public extension AnyShapeStyle {
    struct Resolvable: ParseableModifierValue {
        enum Storage {
            case value(AnyShapeStyle)
            case color(Color.Resolvable)
            
            case gradient(Gradient.Resolvable)
            case anyGradient(AnyGradient.Resolvable)
            
            case angularGradient(_angularGradient)
            case conicGradient(_conicGradient)
            case ellipticalGradient(_ellipticalGradient)
            case linearGradient(_linearGradient)
            case radialGradient(_radialGradient)
            
            case modifier(StyleModifier)
            
            init(_ style: some ShapeStyle) {
                self = .value(AnyShapeStyle(style))
            }
        }
        
        let storage: Storage
        let modifiers: [StyleModifier]
        
        @MainActor
        public func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> AnyShapeStyle {
            let base: any ShapeStyle = switch storage {
            case .value(let value):
                value
            case .color(let color):
                color.resolve(on: element, in: context)
            case let .gradient(gradient):
                gradient.resolve(on: element, in: context)
            case let .anyGradient(gradient):
                gradient.resolve(on: element, in: context)
            case let .angularGradient(gradient):
                gradient.resolve(on: element, in: context)
            case let .conicGradient(gradient):
                gradient.resolve(on: element, in: context)
            case let .ellipticalGradient(gradient):
                gradient.resolve(on: element, in: context)
            case let .linearGradient(gradient):
                gradient.resolve(on: element, in: context)
            case let .radialGradient(gradient):
                gradient.resolve(on: element, in: context)
            case let .modifier(modifier):
                modifier.resolve(on: element, in: context)
            }
            return modifiers.reduce(AnyShapeStyle(base)) {
                AnyShapeStyle($1.apply(to: $0, on: element, in: context))
            }
        }
        
        public init(_ constant: AnyShapeStyle) {
            self.storage = .value(constant)
            self.modifiers = []
        }
        
        public init(_ constant: some ShapeStyle) {
            self.storage = .value(AnyShapeStyle(constant))
            self.modifiers = []
        }
        
        init(storage: Storage, modifiers: [StyleModifier]) {
            self.storage = storage
            self.modifiers = modifiers
        }
        
        public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
            OneOf {
                _ColorParser(context: context) {
                    StyleModifier.parser(in: context)
                }
                .map({ (base: Color.Resolvable, members: [StyleModifier]) in
                    Self(storage: .color(base), modifiers: members)
                })
                ChainedMemberExpression {
                    baseParser(in: context)
                } member: {
                    StyleModifier.parser(in: context)
                }
                .map({ (base: Storage, members: [StyleModifier]) in
                    Self(storage: base, modifiers: members)
                })
            }
        }
        
        static func baseParser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Storage> {
            BaseParser(context: context)
        }
        
        private struct BaseParser: Parser {
            let context: ParseableModifierContext
            
            func parse(_ input: inout Substring.UTF8View) throws -> Storage {
                var parsers: [AnyParser<Substring.UTF8View, Storage>] = [
                    Color.Resolvable.parser(in: context).map(Storage.color).eraseToAnyParser(),
                    HierarchicalShapeStyle.parser(in: context).map({ Storage($0) }).eraseToAnyParser(),
                    
                    Material.parser(in: context).map({ Storage($0) }).eraseToAnyParser(),
                    
                    ConstantAtomLiteral("foreground").map({ Storage(ForegroundStyle()) }).eraseToAnyParser(),
                    ConstantAtomLiteral("background").map({ Storage(BackgroundStyle()) }).eraseToAnyParser(),
                    
                    ImagePaint.parser(in: context).map({ Storage($0) }).eraseToAnyParser(),
                    _image.parser(in: context).map({ Storage($0.value) }).eraseToAnyParser(),
                    
                    Gradient.Resolvable.parser(in: context).map({ Storage.gradient($0) }).eraseToAnyParser(),
                    AnyGradient.Resolvable.parser(in: context).map({ Storage.anyGradient($0) }).eraseToAnyParser(),
                    
                    _angularGradient.parser(in: context).map({ Storage.angularGradient($0) }).eraseToAnyParser(),
                    _conicGradient.parser(in: context).map({ Storage.conicGradient($0) }).eraseToAnyParser(),
                    
                    _ellipticalGradient.parser(in: context).map({ Storage.ellipticalGradient($0) }).eraseToAnyParser(),
                    
                    _linearGradient.parser(in: context).map({ Storage.linearGradient($0) }).eraseToAnyParser(),
                    
                    _radialGradient.parser(in: context).map({ Storage.radialGradient($0) }).eraseToAnyParser(),
                    
                    StyleModifier.parser(in: context).map({ Storage.modifier($0) }).eraseToAnyParser(),
                ]
#if !os(watchOS) && !os(tvOS)
                parsers.append(ConstantAtomLiteral("selection").map({ Storage(SelectionShapeStyle()) }).eraseToAnyParser())
#endif
                parsers.append(ConstantAtomLiteral("tint").map({ Storage(TintShapeStyle()) }).eraseToAnyParser())
                if #available(iOS 17, macOS 14, tvOS 17, watchOS 10, visionOS 1, *) {
                    parsers.append(ConstantAtomLiteral("separator").map({ Storage(SeparatorShapeStyle()) }).eraseToAnyParser())
                    parsers.append(ConstantAtomLiteral("placeholder").map({ Storage(PlaceholderTextShapeStyle()) }).eraseToAnyParser())
                    parsers.append(ConstantAtomLiteral("link").map({ Storage(LinkShapeStyle()) }).eraseToAnyParser())
                    parsers.append(ConstantAtomLiteral("fill").map({ Storage(FillShapeStyle()) }).eraseToAnyParser())
                }
#if !os(visionOS)
                if #available(iOS 17, macOS 14, tvOS 17, watchOS 10, *) {
                    parsers.append(ConstantAtomLiteral("windowBackground").map({ Storage(WindowBackgroundShapeStyle()) }).eraseToAnyParser())
                }
#endif
                
                let copy = input
                for parser in parsers {
                    if let value = try? parser.parse(&input) {
                        return value
                    } else {
                        input = copy
                    }
                }
                throw ArgumentParseError.unknownArgument("AnyShapeStyle")
            }
        }
        
        @ParseableExpression
        enum _angularGradient {
            static let name = "angularGradient"
            
            case anyGradient(gradient: AnyGradient.Resolvable, center: AttributeReference<UnitPoint>, startAngle: AttributeReference<Angle>, endAngle: AttributeReference<Angle>)
            case gradient(gradient: Gradient.Resolvable, center: AttributeReference<UnitPoint>, startAngle: AttributeReference<Angle>, endAngle: AttributeReference<Angle>)
            case colors(colors: [Color.Resolvable], center: AttributeReference<UnitPoint>, startAngle: AttributeReference<Angle>, endAngle: AttributeReference<Angle>)
            case stops(stops: [Gradient.Stop.Resolvable], center: AttributeReference<UnitPoint>, startAngle: AttributeReference<Angle>, endAngle: AttributeReference<Angle>)
            
            init(
                _ gradient: AnyGradient.Resolvable,
                center: AttributeReference<UnitPoint> = .init(.center),
                startAngle: AttributeReference<Angle>,
                endAngle: AttributeReference<Angle>
            ) {
                self = .anyGradient(gradient: gradient, center: center, startAngle: startAngle, endAngle: endAngle)
            }
            
            init(
                _ gradient: Gradient.Resolvable,
                center: AttributeReference<UnitPoint> = .init(.center),
                startAngle: AttributeReference<Angle>,
                endAngle: AttributeReference<Angle>
            ) {
                self = .gradient(gradient: gradient, center: center, startAngle: startAngle, endAngle: endAngle)
            }
            
            init(
                colors: [Color.Resolvable],
                center: AttributeReference<UnitPoint>,
                startAngle: AttributeReference<Angle>,
                endAngle: AttributeReference<Angle>
            ) {
                self = .colors(colors: colors, center: center, startAngle: startAngle, endAngle: endAngle)
            }
            
            init(
                stops: [Gradient.Stop.Resolvable],
                center: AttributeReference<UnitPoint> = .init(.center),
                startAngle: AttributeReference<Angle>,
                endAngle: AttributeReference<Angle>
            ) {
                self = .stops(stops: stops, center: center, startAngle: startAngle, endAngle: endAngle)
            }
            
            @MainActor
            func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> any ShapeStyle {
                switch self {
                case .anyGradient(let gradient, let center, let startAngle, let endAngle):
                    AngularGradient.angularGradient(gradient.resolve(on: element, in: context), center: center.resolve(on: element, in: context), startAngle: startAngle.resolve(on: element, in: context), endAngle: endAngle.resolve(on: element, in: context))
                case .gradient(let gradient, let center, let startAngle, let endAngle):
                    AngularGradient.angularGradient(gradient.resolve(on: element, in: context), center: center.resolve(on: element, in: context), startAngle: startAngle.resolve(on: element, in: context), endAngle: endAngle.resolve(on: element, in: context))
                case .colors(let colors, let center, let startAngle, let endAngle):
                    AngularGradient.angularGradient(colors: colors.map({ $0.resolve(on: element, in: context) }), center: center.resolve(on: element, in: context), startAngle: startAngle.resolve(on: element, in: context), endAngle: endAngle.resolve(on: element, in: context))
                case .stops(let stops, let center, let startAngle, let endAngle):
                    AngularGradient.angularGradient(stops: stops.map({ $0.resolve(on: element, in: context) }), center: center.resolve(on: element, in: context), startAngle: startAngle.resolve(on: element, in: context), endAngle: endAngle.resolve(on: element, in: context))
                }
            }
        }
        
        @ParseableExpression
        enum _conicGradient {
            static let name = "conicGradient"
            
            case anyGradient(gradient: AnyGradient.Resolvable, center: AttributeReference<UnitPoint>, angle: AttributeReference<Angle>)
            case gradient(gradient: Gradient.Resolvable, center: AttributeReference<UnitPoint>, angle: AttributeReference<Angle>)
            case colors(colors: [Color.Resolvable], center: AttributeReference<UnitPoint>, angle: AttributeReference<Angle>)
            case stops(stops: [Gradient.Stop.Resolvable], center: AttributeReference<UnitPoint>, angle: AttributeReference<Angle>)
            
            init(_ gradient: AnyGradient.Resolvable, center: AttributeReference<UnitPoint> = .init(.center), angle: AttributeReference<Angle> = .init(.zero)) {
                self = .anyGradient(gradient: gradient, center: center, angle: angle)
            }
            
            init(_ gradient: Gradient.Resolvable, center: AttributeReference<UnitPoint>, angle: AttributeReference<Angle> = .init(.zero)) {
                self = .gradient(gradient: gradient, center: center, angle: angle)
            }
            
            init(colors: [Color.Resolvable], center: AttributeReference<UnitPoint>, angle: AttributeReference<Angle> = .init(.zero)) {
                self = .colors(colors: colors, center: center, angle: angle)
            }
            
            init(stops: [Gradient.Stop.Resolvable], center: AttributeReference<UnitPoint>, angle: AttributeReference<Angle> = .init(.zero)) {
                self = .stops(stops: stops, center: center, angle: angle)
            }
            
            @MainActor
            func resolve(on element: ElementNode, in context: LiveContext<some RootRegistry>) -> any ShapeStyle {
                switch self {
                case .anyGradient(let gradient, let center, let angle):
                    AngularGradient.conicGradient(gradient.resolve(on: element, in: context), center: center.resolve(on: element, in: context), angle: angle.resolve(on: element, in: context))
                case .gradient(let gradient, let center, let angle):
                    AngularGradient.conicGradient(gradient.resolve(on: element, in: context), center: center.resolve(on: element, in: context), angle: angle.resolve(on: element, in: context))
                case .colors(let colors, let center, let angle):
                    AngularGradient.conicGradient(colors: colors.map({ $0.resolve(on: element, in: context) }), center: center.resolve(on: element, in: context), angle: angle.resolve(on: element, in: context))
                case .stops(let stops, let center, let angle):
                    AngularGradient.conicGradient(stops: stops.map({ $0.resolve(on: element, in: context) }), center: center.resolve(on: element, in: context), angle: angle.resolve(on: element, in: context))
                }
            }
        }
        
        @ParseableExpression
        enum _ellipticalGradient {
            static let name = "ellipticalGradient"
            
            case gradient(gradient: Gradient.Resolvable, center: AttributeReference<UnitPoint>, startRadiusFraction: AttributeReference<CGFloat>, endRadiusFraction: AttributeReference<CGFloat>)
            case colors(colors: [Color.Resolvable], center: AttributeReference<UnitPoint>, startRadiusFraction: AttributeReference<CGFloat>, endRadiusFraction: AttributeReference<CGFloat>)
            case stops(stops: [Gradient.Stop.Resolvable], center: AttributeReference<UnitPoint>, startRadiusFraction: AttributeReference<CGFloat>, endRadiusFraction: AttributeReference<CGFloat>)
            case anyGradient(gradient: AnyGradient.Resolvable, center: AttributeReference<UnitPoint>, startRadiusFraction: AttributeReference<CGFloat>, endRadiusFraction: AttributeReference<CGFloat>)
            
            init(_ gradient: Gradient.Resolvable, center: AttributeReference<UnitPoint> = .init(.center), startRadiusFraction: AttributeReference<CGFloat> = .init(0), endRadiusFraction: AttributeReference<CGFloat> = .init(0.5)) {
                self = .gradient(gradient: gradient, center: center, startRadiusFraction: startRadiusFraction, endRadiusFraction: endRadiusFraction)
            }
            
            init(colors: [Color.Resolvable], center: AttributeReference<UnitPoint> = .init(.center), startRadiusFraction: AttributeReference<CGFloat> = .init(0), endRadiusFraction: AttributeReference<CGFloat> = .init(0.5)) {
                self = .colors(colors: colors, center: center, startRadiusFraction: startRadiusFraction, endRadiusFraction: endRadiusFraction)
            }
            
            init(stops: [Gradient.Stop.Resolvable], center: AttributeReference<UnitPoint> = .init(.center), startRadiusFraction: AttributeReference<CGFloat> = .init(0), endRadiusFraction: AttributeReference<CGFloat> = .init(0.5)) {
                self = .stops(stops: stops, center: center, startRadiusFraction: startRadiusFraction, endRadiusFraction: endRadiusFraction)
            }
            
            init(_ gradient: AnyGradient.Resolvable, center: AttributeReference<UnitPoint> = .init(.center), startRadiusFraction: AttributeReference<CGFloat> = .init(0), endRadiusFraction: AttributeReference<CGFloat> = .init(0.5)) {
                self = .anyGradient(gradient: gradient, center: center, startRadiusFraction: startRadiusFraction, endRadiusFraction: endRadiusFraction)
            }
            
            @MainActor
            func resolve(on element: ElementNode, in context: LiveContext<some RootRegistry>) -> any ShapeStyle {
                switch self {
                case .gradient(let gradient, let center, let startRadiusFraction, let endRadiusFraction):
                    EllipticalGradient.ellipticalGradient(gradient.resolve(on: element, in: context), center: center.resolve(on: element, in: context), startRadiusFraction: startRadiusFraction.resolve(on: element, in: context), endRadiusFraction: endRadiusFraction.resolve(on: element, in: context))
                case .colors(let colors, let center, let startRadiusFraction, let endRadiusFraction):
                    EllipticalGradient.ellipticalGradient(colors: colors.map({ $0.resolve(on: element, in: context) }), center: center.resolve(on: element, in: context), startRadiusFraction: startRadiusFraction.resolve(on: element, in: context), endRadiusFraction: endRadiusFraction.resolve(on: element, in: context))
                case .stops(let stops, let center, let startRadiusFraction, let endRadiusFraction):
                    EllipticalGradient.ellipticalGradient(stops: stops.map({ $0.resolve(on: element, in: context) }), center: center.resolve(on: element, in: context), startRadiusFraction: startRadiusFraction.resolve(on: element, in: context), endRadiusFraction: endRadiusFraction.resolve(on: element, in: context))
                case .anyGradient(let gradient, let center, let startRadiusFraction, let endRadiusFraction):
                    EllipticalGradient.ellipticalGradient(gradient.resolve(on: element, in: context), center: center.resolve(on: element, in: context), startRadiusFraction: startRadiusFraction.resolve(on: element, in: context), endRadiusFraction: endRadiusFraction.resolve(on: element, in: context))
                }
            }
        }
        
        @ParseableExpression
        enum _linearGradient {
            static let name = "linearGradient"
            
            case gradient(gradient: Gradient.Resolvable, startPoint: AttributeReference<UnitPoint>, endPoint: AttributeReference<UnitPoint>)
            case colors(colors: [Color.Resolvable], startPoint: AttributeReference<UnitPoint>, endPoint: AttributeReference<UnitPoint>)
            case stops(stops: [Gradient.Stop.Resolvable], startPoint: AttributeReference<UnitPoint>, endPoint: AttributeReference<UnitPoint>)
            case anyGradient(gradient: AnyGradient.Resolvable, startPoint: AttributeReference<UnitPoint>, endPoint: AttributeReference<UnitPoint>)
            
            init(_ gradient: Gradient.Resolvable, startPoint: AttributeReference<UnitPoint>, endPoint: AttributeReference<UnitPoint>) {
                self = .gradient(gradient: gradient, startPoint: startPoint, endPoint: endPoint)
            }
            
            init(colors: [Color.Resolvable], startPoint: AttributeReference<UnitPoint>, endPoint: AttributeReference<UnitPoint>) {
                self = .colors(colors: colors, startPoint: startPoint, endPoint: endPoint)
            }
            
            init(stops: [Gradient.Stop.Resolvable], startPoint: AttributeReference<UnitPoint>, endPoint: AttributeReference<UnitPoint>) {
                self = .stops(stops: stops, startPoint: startPoint, endPoint: endPoint)
            }
            
            init(_ gradient: AnyGradient.Resolvable, startPoint: AttributeReference<UnitPoint>, endPoint: AttributeReference<UnitPoint>) {
                self = .anyGradient(gradient: gradient, startPoint: startPoint, endPoint: endPoint)
            }
            
            @MainActor
            func resolve(on element: ElementNode, in context: LiveContext<some RootRegistry>) -> any ShapeStyle {
                switch self {
                case .gradient(let gradient, let startPoint, let endPoint):
                    LinearGradient.linearGradient(gradient.resolve(on: element, in: context), startPoint: startPoint.resolve(on: element, in: context), endPoint: endPoint.resolve(on: element, in: context))
                case .colors(let colors, let startPoint, let endPoint):
                    LinearGradient.linearGradient(colors: colors.map({ $0.resolve(on: element, in: context) }), startPoint: startPoint.resolve(on: element, in: context), endPoint: endPoint.resolve(on: element, in: context))
                case .stops(let stops, let startPoint, let endPoint):
                    LinearGradient.linearGradient(stops: stops.map({ $0.resolve(on: element, in: context) }), startPoint: startPoint.resolve(on: element, in: context), endPoint: endPoint.resolve(on: element, in: context))
                case .anyGradient(let gradient, let startPoint, let endPoint):
                    LinearGradient.linearGradient(gradient.resolve(on: element, in: context), startPoint: startPoint.resolve(on: element, in: context), endPoint: endPoint.resolve(on: element, in: context))
                }
            }
        }
        
        @ParseableExpression
        enum _radialGradient {
            static let name = "radialGradient"
            
            case gradient(gradient: Gradient.Resolvable, center: AttributeReference<UnitPoint>, startRadius: AttributeReference<CGFloat>, endRadius: AttributeReference<CGFloat>)
            case colors(colors: [Color.Resolvable], center: AttributeReference<UnitPoint>, startRadius: AttributeReference<CGFloat>, endRadius: AttributeReference<CGFloat>)
            case stops(stops: [Gradient.Stop.Resolvable], center: AttributeReference<UnitPoint>, startRadius: AttributeReference<CGFloat>, endRadius: AttributeReference<CGFloat>)
            case anyGradient(gradient: AnyGradient.Resolvable, center: AttributeReference<UnitPoint>, startRadius: AttributeReference<CGFloat>, endRadius: AttributeReference<CGFloat>)
            
            init(
                _ gradient: Gradient.Resolvable,
                center: AttributeReference<UnitPoint>,
                startRadius: AttributeReference<CGFloat>,
                endRadius: AttributeReference<CGFloat>
            ) {
                self = .gradient(gradient: gradient, center: center, startRadius: startRadius, endRadius: endRadius)
            }
            
            init(
                colors: [Color.Resolvable],
                center: AttributeReference<UnitPoint>,
                startRadius: AttributeReference<CGFloat>,
                endRadius: AttributeReference<CGFloat>
            ) {
                self = .colors(colors: colors, center: center, startRadius: startRadius, endRadius: endRadius)
            }
            
            init(
                stops: [Gradient.Stop.Resolvable],
                center: AttributeReference<UnitPoint>,
                startRadius: AttributeReference<CGFloat>,
                endRadius: AttributeReference<CGFloat>
            ) {
                self = .stops(stops: stops, center: center, startRadius: startRadius, endRadius: endRadius)
            }
            
            init(
                _ gradient: AnyGradient.Resolvable,
                center: AttributeReference<UnitPoint> = .init(.center),
                startRadius: AttributeReference<CGFloat> = .init(0),
                endRadius: AttributeReference<CGFloat>
            ) {
                self = .anyGradient(gradient: gradient, center: center, startRadius: startRadius, endRadius: endRadius)
            }
            
            @MainActor
            func resolve(on element: ElementNode, in context: LiveContext<some RootRegistry>) -> any ShapeStyle {
                switch self {
                case .gradient(let gradient, let center, let startRadius, let endRadius):
                    RadialGradient.radialGradient(
                        gradient.resolve(on: element, in: context),
                        center: center.resolve(on: element, in: context),
                        startRadius: startRadius.resolve(on: element, in: context),
                        endRadius: endRadius.resolve(on: element, in: context)
                    )
                case .colors(let colors, let center, let startRadius, let endRadius):
                    RadialGradient.radialGradient(
                        colors: colors.map({ $0.resolve(on: element, in: context) }),
                        center: center.resolve(on: element, in: context),
                        startRadius: startRadius.resolve(on: element, in: context),
                        endRadius: endRadius.resolve(on: element, in: context)
                    )
                case .stops(let stops, let center, let startRadius, let endRadius):
                    RadialGradient.radialGradient(
                        stops: stops.map({ $0.resolve(on: element, in: context) }),
                        center: center.resolve(on: element, in: context),
                        startRadius: startRadius.resolve(on: element, in: context),
                        endRadius: endRadius.resolve(on: element, in: context)
                    )
                case .anyGradient(let gradient, let center, let startRadius, let endRadius):
                    RadialGradient.radialGradient(
                        gradient.resolve(on: element, in: context),
                        center: center.resolve(on: element, in: context),
                        startRadius: startRadius.resolve(on: element, in: context),
                        endRadius: endRadius.resolve(on: element, in: context)
                    )
                }
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
            case blendMode(_blendMode)
            case opacity(_opacity)
            case shadow(_shadow)
            case hierarchical(HierarchicalLevel)
            
            static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
                OneOf {
                    _blendMode.parser(in: context).map(Self.blendMode)
                    _opacity.parser(in: context).map(Self.opacity)
                    _shadow.parser(in: context).map(Self.shadow)
                    HierarchicalLevel.parser(in: context).map(Self.hierarchical)
                }
            }
            
            @ParseableExpression
            struct _blendMode {
                static let name = "blendMode"
                
                let value: BlendMode
                
                init(_ value: BlendMode) {
                    self.value = value
                }
            }
            
            @ParseableExpression
            struct _opacity {
                static let name = "opacity"
                
                let value: AttributeReference<Double>
                
                init(_ value: AttributeReference<Double>) {
                    self.value = value
                }
            }
            
            @ParseableExpression
            struct _shadow {
                static let name = "shadow"
                
                let value: _ShadowStyle
                
                init(_ value: _ShadowStyle) {
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
            
            /// Apply this modifier to an existing `ShapeStyle`.
            @MainActor
            func apply(to style: some ShapeStyle, on element: ElementNode, in context: LiveContext<some RootRegistry>) -> any ShapeStyle {
                switch self {
                case let .blendMode(blendMode):
                    return style.blendMode(blendMode.value)
                case let .opacity(opacity):
                    return style.opacity(opacity.value.resolve(on: element, in: context))
                case let .shadow(shadow):
                    return style.shadow(shadow.value.resolve(on: element, in: context))
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
            
            /// Use this modifier itself as a `ShapeStyle`. SwiftUI will apply it to the foreground style.
            @MainActor
            func resolve(on element: ElementNode, in context: LiveContext<some RootRegistry>) -> any ShapeStyle {
                switch self {
                case let .blendMode(blendMode):
                    return AnyShapeStyle(.blendMode(blendMode.value))
                case let .opacity(opacity):
                    return AnyShapeStyle(.opacity(opacity.value.resolve(on: element, in: context)))
                case let .shadow(shadow):
                    return AnyShapeStyle(.shadow(shadow.value.resolve(on: element, in: context)))
                case let .hierarchical(level):
                    switch level {
                    case .secondary:
                        return AnyShapeStyle(.secondary)
                    case .tertiary:
                        return AnyShapeStyle(.tertiary)
                    case .quaternary:
                        return AnyShapeStyle(.quaternary)
                    case .quinary:
                        if #available(iOS 16, macOS 12, tvOS 17, watchOS 10, visionOS 1, *) {
                            return AnyShapeStyle(.quinary)
                        } else {
                            return AnyShapeStyle(.quaternary)
                        }
                    }
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
            if #available(iOS 15, macOS 12, tvOS 15, watchOS 10, *) {
                ConstantAtomLiteral("ultraThinMaterial").map({ Self.ultraThinMaterial })
                ConstantAtomLiteral("thinMaterial").map({ Self.thinMaterial })
                ConstantAtomLiteral("regularMaterial").map({ Self.regularMaterial })
                ConstantAtomLiteral("thickMaterial").map({ Self.thickMaterial })
                ConstantAtomLiteral("ultraThickMaterial").map({ Self.ultraThickMaterial })
            }
            #if !os(watchOS) && !os(tvOS)
            if #available(iOS 15, macOS 12, visionOS 1.0, *) {
                ConstantAtomLiteral("bar").map({ Self.bar })
            }
            #endif
        }
    }
}
