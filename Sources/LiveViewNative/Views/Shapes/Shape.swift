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
@_documentation(visibility: public)
struct Shape<S: SwiftUI.InsettableShape>: View {
    @ObservedElement private var element: ElementNode
    private let shape: S

    /// The ``LiveViewNative/SwiftUI/Color`` the shape is filled with.
    ///
    /// See ``LiveViewNative/SwiftUI/Color/init?(fromNamedOrCSSHex:)`` for more details.
    @_documentation(visibility: public)
    @Attribute("fill-color") private var fillColor: SwiftUI.Color? = nil
    /// The ``LiveViewNative/SwiftUI/Color`` the shape stroke is drawn with.
    ///
    /// See ``LiveViewNative/SwiftUI/Color/init?(fromNamedOrCSSHex:)`` for more details.
    @_documentation(visibility: public)
    @Attribute("stroke-color") private var strokeColor: SwiftUI.Color? = nil
    
    @Environment(\.shapeModifiers) private var shapeModifiers: [any ShapeModifier]
    @Environment(\.shapeFinalizerModifier) private var shapeFinalizerModifier: (any ShapeFinalizerModifier)?
    
    init(shape: S) {
        self.shape = shape
    }
    
    var body: some View {
        let shape = shapeModifiers.reduce(into: shape as (any SwiftUI.Shape)) { result, modifier in
            func _unbox(_ shape: some SwiftUI.Shape) -> any SwiftUI.Shape {
                return modifier.apply(to: AnyShape(shape))
            }
            result = _unbox(result)
        }.erasedToAnyShape()
        
        if let shapeFinalizerModifier {
            AnyView(shapeFinalizerModifier.apply(to: shape))
        } else if let fillColor {
            shape.fill(fillColor)
        } else if let strokeColor {
            shape.stroke(strokeColor)
        } else {
            shape
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
@_documentation(visibility: public)
extension RoundedRectangle {
    init(from element: ElementNode) {
        let radius = element.attributeValue(for: "corner-radius").flatMap(Double.init) ?? 0
        self.init(
            cornerSize: .init(
                width: element.attributeValue(for: "corner-width").flatMap(Double.init) ?? radius,
                height: element.attributeValue(for: "corner-height").flatMap(Double.init) ?? radius
            ),
            style: (try? RoundedCornerStyle(from: element.attribute(named: "style"))) ?? .circular
        )
    }
}

/// A capsule shape. A capsule is a rounded rectangle where the corner size is half of the rectangle's smaller edge.
///
/// Attributes:
/// - `style`: Whether the corners are rounded with the quarter-circle style or continuously. Possible values:
///     - `circular`
///     - `continuous`
@_documentation(visibility: public)
extension Capsule {
    init(from element: ElementNode) {
        self.init(
            style: (try? RoundedCornerStyle(from: element.attribute(named: "style"))) ?? .circular
        )
    }
}

/// A style for rounded corners.
/// 
/// Possible values:
/// * `circular`
/// * `continuous`
@_documentation(visibility: public)
extension RoundedCornerStyle: Decodable, AttributeDecodable {
    init?(string: String) {
        switch string {
        case "circular":
            self = .circular
        case "continuous":
            self = .continuous
        default:
            return nil
        }
    }
    
    public init(from attribute: LiveViewNativeCore.Attribute?) throws {
        guard let string = attribute?.value
        else { throw AttributeDecodingError.missingAttribute(Self.self) }
        guard let value = Self(string: string)
        else { throw AttributeDecodingError.badValue(Self.self) }
        self = value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        if let value = Self(string: string) {
            self = value
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "Unknown RoundedCornerStyle `\(string)`"))
        }
    }
}
