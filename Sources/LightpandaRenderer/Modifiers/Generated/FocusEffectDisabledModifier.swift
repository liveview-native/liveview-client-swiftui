import SwiftUI
import SwiftSyntax

/// Modifier for disabling the focus effect.
///
/// Usage:
/// ```html
/// <button modifiers="focusEffectDisabled()">No Focus Effect</button>
/// <button modifiers="focusEffectDisabled(true)">No Focus Effect</button>
/// <button modifiers="focusEffectDisabled(false)">Has Focus Effect</button>
/// ```
#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public enum FocusEffectDisabledModifier<Library: ElementLibrary>: @unchecked Sendable {
    case focusEffectDisabled(Bool)
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension FocusEffectDisabledModifier: RuntimeViewModifier {
    public static var baseName: String { "focusEffectDisabled" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let disabled = syntax.arguments.first.flatMap({ Bool(syntax: $0.expression) }) ?? true
        self = .focusEffectDisabled(disabled)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .focusEffectDisabled(let disabled):
            _content.focusEffectDisabled(disabled)
        }
    }
}
#endif
