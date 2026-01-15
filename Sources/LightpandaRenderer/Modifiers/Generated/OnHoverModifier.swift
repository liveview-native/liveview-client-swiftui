import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for handling hover state changes on views.
/// The hover action dispatches a custom event on the element.
///
/// Usage:
/// ```html
/// <!-- Dispatches "hover" event (default) -->
/// <vstack modifiers="onHover()">
///   ...
/// </vstack>
///
/// <!-- Dispatches "hovered" event -->
/// <vstack modifiers="onHover(perform: hovered)">
///   ...
/// </vstack>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("hover", (e) => {
///     console.log("Hover state:", e.detail.isHovering);
/// });
/// ```
public enum OnHoverModifier<Library: ElementLibrary>: @unchecked Sendable {
    case onHover(perform: String)
}

extension OnHoverModifier: RuntimeViewModifier {
    public static var baseName: String { "onHover" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let perform = syntax.argument(named: "perform").flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "hover"
        self = .onHover(perform: perform)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .onHover(let perform):
            OnHoverModifierBody(eventName: perform, content: _content)
        }
    }
}

/// Helper view that dispatches a custom event when hover state changes
private struct OnHoverModifierBody<Content: View>: View {
    let eventName: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.onHover { isHovering in
            Task {
                try? await node.callFunction(
                    runtime: runtime,
                    function: #"""
                    function() {
                        this.dispatchEvent(new CustomEvent("\#(eventName)", {
                            bubbles: true,
                            detail: { isHovering: \#(isHovering) }
                        }));
                    }
                    """#
                )
            }
        }
    }
}
