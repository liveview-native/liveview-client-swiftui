//
//  RotationShapeModifier.swift
//  LightpandaRenderer
//

import SwiftUI
import SwiftSyntax

/// Shape-specific rotation modifier.
/// - `rotation(_ angle: Angle, anchor: UnitPoint = .center) -> RotatedShape<Self>`
@MainActor
enum RotationShapeModifier: RuntimeShapeModifier {
    case rotation(angle: Angle, anchor: UnitPoint)
    
    static let baseName: String = "rotation"
    
    init(syntax: FunctionCallExprSyntax) throws {
        let args = syntax.arguments
        
        guard let first = args.first,
              first.label == nil,
              let angle = Angle(syntax: first.expression) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "rotation", argument: "angle")
        }
        
        let anchor: UnitPoint = args.first { $0.label?.text == "anchor" }
            .flatMap { UnitPoint(syntax: $0.expression) } ?? .center
        
        self = .rotation(angle: angle, anchor: anchor)
    }
    
    func shapeBody<S: SwiftUI.Shape>(content: S) -> ShapeModifierResult {
        switch self {
        case .rotation(let angle, let anchor):
            return .shape(AnyShape(content.rotation(angle, anchor: anchor)))
        }
    }
}
