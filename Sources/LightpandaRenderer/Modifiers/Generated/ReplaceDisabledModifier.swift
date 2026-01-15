import SwiftUI
import SwiftSyntax

/// Modifier for disabling replace functionality.
///
/// Usage:
/// ```html
/// <texteditor modifiers="replaceDisabled()">...</texteditor>
/// <texteditor modifiers="replaceDisabled(true)">...</texteditor>
/// ```
#if os(iOS) || os(macOS)
@available(iOS 16.0, macOS 26.0, *)
public enum ReplaceDisabledModifier<Library: ElementLibrary>: @unchecked Sendable {
    case replaceDisabled(Bool)
}

@available(iOS 16.0, macOS 26.0, *)
extension ReplaceDisabledModifier: RuntimeViewModifier {
    public static var baseName: String { "replaceDisabled" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let disabled = syntax.arguments.first.flatMap({ Bool(syntax: $0.expression) }) ?? true
        self = .replaceDisabled(disabled)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .replaceDisabled(let disabled):
            _content.replaceDisabled(disabled)
        }
    }
}
#endif
