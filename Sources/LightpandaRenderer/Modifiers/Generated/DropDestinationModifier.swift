import SwiftUI
import SwiftSyntax
import LightpandaClient
import UniformTypeIdentifiers

/// Modifier for handling dropped string content.
/// Dispatches events when items are dropped onto the view.
///
/// Usage:
/// ```html
/// <!-- Drop destination that accepts string payloads -->
/// <vstack modifiers="dropDestination(action: itemDropped)">
///   Drop items here
/// </vstack>
///
/// <!-- With targeting indicator -->
/// <vstack modifiers="dropDestination(action: itemDropped, isTargeted: dropTargeting)">
///   Drop items here
/// </vstack>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("itemDropped", (e) => {
///     console.log("Dropped items:", e.detail.items);
///     console.log("Drop location:", e.detail.location);
/// });
///
/// element.addEventListener("dropTargeting", (e) => {
///     console.log("Is targeted:", e.detail.isTargeted);
/// });
/// ```
#if os(iOS) || os(macOS)
public enum DropDestinationModifier<Library: ElementLibrary>: @unchecked Sendable {
    case dropDestination(action: String, isTargeted: String?)
}

extension DropDestinationModifier: RuntimeViewModifier {
    public static var baseName: String { "dropDestination" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let action = syntax.argument(named: "action")
            .flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "drop"
        let isTargeted = syntax.argument(named: "isTargeted")
            .flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text })
        self = .dropDestination(action: action, isTargeted: isTargeted)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .dropDestination(let action, let isTargeted):
            DropDestinationModifierBody(
                actionEvent: action,
                isTargetedEvent: isTargeted,
                content: _content
            )
        }
    }
}

private struct DropDestinationModifierBody<Content: View>: View {
    let actionEvent: String
    let isTargetedEvent: String?
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.dropDestination(for: String.self) { items, location in
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
                                items: \#(itemsJSON),
                                location: { x: \#(location.x), y: \#(location.y) }
                            }
                        }));
                    }
                    """#
                )
            }
            return true
        } isTargeted: { targeted in
            guard let isTargetedEvent = isTargetedEvent else { return }
            Task {
                try? await node.callFunction(
                    runtime: runtime,
                    function: #"""
                    function() {
                        this.dispatchEvent(new CustomEvent("\#(isTargetedEvent)", {
                            bubbles: true,
                            detail: { isTargeted: \#(targeted) }
                        }));
                    }
                    """#
                )
            }
        }
    }
}
#endif
