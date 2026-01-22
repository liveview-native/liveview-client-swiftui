import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for observing drag session updates.
/// Dispatches a custom event with drag session data when the drag session changes.
///
/// Usage:
/// ```html
/// <!-- Dispatches "dragSessionUpdated" event (default) -->
/// <vstack modifiers="onDragSessionUpdated()">
///   ...
/// </vstack>
///
/// <!-- Dispatches "dragUpdate" event -->
/// <vstack modifiers="onDragSessionUpdated(action: dragUpdate)">
///   ...
/// </vstack>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("dragSessionUpdated", (e) => {
///     console.log("Phase:", e.detail.phase);
///     console.log("Operation:", e.detail.operation); // only when phase is "ended"
/// });
///
/// // Handle delete operations (e.g., dragging to trash)
/// element.addEventListener("dragSessionUpdated", (e) => {
///     if (e.detail.phase === "ended" && e.detail.operation === "delete") {
///         // Handle deletion
///     }
/// });
/// ```
#if os(macOS)
@available(macOS 26.0, *)
public enum OnDragSessionUpdatedModifier<Library: ElementLibrary>: @unchecked Sendable {
    case onDragSessionUpdated(action: String)
}

@available(macOS 26.0, *)
extension OnDragSessionUpdatedModifier: RuntimeViewModifier {
    public static var baseName: String { "onDragSessionUpdated" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // Parse event name from 'action:' parameter, default to "dragSessionUpdated"
        let action = syntax.argument(named: "action").flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "dragSessionUpdated"
        self = .onDragSessionUpdated(action: action)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .onDragSessionUpdated(let action):
            OnDragSessionUpdatedModifierBody(eventName: action, content: _content)
        }
    }
}

/// Helper view that dispatches a custom event when drag session updates
@available(macOS 26.0, *)
private struct OnDragSessionUpdatedModifierBody<Content: View>: View {
    let eventName: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.onDragSessionUpdated { session in
            // Convert phase to a string representation
            let phaseString: String
            let operationString: String

            // Handle the ended phase with its associated operation
            if case .ended(let operation) = session.phase {
                phaseString = "ended"
                switch operation {
                case .cancel:
                    operationString = "\"cancel\""
                case .copy:
                    operationString = "\"copy\""
                case .move:
                    operationString = "\"move\""
                case .delete:
                    operationString = "\"delete\""
                @unknown default:
                    operationString = "\"unknown\""
                }
            } else {
                // For any other phase (active/changed/etc.), report as active
                phaseString = "active"
                operationString = "null"
            }

            Task {
                try? await node.callFunction(
                    runtime: runtime,
                    function: #"""
                    function() {
                        this.dispatchEvent(new CustomEvent("\#(eventName)", {
                            bubbles: true,
                            detail: {
                                phase: "\#(phaseString)",
                                operation: \#(operationString)
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
