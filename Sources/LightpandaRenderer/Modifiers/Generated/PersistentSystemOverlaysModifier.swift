import SwiftUI
import SwiftSyntax

/// Modifier for controlling persistent system overlay visibility.
///
/// Usage:
/// ```html
/// <vstack modifiers="persistentSystemOverlays(.hidden)">...</vstack>
/// <vstack modifiers="persistentSystemOverlays(.visible)">...</vstack>
/// <vstack modifiers="persistentSystemOverlays(.automatic)">...</vstack>
/// ```
#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public enum PersistentSystemOverlaysModifier<Library: ElementLibrary>: @unchecked Sendable {
    case persistentSystemOverlays(Visibility)
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension PersistentSystemOverlaysModifier: RuntimeViewModifier {
    public static var baseName: String { "persistentSystemOverlays" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let visibility = syntax.arguments.first.flatMap({ Visibility(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "PersistentSystemOverlaysModifier", argument: "visibility")
        }
        self = .persistentSystemOverlays(visibility)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .persistentSystemOverlays(let visibility):
            _content.persistentSystemOverlays(visibility)
        }
    }
}
#endif
