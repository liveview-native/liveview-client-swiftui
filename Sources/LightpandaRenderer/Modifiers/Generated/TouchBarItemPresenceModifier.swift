import SwiftUI
import SwiftSyntax

/// Modifier for setting Touch Bar item presence on macOS.
///
/// Usage:
/// ```html
/// <button modifiers='touchBarItemPresence(.default("myButton"))'>
/// <button modifiers='touchBarItemPresence(.optional("optionalItem"))'>
/// <button modifiers='touchBarItemPresence(.required("requiredItem"))'>
/// ```
#if os(macOS)
public enum TouchBarItemPresenceModifier<Library: ElementLibrary>: @unchecked Sendable {
    case touchBarItemPresence(SwiftUI.TouchBarItemPresence)
}

extension TouchBarItemPresenceModifier: RuntimeViewModifier {
    public static var baseName: String { "touchBarItemPresence" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let value = (syntax.arguments.count > 0 ? syntax.arguments[syntax.arguments.startIndex] : nil)
            .flatMap({ SwiftUI.TouchBarItemPresence(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "TouchBarItemPresenceModifier", argument: "presence")
        }
        self = .touchBarItemPresence(value)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .touchBarItemPresence(let value):
            _content.touchBarItemPresence(value)
        }
    }
}
#endif