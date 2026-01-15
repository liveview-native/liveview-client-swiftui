import SwiftUI
import SwiftSyntax

/// Modifier for making views provide cuttable string content.
/// The payload is a string array that can be cut via the system Cut command.
///
/// Usage:
/// ```html
/// <!-- Simple cuttable with single string -->
/// <text modifiers='cuttable("text to cut")'>Cut me</text>
///
/// <!-- Cuttable with array of strings -->
/// <text modifiers='cuttable(["item1", "item2"])'>Cut items</text>
/// ```
///
/// Note: This simplified implementation uses String as the Transferable type.
/// The original SwiftUI modifier supports any Transferable type, but at runtime
/// we can only support String payloads.
///
/// Note: This modifier is only available on macOS 13.0+.
#if os(macOS)
@available(macOS 13.0, *)
public enum CuttableModifier<Library: ElementLibrary>: @unchecked Sendable {
    case cuttable(payload: [String])
}

@available(macOS 13.0, *)
extension CuttableModifier: RuntimeViewModifier {
    public static var baseName: String { "cuttable" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // Try to parse as array of strings: cuttable(["a", "b"])
        if let arrayExpr = syntax.arguments.first?.expression.as(ArrayExprSyntax.self) {
            let strings = arrayExpr.elements.compactMap { element in
                String(syntax: element.expression)
            }
            if !strings.isEmpty {
                self = .cuttable(payload: strings)
                return
            }
        }

        // Try to parse as single string: cuttable("text")
        if let singleString = syntax.arguments.first.flatMap({ String(syntax: $0.expression) }) {
            self = .cuttable(payload: [singleString])
            return
        }

        throw ModifierParseError.missingRequiredArgument(modifier: "CuttableModifier", argument: "payload")
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .cuttable(let payload):
            _content.cuttable(for: String.self) { payload }
        }
    }
}
#endif
