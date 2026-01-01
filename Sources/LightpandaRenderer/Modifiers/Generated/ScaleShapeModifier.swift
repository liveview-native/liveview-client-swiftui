//
//  ScaleShapeModifier.swift
//  LightpandaRenderer
//

import SwiftUI
import SwiftSyntax

/// Shape-specific scale modifier.
/// - `scale(_ scale: CGFloat, anchor: UnitPoint = .center) -> ScaledShape<Self>`
/// - `scale(x: CGFloat = 1, y: CGFloat = 1, anchor: UnitPoint = .center) -> ScaledShape<Self>`
@MainActor
enum ScaleShapeModifier: RuntimeShapeModifier {
    case uniform(scale: CGFloat, anchor: UnitPoint)
    case xy(x: CGFloat, y: CGFloat, anchor: UnitPoint)
    
    static let baseName: String = "scale"
    
    init(syntax: FunctionCallExprSyntax) throws {
        let args = syntax.arguments
        
        // Check which variant based on argument labels
        let hasX = args.contains { $0.label?.text == "x" }
        let hasY = args.contains { $0.label?.text == "y" }
        
        if hasX || hasY {
            // scale(x:y:anchor:)
            let x: CGFloat = args.first { $0.label?.text == "x" }
                .flatMap { CGFloat(syntax: $0.expression) } ?? 1
            let y: CGFloat = args.first { $0.label?.text == "y" }
                .flatMap { CGFloat(syntax: $0.expression) } ?? 1
            let anchor: UnitPoint = args.first { $0.label?.text == "anchor" }
                .flatMap { UnitPoint(syntax: $0.expression) } ?? .center
            self = .xy(x: x, y: y, anchor: anchor)
        } else {
            // scale(_:anchor:)
            guard let first = args.first,
                  first.label == nil,
                  let scale = CGFloat(syntax: first.expression) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "scale", argument: "scale")
            }
            let anchor: UnitPoint = args.first { $0.label?.text == "anchor" }
                .flatMap { UnitPoint(syntax: $0.expression) } ?? .center
            self = .uniform(scale: scale, anchor: anchor)
        }
    }
    
    func shapeBody<S: SwiftUI.Shape>(content: S) -> ShapeModifierResult {
        switch self {
        case .uniform(let scale, let anchor):
            return .shape(AnyShape(content.scale(scale, anchor: anchor)))
        case .xy(let x, let y, let anchor):
            return .shape(AnyShape(content.scale(x: x, y: y, anchor: anchor)))
        }
    }
}
