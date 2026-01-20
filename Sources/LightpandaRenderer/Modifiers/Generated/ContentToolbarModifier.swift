import SwiftUI
import SwiftSyntax

/// ContentToolbar modifier using ViewReference for content.
///
/// ## Usage
/// ```html
/// <navigationstack modifiers='contentToolbar(for: .principal, content: toolbarContent)'>
///     <toolbaritem template="toolbarContent">
///         <button>
///             <text template="label">Action</text>
///         </button>
///     </toolbaritem>
/// </navigationstack>
/// ```
#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
@available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *)
@MainActor
public enum ContentToolbarModifier<Library: ElementLibrary>: @unchecked Sendable {
    case contentToolbar(for: ContentToolbarPlacement, content: ViewReference<Library>)
}

@available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *)
extension ContentToolbarModifier: RuntimeViewModifier {
    public static var baseName: String { "contentToolbar" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let placement = syntax.argument(named: "for").flatMap({ ContentToolbarPlacement(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "ContentToolbarModifier", argument: "for")
        }
        guard let content = syntax.argument(named: "content").flatMap({ ViewReference<Library>(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "ContentToolbarModifier", argument: "content")
        }
        self = .contentToolbar(for: placement, content: content)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .contentToolbar(for: let placement, content: let toolbarContent):
            _content.contentToolbar(for: placement) {
                toolbarContent
            }
        }
    }
}
#endif
