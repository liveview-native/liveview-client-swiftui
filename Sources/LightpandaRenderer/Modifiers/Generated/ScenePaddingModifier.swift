import SwiftUI
import SwiftSyntax

/// Modifier for adding scene-aware padding.
///
/// Usage:
/// ```html
/// <vstack modifiers="scenePadding()">...</vstack>
/// <vstack modifiers="scenePadding(.horizontal)">...</vstack>
/// <vstack modifiers="scenePadding(.all)">...</vstack>
/// ```
public enum ScenePaddingModifier<Library: ElementLibrary>: @unchecked Sendable {
    case scenePadding(Edge.Set)
}

extension ScenePaddingModifier: RuntimeViewModifier {
    public static var baseName: String { "scenePadding" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let edges = syntax.arguments.first.flatMap({ Edge.Set(syntax: $0.expression) }) ?? .all
        self = .scenePadding(edges)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .scenePadding(let edges):
            _content.scenePadding(edges)
        }
    }
}
