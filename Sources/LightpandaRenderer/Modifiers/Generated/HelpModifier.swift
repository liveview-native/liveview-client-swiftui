import SwiftUI
import SwiftSyntax

/// Modifier for adding help text to views.
///
/// Usage:
/// ```html
/// <button modifiers='help("Click to submit")'>
/// ```
public enum HelpModifier<Library: ElementLibrary>: @unchecked Sendable {
    case help(String)
}

extension HelpModifier: RuntimeViewModifier {
    public static var baseName: String { "help" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let text = syntax.arguments.first.flatMap({ String(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "HelpModifier", argument: "text")
        }
        self = .help(text)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .help(let text):
            _content.help(text)
        }
    }
}
