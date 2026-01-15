import SwiftUI
import SwiftSyntax

/// Modifier for applying hover effects on supported platforms.
///
/// Usage:
/// ```html
/// <button modifiers="hoverEffect()">...</button>
/// <button modifiers="hoverEffect(.highlight)">...</button>
/// <button modifiers="hoverEffect(.lift, isEnabled: true)">...</button>
/// ```
#if os(iOS) || os(tvOS) || os(visionOS)
@available(iOS 13.4, tvOS 16.0, *)
public enum HoverEffectModifier<Library: ElementLibrary>: @unchecked Sendable {
    case hoverEffect(HoverEffect, isEnabled: Bool)
}

@available(iOS 13.4, tvOS 16.0, *)
extension HoverEffectModifier: RuntimeViewModifier {
    public static var baseName: String { "hoverEffect" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let effect = syntax.arguments.first.flatMap({ HoverEffect(syntax: $0.expression) }) ?? .automatic
        let isEnabled = syntax.argument(named: "isEnabled").flatMap({ Bool(syntax: $0.expression) }) ?? true
        self = .hoverEffect(effect, isEnabled: isEnabled)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .hoverEffect(let effect, let isEnabled):
            if #available(iOS 17.0, tvOS 17.0, *) {
                _content.hoverEffect(effect, isEnabled: isEnabled)
            } else {
                _content.hoverEffect(effect)
            }
        }
    }
}
#endif
