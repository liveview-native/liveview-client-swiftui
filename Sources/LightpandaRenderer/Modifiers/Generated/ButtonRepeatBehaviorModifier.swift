import SwiftUI
import SwiftSyntax

/// Modifier for setting the button repeat behavior.
///
/// Usage:
/// ```html
/// <button modifiers="buttonRepeatBehavior(.enabled)">Hold to repeat</button>
/// <button modifiers="buttonRepeatBehavior(.disabled)">Single tap only</button>
/// <button modifiers="buttonRepeatBehavior(.automatic)">Auto</button>
/// ```
public enum ButtonRepeatBehaviorModifier<Library: ElementLibrary>: @unchecked Sendable {
    case buttonRepeatBehavior(ButtonRepeatBehavior)
}

extension ButtonRepeatBehaviorModifier: RuntimeViewModifier {
    public static var baseName: String { "buttonRepeatBehavior" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let behavior = syntax.arguments.first.flatMap({ ButtonRepeatBehavior(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "ButtonRepeatBehaviorModifier", argument: "behavior")
        }
        self = .buttonRepeatBehavior(behavior)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .buttonRepeatBehavior(let behavior):
            _content.buttonRepeatBehavior(behavior)
        }
    }
}
