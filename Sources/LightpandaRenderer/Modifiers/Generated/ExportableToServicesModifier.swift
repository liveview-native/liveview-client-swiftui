import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for exporting content to macOS Services menu.
/// The payload is a string array that can be accessed by system services.
///
/// Usage:
/// ```html
/// <!-- Simple exportable with single string -->
/// <text modifiers='exportableToServices("text to export")'>Export me</text>
///
/// <!-- Exportable with array of strings -->
/// <text modifiers='exportableToServices(["item1", "item2"])'>Export items</text>
///
/// <!-- Exportable with onEdit callback -->
/// <text modifiers='exportableToServices("editable text", onEdit: serviceEdited)'>
///   Edit via Services
/// </text>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("serviceEdited", (e) => {
///     console.log("Edited items:", e.detail.items);
/// });
/// ```
///
/// Note: This simplified implementation uses String as the Transferable type.
/// The original SwiftUI modifier supports any Transferable type, but at runtime
/// we can only support String payloads.
#if os(macOS)
@available(macOS 13.0, *)
public enum ExportableToServicesModifier<Library: ElementLibrary>: @unchecked Sendable {
    case exportableToServices(payload: [String])
    case exportableToServicesWithOnEdit(payload: [String], onEdit: String)
}

@available(macOS 13.0, *)
extension ExportableToServicesModifier: RuntimeViewModifier {
    public static var baseName: String { "exportableToServices" }

    public init(syntax: FunctionCallExprSyntax) throws {
        var errors: [Error] = []

        // Try to parse payload as array of strings: exportableToServices(["a", "b"])
        var payload: [String]? = nil
        if let arrayExpr = syntax.arguments.first?.expression.as(ArrayExprSyntax.self) {
            let strings = arrayExpr.elements.compactMap { element in
                String(syntax: element.expression)
            }
            if !strings.isEmpty {
                payload = strings
            }
        }

        // Try to parse payload as single string: exportableToServices("text")
        if payload == nil, let singleString = syntax.arguments.first.flatMap({ String(syntax: $0.expression) }) {
            payload = [singleString]
        }

        guard let finalPayload = payload else {
            throw ModifierParseError.missingRequiredArgument(modifier: "ExportableToServicesModifier", argument: "payload")
        }

        // Check for onEdit callback
        if let onEdit = syntax.argument(named: "onEdit")
            .flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) {
            self = .exportableToServicesWithOnEdit(payload: finalPayload, onEdit: onEdit)
            return
        }

        self = .exportableToServices(payload: finalPayload)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .exportableToServices(let payload):
            _content.exportableToServices(payload)
        case .exportableToServicesWithOnEdit(let payload, let onEdit):
            ExportableToServicesModifierBody(
                payload: payload,
                onEditEvent: onEdit,
                content: _content
            )
        }
    }
}

@available(macOS 13.0, *)
private struct ExportableToServicesModifierBody<Content: View>: View {
    let payload: [String]
    let onEditEvent: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.exportableToServices(payload) { editedItems in
            let itemsJSON = (try? JSONSerialization.data(withJSONObject: editedItems))
                .flatMap { String(data: $0, encoding: .utf8) } ?? "[]"
            Task {
                try? await node.callFunction(
                    runtime: runtime,
                    function: #"""
                    function() {
                        this.dispatchEvent(new CustomEvent("\#(onEditEvent)", {
                            bubbles: true,
                            detail: {
                                items: \#(itemsJSON)
                            }
                        }));
                    }
                    """#
                )
            }
            return true
        }
    }
}
#endif
