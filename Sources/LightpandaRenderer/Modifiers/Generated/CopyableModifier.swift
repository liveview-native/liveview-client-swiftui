import SwiftUI
import SwiftSyntax

/// Modifier for making views provide copyable string content.
/// The payload is a string array that can be copied via the system Copy command.
///
/// Usage:
/// ```html
/// <!-- Simple copyable with single string -->
/// <text modifiers='copyable("text to copy")'>Copy me</text>
///
/// <!-- Copyable with array of strings -->
/// <text modifiers='copyable(["item1", "item2"])'>Copy items</text>
/// ```
///
/// Note: This simplified implementation uses String as the Transferable type.
/// The original SwiftUI modifier supports any Transferable type, but at runtime
/// we can only support String payloads.
#if os(macOS)
@available(macOS 13.0, *)
public enum CopyableModifier<Library: ElementLibrary>: @unchecked Sendable {
    case copyable(payload: [String])
}

@available(macOS 13.0, *)
extension CopyableModifier: RuntimeViewModifier {
    public static var baseName: String { "copyable" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // Try to parse as array of strings: copyable(["a", "b"])
        if let arrayExpr = syntax.arguments.first?.expression.as(ArrayExprSyntax.self) {
            let strings = arrayExpr.elements.compactMap { element in
                String(syntax: element.expression)
            }
            if !strings.isEmpty {
                self = .copyable(payload: strings)
                return
            }
        }

        // Try to parse as single string: copyable("text")
        if let singleString = syntax.arguments.first.flatMap({ String(syntax: $0.expression) }) {
            self = .copyable(payload: [singleString])
            return
        }

        throw ModifierParseError.missingRequiredArgument(modifier: "CopyableModifier", argument: "payload")
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .copyable(let payload):
            _content.copyable(payload)
        }
    }
}
#endif
