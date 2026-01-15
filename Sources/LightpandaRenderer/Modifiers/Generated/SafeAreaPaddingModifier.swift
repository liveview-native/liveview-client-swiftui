import SwiftUI
import SwiftSyntax

/// Modifier for adding safe area padding.
///
/// Usage:
/// ```html
/// <vstack modifiers="safeAreaPadding()">...</vstack>
/// <vstack modifiers="safeAreaPadding(20)">...</vstack>
/// <vstack modifiers="safeAreaPadding(.horizontal)">...</vstack>
/// <vstack modifiers="safeAreaPadding(.top, 10)">...</vstack>
/// ```
#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public enum SafeAreaPaddingModifier<Library: ElementLibrary>: @unchecked Sendable {
    case safeAreaPaddingLength(CGFloat)
    case safeAreaPaddingEdges(Edge.Set, CGFloat?)
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SafeAreaPaddingModifier: RuntimeViewModifier {
    public static var baseName: String { "safeAreaPadding" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // Try parsing as just a length
        if let length = syntax.arguments.first.flatMap({ CGFloat(syntax: $0.expression) }) {
            self = .safeAreaPaddingLength(length)
            return
        }

        // Try parsing as edges with optional length
        let edges = syntax.arguments.first.flatMap({ Edge.Set(syntax: $0.expression) }) ?? .all
        let length: CGFloat? = syntax.arguments.count > 1 ? CGFloat(syntax: syntax.arguments[1].expression) : nil
        self = .safeAreaPaddingEdges(edges, length)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .safeAreaPaddingLength(let length):
            _content.safeAreaPadding(length)
        case .safeAreaPaddingEdges(let edges, let length):
            _content.safeAreaPadding(edges, length)
        }
    }
}
#endif
