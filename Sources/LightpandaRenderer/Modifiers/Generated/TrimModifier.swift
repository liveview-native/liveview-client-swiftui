import SwiftUI
import SwiftSyntax

/// Shape modifier for trimming shapes by a fractional amount.
public enum TrimModifier: @unchecked Sendable {
    case trim(from: CGFloat, to: CGFloat)
}

extension TrimModifier: RuntimeShapeModifier {
    public static var baseName: String { "trim" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let from: CGFloat = syntax.argument(named: "from").flatMap({ CGFloat(syntax: $0.expression) }) ?? 0
        let to: CGFloat = syntax.argument(named: "to").flatMap({ CGFloat(syntax: $0.expression) }) ?? 1
        self = .trim(from: from, to: to)
    }

    public func shapeBody<S: SwiftUI.Shape>(content: S) -> ShapeModifierResult {
        switch self {
        case .trim(from: let from, to: let to):
            return .shape(content.trim(from: from, to: to))
        }
    }
}
