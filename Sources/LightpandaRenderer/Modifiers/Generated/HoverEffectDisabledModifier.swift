import SwiftUI
import SwiftSyntax

/// Modifier for disabling hover effects.
///
/// Usage:
/// ```html
/// <button modifiers="hoverEffectDisabled()">No hover</button>
/// <button modifiers="hoverEffectDisabled(true)">No hover</button>
/// <button modifiers="hoverEffectDisabled(false)">Has hover</button>
/// ```
#if os(iOS) || os(tvOS) || os(visionOS)
public enum HoverEffectDisabledModifier<Library: ElementLibrary>: @unchecked Sendable {
    case hoverEffectDisabled(Bool)
}

extension HoverEffectDisabledModifier: RuntimeViewModifier {
    public static var baseName: String { "hoverEffectDisabled" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let disabled = syntax.arguments.first.flatMap({ Bool(syntax: $0.expression) }) ?? true
        self = .hoverEffectDisabled(disabled)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .hoverEffectDisabled(let disabled):
            _content.hoverEffectDisabled(disabled)
        }
    }
}
#endif
