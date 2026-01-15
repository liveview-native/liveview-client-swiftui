import SwiftUI
import SwiftSyntax

/// Modifier for applying transitions to views.
///
/// Usage:
/// ```html
/// <vstack modifiers="transition(.opacity)">
/// <vstack modifiers="transition(.slide)">
/// <vstack modifiers="transition(.scale)">
/// ```
public enum TransitionModifier<Library: ElementLibrary>: @unchecked Sendable {
    case transition(AnyTransition)
}

extension TransitionModifier: RuntimeViewModifier {
    public static var baseName: String { "transition" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let value = syntax.arguments.first.flatMap({ AnyTransition(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "TransitionModifier", argument: "transition")
        }
        self = .transition(value)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .transition(let transition):
            _content.transition(transition)
        }
    }
}
