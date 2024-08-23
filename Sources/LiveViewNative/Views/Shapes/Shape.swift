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
@LiveElement
struct Shape<Root: RootRegistry, S: SwiftUI.InsettableShape>: View {
    private let shape: S
    
    @LiveElementIgnored
    @ClassModifiers<Root>
    private var modifiers
    
    init(shape: S) {
        self.shape = shape
    }
    
    var body: some View {
        var modifiers = modifiers
        var shape = shape.erasedToAnyShape()
        while case let ._anyShapeModifier(modifier) = modifiers.first {
            shape = modifier.apply(to: shape, on: $liveElement.element, in: $liveElement.context).erasedToAnyShape()
            modifiers.removeFirst()
        }
        
        return SwiftUI.Group {
            if case let ._anyShapeFinalizerModifier(modifier) = modifiers.first {
                modifier.apply(to: shape, on: $liveElement.element, in: $liveElement.context)
            } else {
                shape
            }
        }
    }
}

/// A rounded rectangle shape.
///
/// ```html
/// <RoundedRectangle cornerRadius="8" style="continuous" fillColor="#0000ff" />
/// ```
///
/// Attributes:
/// - `cornerRadius` (double): The radius of the shape's corners.
/// - `cornerWidth` (double): The width of the shape's corners (has precedence over `corner-radius`).
/// - `cornerHeight` (double): The height of the shape's corners (has precedence over `corner-radius`).
/// - `style`: Whether the corners are rounded with the quarter-circle style or continuously. Possible values:
///     - `circular`
///     - `continuous`
@_documentation(visibility: public)
extension RoundedRectangle {
    init(from element: ElementNode) {
        let radius = element.attributeValue(for: "cornerRadius").flatMap(Double.init) ?? 0
        self.init(
            cornerSize: .init(
                width: element.attributeValue(for: "cornerWidth").flatMap(Double.init) ?? radius,
                height: element.attributeValue(for: "cornerHeight").flatMap(Double.init) ?? radius
            ),
            style: (try? RoundedCornerStyle(from: element.attribute(named: "style"), on: element)) ?? .circular
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
            style: (try? RoundedCornerStyle(from: element.attribute(named: "style"), on: element)) ?? .circular
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
    
    public init(from attribute: LiveViewNativeCore.Attribute?, on element: ElementNode) throws {
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
