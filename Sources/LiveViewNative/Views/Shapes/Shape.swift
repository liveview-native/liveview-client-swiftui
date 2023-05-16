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
/// ## Attributes
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
        let shape = modifiers.stack.reduce(EitherAnyShape.insettable(shape)) { shape, modifier in
            modifier.apply(to: shape)
        }
        if let final = modifiers.final {
            final.apply(to: shape)
        } else if let fillColor {
            shape.eraseToAnyShape().fill(fillColor)
        } else if let strokeColor {
            shape.eraseToAnyShape().stroke(strokeColor)
        } else {
            shape.eraseToAnyShape()
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
            style: (element.attributeValue(for: "style").flatMap({
                try? makeJSONDecoder().decode(RoundedCornerStyle.self, from: Data($0.utf8))
            }) ?? .circular)
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
            style: (element.attributeValue(for: "style").flatMap({
                try? makeJSONDecoder().decode(RoundedCornerStyle.self, from: Data($0.utf8))
            }) ?? .circular)
        )
    }
}

/// A style for rounded corners.
/// 
/// Possible values:
/// * `circular`
/// * `continuous`
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension RoundedCornerStyle: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "circular":
            self = .circular
        case "continuous":
            self = .continuous
        case let `default`: throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "Unknown RoundedCornerStyle '\(`default`)'"))
        }
    }
}

enum ShapeModifierType: String, Decodable {
    case inset
    case offset = "offset_shape"
    case rotation
    case size
    case trim
}

enum FinalShapeModifierType: String, Decodable {
    case fill
    case stroke
    case strokeBorder = "stroke_border"
}

struct ShapeModifierStack: Decodable, AttributeDecodable {
    var stack: [ShapeModifier]
    var final: ShapeModifierRegistry.AggregateFinalShapeModifier?
    
    init(_ stack: [ShapeModifier]) {
        self.stack = stack
    }
    
    init(from attribute: LiveViewNativeCore.Attribute?) throws {
        guard let value = attribute?.value else { throw AttributeDecodingError.missingAttribute(Self.self) }
        self = try makeJSONDecoder().decode(Self.self, from: Data(value.utf8))
    }
    
    enum ShapeModifierContainer: Decodable {
        case modifier(ShapeModifier)
        case final(ShapeModifierRegistry.AggregateFinalShapeModifier)
        case end
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let type = try container.decode(String.self, forKey: .type)
            if let modifier = ShapeModifierType(rawValue: type) {
                self = .modifier(try ShapeModifierRegistry.decodeShapeModifier(modifier, from: decoder))
            } else if let modifier = FinalShapeModifierType(rawValue: type) {
                self = .final(try ShapeModifierRegistry.decodeFinalShapeModifier(modifier, from: decoder))
            } else {
                self = .end
            }
        }
        
        enum CodingKeys: CodingKey {
            case type
        }
    }
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.stack = []
        while !container.isAtEnd {
            let modifier = try container.decode(ShapeModifierContainer.self)
            switch modifier {
            case let .modifier(modifier):
                self.stack.append(modifier)
            case let .final(final):
                self.final = final
                return
            case .end:
                return
            }
        }
    }
}
