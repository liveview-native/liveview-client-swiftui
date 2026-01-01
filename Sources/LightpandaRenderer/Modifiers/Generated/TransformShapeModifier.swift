//
//  TransformShapeModifier.swift
//  LightpandaRenderer
//

import SwiftUI
import SwiftSyntax

/// Shape modifier for `transform(_ transform: CGAffineTransform)`
/// Returns a transformed shape.
enum TransformShapeModifier: RuntimeShapeModifier {
    case transform(CGAffineTransform)
    
    static let baseName = "transform"
    
    init(syntax: FunctionCallExprSyntax) throws {
        let args = syntax.arguments
        
        // transform(_ transform: CGAffineTransform)
        if let transformArg = args.first(where: { $0.label == nil || $0.label?.text == "transform" }),
           let transform = CGAffineTransform(syntax: transformArg.expression) {
            self = .transform(transform)
        } else {
            throw ModifierParseError.missingRequiredArgument(modifier: "transform", argument: "transform")
        }
    }
    
    func shapeBody<S: SwiftUI.Shape>(content: S) -> ShapeModifierResult {
        switch self {
        case .transform(let transform):
            return .shape(AnyShape(content.transform(transform)))
        }
    }
}
