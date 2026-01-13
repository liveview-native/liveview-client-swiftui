import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for handling view disappearance.
/// The disappear action dispatches a custom event on the element.
///
/// Usage:
/// ```html
/// <!-- Dispatches "disappear" event (default) -->
/// <vstack modifiers="onDisappear()">
///   ...
/// </vstack>
///
/// <!-- Dispatches "viewUnloaded" event -->
/// <vstack modifiers="onDisappear(perform: viewUnloaded)">
///   ...
/// </vstack>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("disappear", (e) => {
///     console.log("View disappeared!");
/// });
///
/// element.addEventListener("viewUnloaded", (e) => {
///     console.log("View unloaded!");
/// });
/// ```
public enum OnDisappearModifier<Library: ElementLibrary>: @unchecked Sendable {
    case onDisappear(perform: String)
}

extension OnDisappearModifier: RuntimeViewModifier {
    public static var baseName: String { "onDisappear" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let perform = syntax.argument(named: "perform").flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "disappear"
        self = .onDisappear(perform: perform)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .onDisappear(let perform):
            OnDisappearModifierBody(eventName: perform, content: _content)
        }
    }
}

/// Helper view that dispatches a custom event when the view disappears
private struct OnDisappearModifierBody<Content: View>: View {
    let eventName: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.onDisappear {
            Task {
                try? await node.callFunction(
                    runtime: runtime,
                    function: #"""
                    function() {
                        this.dispatchEvent(new CustomEvent("\#(eventName)", {
                            bubbles: true,
                            detail: {}
                        }));
                    }
                    """#
                )
            }
        }
    }
}
