import SwiftUI
import SwiftSyntax

/// Shape-specific modifier for fill().
/// This modifier only works on Shape types, not generic Views.
public enum FillModifier: @unchecked Sendable {
    case fill(AnyShapeStyle, style: SwiftUICore.FillStyle)
}

extension FillModifier: RuntimeShapeModifier {
    public static var baseName: String { "fill" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let value0: AnyShapeStyle = (syntax.arguments.count > 0 ? syntax.arguments[0] : nil).flatMap({ AnyShapeStyle(syntax: $0.expression) }) ?? AnyShapeStyle(.foreground)
        let style: SwiftUICore.FillStyle = syntax.argument(named: "style").flatMap({ SwiftUICore.FillStyle(syntax: $0.expression) }) ?? FillStyle()
        self = .fill(value0, style: style)
    }

    public func shapeBody<S: SwiftUI.Shape>(content: S) -> ShapeModifierResult {
        switch self {
        case .fill(let shapeStyle, style: let style):
            return .view(AnyView(content.fill(shapeStyle, style: style)))
        }
    }
}