import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for handling cut command (macOS only).
/// The cut action dispatches a custom event on the element.
///
/// Usage:
/// ```html
/// <!-- Dispatches "cutCommand" event (default) -->
/// <list modifiers="onCutCommand()">
///   ...
/// </list>
///
/// <!-- Dispatches "cut" event -->
/// <list modifiers="onCutCommand(perform: cut)">
///   ...
/// </list>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("cutCommand", (e) => {
///     console.log("Cut command triggered!");
/// });
///
/// element.addEventListener("cut", (e) => {
///     console.log("Cut triggered!");
/// });
/// ```
#if os(macOS)
public enum OnCutCommandModifier<Library: ElementLibrary>: @unchecked Sendable {
    case onCutCommand(perform: String)
}

extension OnCutCommandModifier: RuntimeViewModifier {
    public static var baseName: String { "onCutCommand" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let perform = syntax.argument(named: "perform").flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "cutCommand"
        self = .onCutCommand(perform: perform)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .onCutCommand(let perform):
            OnCutCommandModifierBody(eventName: perform, content: _content)
        }
    }
}

/// Helper view that dispatches a custom event when the cut command is triggered
private struct OnCutCommandModifierBody<Content: View>: View {
    let eventName: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.onCutCommand {
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
            return []
        }
    }
}
#endif
