//
//  SizeShapeModifier.swift
//  LightpandaRenderer
//

import SwiftUI
import SwiftSyntax

/// Shape-specific size modifier.
/// - `size(_ size: CGSize) -> some Shape`
/// - `size(width: CGFloat, height: CGFloat) -> some Shape`
/// - `size(_ size: CGSize, anchor: UnitPoint) -> some Shape`
/// - `size(width: CGFloat, height: CGFloat, anchor: UnitPoint) -> some Shape`
@MainActor
enum SizeShapeModifier: RuntimeShapeModifier {
    case size(CGSize)
    case sizeWithAnchor(CGSize, anchor: UnitPoint)
    case widthHeight(width: CGFloat, height: CGFloat)
    case widthHeightAnchor(width: CGFloat, height: CGFloat, anchor: UnitPoint)
    
    static let baseName: String = "size"
    
    init(syntax: FunctionCallExprSyntax) throws {
        let args = syntax.arguments
        
        // Check which variant based on argument labels
        let hasWidth = args.contains { $0.label?.text == "width" }
        let hasHeight = args.contains { $0.label?.text == "height" }
        let hasAnchor = args.contains { $0.label?.text == "anchor" }
        
        if hasWidth || hasHeight {
            // size(width:height:) or size(width:height:anchor:)
            guard let width = args.first(where: { $0.label?.text == "width" })
                .flatMap({ CGFloat(syntax: $0.expression) }),
                  let height = args.first(where: { $0.label?.text == "height" })
                .flatMap({ CGFloat(syntax: $0.expression) }) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "size", argument: "width and height")
            }
            
            if hasAnchor {
                let anchor = args.first { $0.label?.text == "anchor" }
                    .flatMap { UnitPoint(syntax: $0.expression) } ?? .center
                self = .widthHeightAnchor(width: width, height: height, anchor: anchor)
            } else {
                self = .widthHeight(width: width, height: height)
            }
        } else if let first = args.first, first.label == nil {
            // size(_:) or size(_:anchor:)
            if let size = CGSize(syntax: first.expression) {
                if hasAnchor {
                    let anchor = args.first { $0.label?.text == "anchor" }
                        .flatMap { UnitPoint(syntax: $0.expression) } ?? .center
                    self = .sizeWithAnchor(size, anchor: anchor)
                } else {
                    self = .size(size)
                }
            } else {
                throw ModifierParseError.invalidArguments(modifier: "size", variant: "size(_:)", expectedTypes: "CGSize")
            }
        } else {
            throw ModifierParseError.missingRequiredArgument(modifier: "size", argument: "size or width/height")
        }
    }
    
    func shapeBody<S: SwiftUI.Shape>(content: S) -> ShapeModifierResult {
        switch self {
        case .size(let size):
            return .shape(AnyShape(content.size(size)))
        case .sizeWithAnchor(let size, let anchor):
            return .shape(AnyShape(content.size(size, anchor: anchor)))
        case .widthHeight(let width, let height):
            return .shape(AnyShape(content.size(width: width, height: height)))
        case .widthHeightAnchor(let width, let height, let anchor):
            return .shape(AnyShape(content.size(width: width, height: height, anchor: anchor)))
        }
    }
}
