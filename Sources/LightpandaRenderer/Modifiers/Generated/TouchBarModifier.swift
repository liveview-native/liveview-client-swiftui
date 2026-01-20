import SwiftUI
import SwiftSyntax

/// TouchBar modifier for displaying content in the macOS Touch Bar.
///
/// ## Usage
/// ```html
/// <vstack modifiers='touchBar(content: touchBarContent)'>
///     <button template="touchBarContent">
///         <text template="label">Action</text>
///     </button>
///     <!-- Main content -->
/// </vstack>
/// ```
///
/// ## Platform Availability
/// - macOS 10.15+
/// - Not available on iOS, tvOS, watchOS, or visionOS
#if os(macOS)
@MainActor
public enum TouchBarModifier<Library: ElementLibrary>: @unchecked Sendable {
    case content(ViewReference<Library>)
}

extension TouchBarModifier: RuntimeViewModifier {
    public static var baseName: String { "touchBar" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // Parse touchBar(content: identifier)
        if let content = syntax.argument(named: "content").flatMap({ ViewReference<Library>(syntax: $0.expression) }) {
            self = .content(content)
            return
        }

        throw ModifierParseError.noMatchingVariant(modifier: "TouchBarModifier", errors: [])
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .content(let touchBarContent):
            _content.touchBar(content: { touchBarContent })
        }
    }
}
#endif
