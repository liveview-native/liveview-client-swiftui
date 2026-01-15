import SwiftUI
import SwiftSyntax

/// Modifier for enabling scroll target layout behavior.
///
/// Usage:
/// ```html
/// <lazyvstack modifiers="scrollTargetLayout()">...</lazyvstack>
/// <lazyvstack modifiers="scrollTargetLayout(isEnabled: true)">...</lazyvstack>
/// <lazyvstack modifiers="scrollTargetLayout(isEnabled: false)">...</lazyvstack>
/// ```
#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public enum ScrollTargetLayoutModifier<Library: ElementLibrary>: @unchecked Sendable {
    case scrollTargetLayout(isEnabled: Bool)
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension ScrollTargetLayoutModifier: RuntimeViewModifier {
    public static var baseName: String { "scrollTargetLayout" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let isEnabled = syntax.argument(named: "isEnabled").flatMap({ Bool(syntax: $0.expression) }) ?? true
        self = .scrollTargetLayout(isEnabled: isEnabled)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .scrollTargetLayout(isEnabled: let isEnabled):
            _content.scrollTargetLayout(isEnabled: isEnabled)
        }
    }
}
#endif
