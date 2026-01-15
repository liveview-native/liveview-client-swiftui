import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for handling pasted string content.
/// Dispatches events when items are pasted onto the view.
///
/// Usage:
/// ```html
/// <!-- Paste destination that accepts string payloads -->
/// <vstack modifiers="pasteDestination(action: itemPasted)">
///   Paste items here
/// </vstack>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("itemPasted", (e) => {
///     console.log("Pasted items:", e.detail.items);
/// });
/// ```
///
/// Note: This simplified implementation uses String as the Transferable type.
/// The original SwiftUI modifier supports any Transferable type with a validator,
/// but at runtime we can only support String payloads.
#if os(macOS)
@available(macOS 13.0, *)
public enum PasteDestinationModifier<Library: ElementLibrary>: @unchecked Sendable {
    case pasteDestination(action: String)
}

@available(macOS 13.0, *)
extension PasteDestinationModifier: RuntimeViewModifier {
    public static var baseName: String { "pasteDestination" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let action = syntax.argument(named: "action")
            .flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "paste"
        self = .pasteDestination(action: action)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .pasteDestination(let action):
            PasteDestinationModifierBody(
                actionEvent: action,
                content: _content
            )
        }
    }
}

@available(macOS 13.0, *)
private struct PasteDestinationModifierBody<Content: View>: View {
    let actionEvent: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.pasteDestination(for: String.self) { items in
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
        }
    }
}
#endif
