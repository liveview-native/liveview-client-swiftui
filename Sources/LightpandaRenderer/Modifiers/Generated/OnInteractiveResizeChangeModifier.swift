import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for handling interactive window resize events.
/// The resize action dispatches a custom event on the element with the isResizing state.
///
/// Usage:
/// ```html
/// <!-- Dispatches "interactiveResizeChange" event (default) -->
/// <vstack modifiers="onInteractiveResizeChange()">
///   ...
/// </vstack>
///
/// <!-- Dispatches "resizing" event -->
/// <vstack modifiers="onInteractiveResizeChange(action: resizing)">
///   ...
/// </vstack>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("interactiveResizeChange", (e) => {
///     console.log("Is resizing:", e.detail.isResizing);
/// });
/// ```
@available(iOS 26.0, macOS 26.0, tvOS 26.0, visionOS 26.0, watchOS 26.0, *)
public enum OnInteractiveResizeChangeModifier<Library: ElementLibrary>: @unchecked Sendable {
    case onInteractiveResizeChange(action: String)
}

@available(iOS 26.0, macOS 26.0, tvOS 26.0, visionOS 26.0, watchOS 26.0, *)
extension OnInteractiveResizeChangeModifier: RuntimeViewModifier {
    public static var baseName: String { "onInteractiveResizeChange" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let action = syntax.argument(named: "action").flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "interactiveResizeChange"
        self = .onInteractiveResizeChange(action: action)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .onInteractiveResizeChange(let action):
            OnInteractiveResizeChangeModifierBody(eventName: action, content: _content)
        }
    }
}

/// Helper view that dispatches a custom event when interactive resize state changes
@available(iOS 26.0, macOS 26.0, tvOS 26.0, visionOS 26.0, watchOS 26.0, *)
private struct OnInteractiveResizeChangeModifierBody<Content: View>: View {
    let eventName: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.onInteractiveResizeChange { isResizing in
            Task {
                try? await node.callFunction(
                    runtime: runtime,
                    function: #"""
                    function() {
                        this.dispatchEvent(new CustomEvent("\#(eventName)", {
                            bubbles: true,
                            detail: { isResizing: \#(isResizing) }
                        }));
                    }
                    """#
                )
            }
        }
    }
}
