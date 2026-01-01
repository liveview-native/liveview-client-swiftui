//
//  Shape.swift
//  LightpandaRenderer
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI
import LightpandaClient

/// A view that displays the a shape.
///
/// This view isn't used directly as an element. Instead, use the shape itself (e.g., `<Rectangle>`).
///
/// Use shape modifiers to customize the appearance:
/// ```html
/// <RoundedRectangle cornerRadius="8" modifiers='fill(.blue).stroke(.red, lineWidth: 2)' />
/// ```
///
/// ## Attributes
/// - ``fillColor``
/// - ``strokeColor``
@_documentation(visibility: public)
struct Shape<Library: ElementLibrary, S: SwiftUI.InsettableShape>: View {
    let node: Node
    
    private let shape: S
    
    @Environment(ModifierParser<Library>.self) private var modifierParser
    
    init(shape: S, node: Node) {
        self.shape = shape
        self.node = node
    }
    
    var body: some View {
        if let modifiersString = node.attributeValue(for: "modifiers") {
            let parsed = modifierParser.parse(modifiersString)
            let (shapeView, viewModifiers) = parsed.applyToShape(shape)
            shapeView.modifier(viewModifiers)
        } else {
            shape
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
    init(node: Node) {
        let radius = node.attributeValue(for: "cornerRadius", strategy: .number) ?? 0
        self.init(
            cornerSize: .init(
                width: node.attributeValue(for: "cornerWidth", strategy: .number) ?? radius,
                height: node.attributeValue(for: "cornerHeight", strategy: .number) ?? radius
            ),
            style: node.attributeValue(for: "style", strategy: RoundedCornerStyleParseStrategy()) ?? .circular
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
    init(node: Node) {
        self.init(
            style: node.attributeValue(for: "style", strategy: RoundedCornerStyleParseStrategy()) ?? .circular
        )
    }
}

/// A style for rounded corners.
/// 
/// Possible values:
/// * `circular`
/// * `continuous`
@_documentation(visibility: public)
struct RoundedCornerStyleParseStrategy: ParseStrategy {
    func parse(_ value: String) throws -> RoundedCornerStyle {
        switch value {
        case "circular":
            return .circular
        case "continuous":
            return .continuous
        default:
            throw ParseError()
        }
    }
}
