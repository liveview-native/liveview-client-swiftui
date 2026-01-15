import SwiftUI
import SwiftSyntax

/// Modifier for setting the background style.
///
/// Usage:
/// ```html
/// <vstack modifiers="backgroundStyle(.blue)">...</vstack>
/// <vstack modifiers="backgroundStyle(.ultraThinMaterial)">...</vstack>
/// <vstack modifiers="backgroundStyle(.linearGradient(colors: [.red, .blue], startPoint: .leading, endPoint: .trailing))">...</vstack>
/// ```
#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public enum BackgroundStyleModifier<Library: ElementLibrary>: @unchecked Sendable {
    case backgroundStyle(AnyShapeStyle)
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension BackgroundStyleModifier: RuntimeViewModifier {
    public static var baseName: String { "backgroundStyle" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let style = syntax.arguments.first.flatMap({ AnyShapeStyle(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "BackgroundStyleModifier", argument: "style")
        }
        self = .backgroundStyle(style)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .backgroundStyle(let style):
            _content.backgroundStyle(style)
        }
    }
}
#endif
