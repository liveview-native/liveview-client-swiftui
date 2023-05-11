//
//  Shape.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI
import LiveViewNativeCore

/// A view that displays the a shape.
///
/// This view isn't used directly as an element. Instead, use the shape itself (e.g., `<Rectangle>`).
///
/// Attributes:
/// - ``fillColor``
/// - ``strokeColor``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct Shape<S: SwiftUI.InsettableShape>: View {
    @ObservedElement private var element: ElementNode
    private let shape: S

    /// The ``LiveViewNative/SwiftUI/Color`` the shape is filled with.
    ///
    /// See ``LiveViewNative/SwiftUI/Color/init?(fromNamedOrCSSHex:)`` for more details.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("fill-color") private var fillColor: SwiftUI.Color? = nil
    /// The ``LiveViewNative/SwiftUI/Color`` the shape stroke is drawn with.
    ///
    /// See ``LiveViewNative/SwiftUI/Color/init?(fromNamedOrCSSHex:)`` for more details.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("stroke-color") private var strokeColor: SwiftUI.Color? = nil
    
    @Attribute("modifiers") private var modifiers: ShapeModifierStack = .init([])
    
    init(shape: S) {
        self.shape = shape
    }
    
    var body: some View {
        let shape = modifiers.stack.reduce(EitherAnyShape.insettable(AnyInsettableShape(self.shape))) { shape, modifier in
            modifier.apply(to: shape)
        }
        if let final = modifiers.final
            ?? fillColor.flatMap({ FinalShapeModifier.fill(.init($0), style: .init()) })
            ?? strokeColor.flatMap({ FinalShapeModifier.stroke(.init($0), style: .init()) })
        {
            final.apply(to: shape)
        } else {
            switch shape {
            case let .shape(shape):
                shape
            case let .insettable(shape):
                shape
            }
        }
    }
}

/// A rounded rectangle shape.
///
/// ```html
/// <RoundedRectangle corner-radius="8" style="continuous" fill-color="#0000ff" />
/// ```
///
/// Attributes:
/// - `corner-radius` (double): The radius of the shape's corners.
/// - `corner-width` (double): The width of the shape's corners (has precedence over `corner-radius`).
/// - `corner-height` (double): The height of the shape's corners (has precedence over `corner-radius`).
/// - `style`: Whether the corners are rounded with the quarter-circle style or continuously. Possible values:
///     - `circular`
///     - `continuous`
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension RoundedRectangle {
    init(from element: ElementNode) {
        let radius = element.attributeValue(for: "corner-radius").flatMap(Double.init) ?? 0
        self.init(
            cornerSize: .init(
                width: element.attributeValue(for: "corner-width").flatMap(Double.init) ?? radius,
                height: element.attributeValue(for: "corner-height").flatMap(Double.init) ?? radius
            ),
            style: (element.attributeValue(for: "style").flatMap(RoundedCornerStyle.init) ?? .circular).style
        )
    }
}

/// A capsule shape. A capsule is a rounded rectangle where the corner size is half of the rectangle's smaller edge.
///
/// Attributes:
/// - `style`: Whether the corners are rounded with the quarter-circle style or continuously. Possible values:
///     - `circular`
///     - `continuous`
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension Capsule {
    init(from element: ElementNode) {
        self.init(
            style: (element.attributeValue(for: "style").flatMap(RoundedCornerStyle.init) ?? .circular).style
        )
    }
}

private enum RoundedCornerStyle: String {
    case circular
    case continuous
    
    var style: SwiftUI.RoundedCornerStyle {
        switch self {
        case .circular: return .circular
        case .continuous: return .continuous
        }
    }
}

