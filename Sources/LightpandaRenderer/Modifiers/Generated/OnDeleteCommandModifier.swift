import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for handling delete command (macOS only).
/// The delete action dispatches a custom event on the element.
///
/// Usage:
/// ```html
/// <!-- Dispatches "deleteCommand" event (default) -->
/// <list modifiers="onDeleteCommand()">
///   ...
/// </list>
///
/// <!-- Dispatches "remove" event -->
/// <list modifiers="onDeleteCommand(perform: remove)">
///   ...
/// </list>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("deleteCommand", (e) => {
///     console.log("Delete command triggered!");
/// });
///
/// element.addEventListener("remove", (e) => {
///     console.log("Remove triggered!");
/// });
/// ```
#if os(macOS)
public enum OnDeleteCommandModifier<Library: ElementLibrary>: @unchecked Sendable {
    case onDeleteCommand(perform: String)
}

extension OnDeleteCommandModifier: RuntimeViewModifier {
    public static var baseName: String { "onDeleteCommand" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let perform = syntax.argument(named: "perform").flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "deleteCommand"
        self = .onDeleteCommand(perform: perform)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .onDeleteCommand(let perform):
            OnDeleteCommandModifierBody(eventName: perform, content: _content)
        }
    }
}

/// Helper view that dispatches a custom event when the delete command is triggered
private struct OnDeleteCommandModifierBody<Content: View>: View {
    let eventName: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.onDeleteCommand {
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
#endif
