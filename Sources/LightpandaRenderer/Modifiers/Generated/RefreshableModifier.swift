import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for adding pull-to-refresh functionality to scrollable views.
/// The refresh action dispatches a custom event on the element.
///
/// Usage:
/// ```html
/// <!-- Dispatches "refresh" event (default) -->
/// <list modifiers="refreshable()">
///   ...
/// </list>
///
/// <!-- Dispatches "reload" event -->
/// <list modifiers="refreshable(action: reload)">
///   ...
/// </list>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("refresh", (e) => {
///     console.log("Refreshing...");
/// });
///
/// element.addEventListener("reload", (e) => {
///     console.log("Reloading...");
/// });
/// ```
public enum RefreshableModifier<Library: ElementLibrary>: @unchecked Sendable {
    case refreshable(action: String)
}

extension RefreshableModifier: RuntimeViewModifier {
    public static var baseName: String { "refreshable" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let action = syntax.argument(named: "action").flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "refresh"
        self = .refreshable(action: action)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .refreshable(let action):
            RefreshableModifierBody(eventName: action, content: _content)
        }
    }
}

/// Helper view that dispatches a custom event when pulled to refresh
private struct RefreshableModifierBody<Content: View>: View {
    let eventName: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.refreshable {
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
