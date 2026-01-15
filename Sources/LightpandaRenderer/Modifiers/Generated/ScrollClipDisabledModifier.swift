import SwiftUI
import SwiftSyntax

/// Modifier for disabling scroll clipping.
///
/// Usage:
/// ```html
/// <scrollview modifiers="scrollClipDisabled()">...</scrollview>
/// <scrollview modifiers="scrollClipDisabled(true)">...</scrollview>
/// <scrollview modifiers="scrollClipDisabled(false)">...</scrollview>
/// ```
#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public enum ScrollClipDisabledModifier<Library: ElementLibrary>: @unchecked Sendable {
    case scrollClipDisabled(Bool)
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension ScrollClipDisabledModifier: RuntimeViewModifier {
    public static var baseName: String { "scrollClipDisabled" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let disabled = syntax.arguments.first.flatMap({ Bool(syntax: $0.expression) }) ?? true
        self = .scrollClipDisabled(disabled)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .scrollClipDisabled(let disabled):
            _content.scrollClipDisabled(disabled)
        }
    }
}
#endif
