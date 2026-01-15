import SwiftUI
import SwiftSyntax

/// Modifier for setting content margins on scroll views.
///
/// Usage:
/// ```html
/// <scrollview modifiers="contentMargins(20)">...</scrollview>
/// <scrollview modifiers="contentMargins(.horizontal, 16)">...</scrollview>
/// <scrollview modifiers="contentMargins(10, for: .scrollContent)">...</scrollview>
/// ```
#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public enum ContentMarginsModifier<Library: ElementLibrary>: @unchecked Sendable {
    case contentMarginsLength(CGFloat, for: ContentMarginPlacement)
    case contentMarginsEdges(Edge.Set, CGFloat?, for: ContentMarginPlacement)
    case contentMarginsInsets(Edge.Set, EdgeInsets, for: ContentMarginPlacement)
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension ContentMarginsModifier: RuntimeViewModifier {
    public static var baseName: String { "contentMargins" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let placement: ContentMarginPlacement = syntax.argument(named: "for").flatMap({ ContentMarginPlacement(syntax: $0.expression) }) ?? .automatic

        // Try parsing as EdgeInsets variant: contentMargins(.all, EdgeInsets(...), for:)
        if let edges = syntax.arguments.first.flatMap({ Edge.Set(syntax: $0.expression) }),
           let insets = (syntax.arguments.count > 1 ? syntax.arguments[1] : nil).flatMap({ EdgeInsets(syntax: $0.expression) }) {
            self = .contentMarginsInsets(edges, insets, for: placement)
            return
        }

        // Try parsing as edges + length variant: contentMargins(.horizontal, 16, for:)
        if let edges = syntax.arguments.first.flatMap({ Edge.Set(syntax: $0.expression) }) {
            let length = (syntax.arguments.count > 1 ? syntax.arguments[1] : nil).flatMap({ CGFloat(syntax: $0.expression) })
            self = .contentMarginsEdges(edges, length, for: placement)
            return
        }

        // Try parsing as simple length variant: contentMargins(20, for:)
        if let length = syntax.arguments.first.flatMap({ CGFloat(syntax: $0.expression) }) {
            self = .contentMarginsLength(length, for: placement)
            return
        }

        throw ModifierParseError.missingRequiredArgument(modifier: "ContentMarginsModifier", argument: "length or edges")
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .contentMarginsLength(let length, for: let placement):
            _content.contentMargins(length, for: placement)
        case .contentMarginsEdges(let edges, let length, for: let placement):
            _content.contentMargins(edges, length, for: placement)
        case .contentMarginsInsets(let edges, let insets, for: let placement):
            _content.contentMargins(edges, insets, for: placement)
        }
    }
}
#endif
