import SwiftUI
import SwiftSyntax

/// Modifier for positioning a view at a specific point.
///
/// Usage:
/// ```html
/// <text modifiers="position(x: 100, y: 200)">
/// ```
public enum PositionModifier<Library: ElementLibrary>: @unchecked Sendable {
    case position(x: CGFloat, y: CGFloat)
}

extension PositionModifier: RuntimeViewModifier {
    public static var baseName: String { "position" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let x = syntax.argument(named: "x").flatMap({ CGFloat(syntax: $0.expression) }) ?? 0
        let y = syntax.argument(named: "y").flatMap({ CGFloat(syntax: $0.expression) }) ?? 0
        self = .position(x: x, y: y)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .position(let x, let y):
            _content.position(x: x, y: y)
        }
    }
}
