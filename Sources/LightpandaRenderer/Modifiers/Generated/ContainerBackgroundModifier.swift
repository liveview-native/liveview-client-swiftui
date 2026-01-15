import SwiftUI
import SwiftSyntax

/// Modifier for setting container background.
///
/// Usage:
/// ```html
/// <vstack modifiers="containerBackground(.blue, for: .automatic)">...</vstack>
/// <vstack modifiers="containerBackground(for: .automatic, content: bgContent)">...</vstack>
/// ```
#if os(iOS) || os(tvOS) || os(macOS) || os(watchOS)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public enum ContainerBackgroundModifier<Library: ElementLibrary>: @unchecked Sendable {
    case containerBackgroundStyle(AnyShapeStyle, for: ContainerBackgroundPlacement)
    case containerBackgroundContent(for: ContainerBackgroundPlacement, alignment: Alignment, content: ViewReference<Library>)
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension ContainerBackgroundModifier: RuntimeViewModifier {
    public static var baseName: String { "containerBackground" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // Try content-based variant first
        if let placement = syntax.argument(named: "for").flatMap({ ContainerBackgroundPlacement(syntax: $0.expression) }),
           let content = syntax.argument(named: "content").flatMap({ ViewReference<Library>(syntax: $0.expression) }) {
            let alignment = syntax.argument(named: "alignment").flatMap({ Alignment(syntax: $0.expression) }) ?? .center
            self = .containerBackgroundContent(for: placement, alignment: alignment, content: content)
            return
        }

        // Try style-based variant
        guard let style = syntax.arguments.first.flatMap({ AnyShapeStyle(syntax: $0.expression) }),
              let placement = syntax.argument(named: "for").flatMap({ ContainerBackgroundPlacement(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "ContainerBackgroundModifier", argument: "style or content")
        }
        self = .containerBackgroundStyle(style, for: placement)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .containerBackgroundStyle(let style, for: let placement):
            _content.containerBackground(style, for: placement)
        case .containerBackgroundContent(for: let placement, alignment: let alignment, content: let content):
            _content.containerBackground(for: placement, alignment: alignment) { content }
        }
    }
}
#endif
