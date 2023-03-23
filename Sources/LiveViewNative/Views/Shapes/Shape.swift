//
//  Shape.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI

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

    /// The color the shape is filled with.
    ///
    /// See ``LiveViewNative/SwiftUI/Color/init(fromNamedOrCSSHex:)``.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("fill-color") private var fillColor: SwiftUI.Color? = nil
    /// The color the shape stroke is drawn with.
    ///
    /// See ``LiveViewNative/SwiftUI/Color/init(fromNamedOrCSSHex:)``.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("stroke-color") private var strokeColor: SwiftUI.Color? = nil
    
    init(shape: S) {
        self.shape = shape
    }
    
    var body: some View {
        if let fillColor {
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
