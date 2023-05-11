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
struct Shape<S: SwiftUI.Shape>: View {
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
        let shape = modifiers.stack.reduce(AnyShape(self.shape)) { shape, modifier in
            AnyShape(modifier.apply(to: shape))
        }
        switch modifiers.final {
        case let .fill(style):
            shape.fill(style)
        case .none:
            if let fillColor {
                shape.fill(fillColor)
            } else if let strokeColor {
                shape.stroke(strokeColor)
            } else {
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
    case offset(x: CGFloat, y: CGFloat)
    case trim(startFraction: CGFloat, endFraction: CGFloat)
    case size(width: CGFloat, height: CGFloat)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(ModifierType.self, forKey: .type) {
        case .offset:
            self = .offset(
                x: try container.decode(CGFloat.self, forKey: .x),
                y: try container.decode(CGFloat.self, forKey: .y)
            )
        case .trim:
            self = .trim(
                startFraction: try container.decode(CGFloat.self, forKey: .startFraction),
                endFraction: try container.decode(CGFloat.self, forKey: .endFraction)
            )
        case .size:
            self = .size(
                width: try container.decode(CGFloat.self, forKey: .width),
                height: try container.decode(CGFloat.self, forKey: .height)
            )
        }
    }
    
    enum CodingKeys: CodingKey {
        case type
        
        // offset
        case x
        case y
        
        // trim
        case startFraction
        case endFraction
        
        // size
        case width
        case height
    }
    
    enum ModifierType: String, Decodable {
        case offset = "offset_shape"
        case trim
        case size
    }
    
    func apply(to shape: AnyShape) -> AnyShape {
        switch self {
        case let .offset(x, y):
            return AnyShape(shape.offset(x: x, y: y))
        case let .trim(startFraction, endFraction):
            return AnyShape(shape.trim(from: startFraction, to: endFraction))
        case let .size(width, height):
            return AnyShape(shape.size(width: width, height: height))
        }
    }
}

enum FinalShapeModifier: Decodable {
    case fill(AnyShapeStyle)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(ModifierType.self, forKey: .type) {
        case .fill:
            self = .fill(try container.decode(AnyShapeStyle.self, forKey: .style))
        }
    }
    
    enum CodingKeys: CodingKey {
        case type
        case style
    }
    
    enum ModifierType: String, Decodable {
        case fill
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