enum ShapeModifier: Decodable {
    case inset(amount: CGFloat)
    case offset(x: CGFloat, y: CGFloat)
    case rotation(angle: Angle, anchor: UnitPoint)
    case size(width: CGFloat, height: CGFloat)
    case trim(startFraction: CGFloat, endFraction: CGFloat)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(ModifierType.self, forKey: .type) {
        case .inset:
            self = .inset(amount: try container.decode(CGFloat.self, forKey: .amount))
        case .offset:
            self = .offset(
                x: try container.decode(CGFloat.self, forKey: .x),
                y: try container.decode(CGFloat.self, forKey: .y)
            )
        case .rotation:
            self = .rotation(
                angle: try container.decode(Angle.self, forKey: .angle),
                anchor: try container.decodeIfPresent(UnitPoint.self, forKey: .anchor) ?? .center
            )
        case .size:
            self = .size(
                width: try container.decode(CGFloat.self, forKey: .width),
                height: try container.decode(CGFloat.self, forKey: .height)
            )
        case .trim:
            self = .trim(
                startFraction: try container.decode(CGFloat.self, forKey: .startFraction),
                endFraction: try container.decode(CGFloat.self, forKey: .endFraction)
            )
        }
    }
    
    enum CodingKeys: CodingKey {
        case type
        
        // inset
        case amount
        
        // offset
        case x
        case y
        
        // rotation
        case angle
        case anchor
        
        // size
        case width
        case height
        
        // trim
        case startFraction
        case endFraction
    }
    
    enum ModifierType: String, Decodable {
        case inset
        case offset = "offset_shape"
        case rotation
        case size
        case trim
    }
    
    func apply(to shape: EitherAnyShape) -> EitherAnyShape {
        switch self {
        case let .inset(amount):
            switch shape {
            case let .insettable(shape):
                return .insettable(AnyInsettableShape(shape.inset(by: amount)))
            case let .shape(shape):
                return .shape(shape)
            }
        case let .offset(x, y):
            switch shape {
            case let .insettable(shape):
                return .insettable(AnyInsettableShape(shape.offset(x: x, y: y)))
            case let .shape(shape):
                return .shape(AnyShape(shape.offset(x: x, y: y)))
            }
        case let .rotation(angle, anchor):
            switch shape {
            case let .insettable(shape):
                return .insettable(AnyInsettableShape(shape.rotation(angle, anchor: anchor)))
            case let .shape(shape):
                return .shape(AnyShape(shape.rotation(angle, anchor: anchor)))
            }
        case let .size(width, height):
            switch shape {
            case let .insettable(shape):
                return .shape(AnyShape(shape.size(width: width, height: height)))
            case let .shape(shape):
                return .shape(AnyShape(shape.size(width: width, height: height)))
            }
        case let .trim(startFraction, endFraction):
            switch shape {
            case let .insettable(shape):
                return .shape(AnyShape(shape.trim(from: startFraction, to: endFraction)))
            case let .shape(shape):
                return .shape(AnyShape(shape.trim(from: startFraction, to: endFraction)))
            }
        }
    }
}

enum EitherAnyShape {
    case shape(AnyShape)
    case insettable(AnyInsettableShape)
    
    func eraseToAnyShape() -> AnyShape {
        switch self {
        case let .shape(shape):
            return shape
        case let .insettable(shape):
            return AnyShape(shape)
        }
    }
}

struct AnyInsettableShape: SwiftUI.InsettableShape {
    let makePath: (CGRect) -> Path
    let makeInset: (CGFloat) -> AnyInsettableShape
    
    init(_ shape: some SwiftUI.InsettableShape) {
        self.makePath = shape.path(in:)
        self.makeInset = { AnyInsettableShape(shape.inset(by: $0)) }
    }
    
    func path(in rect: CGRect) -> Path {
        makePath(rect)
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        makeInset(amount)
    }
}

enum FinalShapeModifier: Decodable {
    case fill(AnyShapeStyle, style: FillStyle)
    case stroke(AnyShapeStyle, style: StrokeStyle)
    case strokeBorder(AnyShapeStyle, style: StrokeStyle, antialiased: Bool)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(ModifierType.self, forKey: .type) {
        case .fill:
            self = .fill(
                try container.decode(AnyShapeStyle.self, forKey: .content),
                style: try container.decodeIfPresent(FillStyle.self, forKey: .style) ?? .init()
            )
        case .stroke:
            self = .stroke(
                try container.decode(AnyShapeStyle.self, forKey: .content),
                style: try container.decodeIfPresent(StrokeStyle.self, forKey: .style) ?? .init()
            )
        case .strokeBorder:
            self = .strokeBorder(
                try container.decode(AnyShapeStyle.self, forKey: .content),
                style: try container.decodeIfPresent(StrokeStyle.self, forKey: .style) ?? .init(),
                antialiased: try container.decode(Bool.self, forKey: .antialiased)
            )
        }
    }
    
    enum CodingKeys: CodingKey {
        case type
        case content
        case style
        
        case antialiased
    }
    
    enum ModifierType: String, Decodable {
        case fill
        case stroke
        case strokeBorder = "stroke_border"
    }
    
    @ViewBuilder
    func apply(to shape: EitherAnyShape) -> some View {
        switch self {
        case let .fill(content, style):
            switch shape {
            case let .shape(shape):
                shape.fill(content, style: style)
            case let .insettable(shape):
                shape.fill(content, style: style)
            }
        case let .stroke(content, style):
            switch shape {
            case let .shape(shape):
                shape.stroke(content, style: style)
            case let .insettable(shape):
                shape.stroke(content, style: style)
            }
        case let .strokeBorder(content, style, antialiased):
            switch shape {
            case let .shape(shape):
                shape
            case let .insettable(shape):
                shape.strokeBorder(content, style: style, antialiased: antialiased)
            }
        }
    }
}

struct ShapeModifierStack: Decodable, AttributeDecodable {
    var stack: [ShapeModifier]
    var final: FinalShapeModifier?
    
    init(_ stack: [ShapeModifier]) {
        self.stack = stack
    }
    
    init(from attribute: LiveViewNativeCore.Attribute?) throws {
        guard let value = attribute?.value else { throw AttributeDecodingError.missingAttribute(Self.self) }
        self = try makeJSONDecoder().decode(Self.self, from: Data(value.utf8))
    }
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.stack = []
        while !container.isAtEnd {
            if let modifier = try? container.decode(ShapeModifier.self) {
                self.stack.append(modifier)
            } else if let modifier = try? container.decode(FinalShapeModifier.self) {
                self.final = modifier
                return
            } else {
                return
            }
        }
    }
}
