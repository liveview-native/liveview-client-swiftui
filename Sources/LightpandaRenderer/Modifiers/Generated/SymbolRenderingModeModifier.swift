import SwiftUI
import SwiftSyntax

/// Modifier for setting symbol rendering mode.
///
/// Usage:
/// ```html
/// <image systemname="star.fill" modifiers="symbolRenderingMode(.hierarchical)">
/// <image systemname="star.fill" modifiers="symbolRenderingMode(.multicolor)">
/// ```
public enum SymbolRenderingModeModifier<Library: ElementLibrary>: @unchecked Sendable {
    case symbolRenderingMode(SymbolRenderingMode?)
}

extension SymbolRenderingModeModifier: RuntimeViewModifier {
    public static var baseName: String { "symbolRenderingMode" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let mode = syntax.arguments.first.flatMap({ SymbolRenderingMode(syntax: $0.expression) })
        self = .symbolRenderingMode(mode)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .symbolRenderingMode(let mode):
            _content.symbolRenderingMode(mode)
        }
    }
}
