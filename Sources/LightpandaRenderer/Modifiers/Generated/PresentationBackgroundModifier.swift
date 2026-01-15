import SwiftUI
import SwiftSyntax

/// Modifier for setting presentation background.
///
/// Usage:
/// ```html
/// <vstack modifiers="presentationBackground(.blue)">...</vstack>
/// <vstack modifiers="presentationBackground(.ultraThinMaterial)">...</vstack>
/// <vstack modifiers="presentationBackground(content: bgView)">...</vstack>
/// ```
public enum PresentationBackgroundModifier<Library: ElementLibrary>: @unchecked Sendable {
    case presentationBackgroundStyle(AnyShapeStyle)
    case presentationBackgroundContent(alignment: Alignment, content: ViewReference<Library>)
}

extension PresentationBackgroundModifier: RuntimeViewModifier {
    public static var baseName: String { "presentationBackground" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // Try content-based variant first
        if let content = syntax.argument(named: "content").flatMap({ ViewReference<Library>(syntax: $0.expression) }) {
            let alignment = syntax.argument(named: "alignment").flatMap({ Alignment(syntax: $0.expression) }) ?? .center
            self = .presentationBackgroundContent(alignment: alignment, content: content)
            return
        }

        // Try style-based variant
        guard let style = syntax.arguments.first.flatMap({ AnyShapeStyle(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "PresentationBackgroundModifier", argument: "style")
        }
        self = .presentationBackgroundStyle(style)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .presentationBackgroundStyle(let style):
            _content.presentationBackground(style)
        case .presentationBackgroundContent(alignment: let alignment, content: let content):
            _content.presentationBackground(alignment: alignment) { content }
        }
    }
}
