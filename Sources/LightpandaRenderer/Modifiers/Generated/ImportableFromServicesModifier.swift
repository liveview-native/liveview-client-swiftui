import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for handling content imported from macOS Services menu.
/// Dispatches events when items are received from system services.
///
/// Usage:
/// ```html
/// <!-- Accept string content from Services menu -->
/// <vstack modifiers="importableFromServices(action: serviceReceived)">
///   Content that can receive service data
/// </vstack>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("serviceReceived", (e) => {
///     console.log("Received items:", e.detail.items);
/// });
/// ```
///
/// Note: This simplified implementation uses String as the Transferable type.
/// The original SwiftUI modifier supports any Transferable type,
/// but at runtime we can only support String payloads.
#if os(macOS)
@available(macOS 13.0, *)
public enum ImportableFromServicesModifier<Library: ElementLibrary>: @unchecked Sendable {
    case importableFromServices(action: String)
}

@available(macOS 13.0, *)
extension ImportableFromServicesModifier: RuntimeViewModifier {
    public static var baseName: String { "importableFromServices" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let action = syntax.argument(named: "action")
            .flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "serviceImport"
        self = .importableFromServices(action: action)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .importableFromServices(let action):
            ImportableFromServicesModifierBody(
                actionEvent: action,
                content: _content
            )
        }
    }
}

@available(macOS 13.0, *)
private struct ImportableFromServicesModifierBody<Content: View>: View {
    let actionEvent: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.importableFromServices(for: String.self) { items in
            let itemsJSON = (try? JSONSerialization.data(withJSONObject: items))
                .flatMap { String(data: $0, encoding: .utf8) } ?? "[]"
            Task {
                try? await node.callFunction(
                    runtime: runtime,
                    function: #"""
                    function() {
                        this.dispatchEvent(new CustomEvent("\#(actionEvent)", {
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
