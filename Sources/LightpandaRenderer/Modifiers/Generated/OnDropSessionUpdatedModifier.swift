import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for handling drop session updates when a drag session is over the view.
/// Dispatches events when the drop session position or content changes.
///
/// Usage:
/// ```html
/// <!-- Dispatches "dropSessionUpdated" event (default) -->
/// <vstack modifiers="onDropSessionUpdated()">
///   Drop items here
/// </vstack>
///
/// <!-- Dispatches custom event -->
/// <vstack modifiers="onDropSessionUpdated(perform: dragPositionChanged)">
///   Drop items here
/// </vstack>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("dropSessionUpdated", (e) => {
///     console.log("Drop location:", e.detail.location);
///     console.log("Item count:", e.detail.itemCount);
/// });
///
/// element.addEventListener("dragPositionChanged", (e) => {
///     console.log("Drag position:", e.detail.location);
/// });
/// ```
#if os(macOS)
@available(macOS 26.0, *)
public enum OnDropSessionUpdatedModifier<Library: ElementLibrary>: @unchecked Sendable {
    case onDropSessionUpdated(perform: String)
}

@available(macOS 26.0, *)
extension OnDropSessionUpdatedModifier: RuntimeViewModifier {
    public static var baseName: String { "onDropSessionUpdated" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let perform = syntax.argument(named: "perform")
            .flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text })
            ?? (syntax.arguments.first?.expression.as(DeclReferenceExprSyntax.self)?.baseName.text)
            ?? "dropSessionUpdated"
        self = .onDropSessionUpdated(perform: perform)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .onDropSessionUpdated(let perform):
            OnDropSessionUpdatedModifierBody(
                eventName: perform,
                content: _content
            )
        }
    }
}

@available(macOS 26.0, *)
private struct OnDropSessionUpdatedModifierBody<Content: View>: View {
    let eventName: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.onDropSessionUpdated { session in
            Task {
                try? await node.callFunction(
                    runtime: runtime,
                    function: #"""
                    function() {
                        this.dispatchEvent(new CustomEvent("\#(eventName)", {
                            bubbles: true,
                            detail: {
                                location: { x: \#(session.location.x), y: \#(session.location.y) }
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
