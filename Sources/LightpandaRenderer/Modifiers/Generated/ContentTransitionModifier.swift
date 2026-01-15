import SwiftUI
import SwiftSyntax

/// Modifier for setting the content transition.
///
/// Usage:
/// ```html
/// <text modifiers="contentTransition(.opacity)">Hello</text>
/// <text modifiers="contentTransition(.interpolate)">Counter</text>
/// <text modifiers="contentTransition(.symbolEffect)">Symbol</text>
/// ```
public enum ContentTransitionModifier<Library: ElementLibrary>: @unchecked Sendable {
    case contentTransition(ContentTransition)
}

extension ContentTransitionModifier: RuntimeViewModifier {
    public static var baseName: String { "contentTransition" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let transition = syntax.arguments.first.flatMap({ ContentTransition(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "ContentTransitionModifier", argument: "transition")
        }
        self = .contentTransition(transition)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .contentTransition(let transition):
            _content.contentTransition(transition)
        }
    }
}
