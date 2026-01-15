import SwiftUI
import SwiftSyntax

/// Modifier for ignoring safe area insets.
///
/// Usage:
/// ```html
/// <vstack modifiers="ignoresSafeArea()">
/// <vstack modifiers="ignoresSafeArea(.keyboard)">
/// <vstack modifiers="ignoresSafeArea(.all, edges: .bottom)">
/// ```
public enum IgnoresSafeAreaModifier<Library: ElementLibrary>: @unchecked Sendable {
    case ignoresSafeArea(SafeAreaRegions, edges: Edge.Set)
}

extension IgnoresSafeAreaModifier: RuntimeViewModifier {
    public static var baseName: String { "ignoresSafeArea" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let regions = syntax.arguments.first.flatMap({ SafeAreaRegions(syntax: $0.expression) }) ?? .all
        let edges = syntax.argument(named: "edges").flatMap({ Edge.Set(syntax: $0.expression) }) ?? .all
        self = .ignoresSafeArea(regions, edges: edges)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .ignoresSafeArea(let regions, let edges):
            _content.ignoresSafeArea(regions, edges: edges)
        }
    }
}
