//
//  OffsetShapeModifier.swift
//  LightpandaRenderer
//

import SwiftUI
import SwiftSyntax

/// Shape-specific offset modifier.
/// - `offset(_ offset: CGPoint) -> OffsetShape<Self>`
/// - `offset(x: CGFloat = 0, y: CGFloat = 0) -> OffsetShape<Self>`
@MainActor
enum OffsetShapeModifier: RuntimeShapeModifier {
    case point(CGPoint)
    case xy(x: CGFloat, y: CGFloat)
    
    static let baseName: String = "offset"
    
    init(syntax: FunctionCallExprSyntax) throws {
        let args = syntax.arguments
        
        // Check which variant based on argument labels
        let hasX = args.contains { $0.label?.text == "x" }
        let hasY = args.contains { $0.label?.text == "y" }
        
        if hasX || hasY {
            // offset(x:y:)
            let x: CGFloat = args.first { $0.label?.text == "x" }
                .flatMap { CGFloat(syntax: $0.expression) } ?? 0
            let y: CGFloat = args.first { $0.label?.text == "y" }
                .flatMap { CGFloat(syntax: $0.expression) } ?? 0
            self = .xy(x: x, y: y)
        } else if let first = args.first, first.label == nil {
            // offset(_:) with CGSize
            if let size = CGSize(syntax: first.expression) {
                self = .xy(x: size.width, y: size.height)
            } else {
                throw ModifierParseError.invalidArguments(modifier: "offset", variant: "offset(_:)", expectedTypes: "CGSize")
            }
        } else {
            throw ModifierParseError.missingRequiredArgument(modifier: "offset", argument: "x/y or CGSize")
        }
    }
    
    func shapeBody<S: SwiftUI.Shape>(content: S) -> ShapeModifierResult {
        switch self {
        case .point(let point):
            return .shape(AnyShape(content.offset(CGSize(width: point.x, height: point.y))))
        case .xy(let x, let y):
            return .shape(AnyShape(content.offset(x: x, y: y)))
        }
    }
}
