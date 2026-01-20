import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for handling copy command (macOS only).
/// The copy action dispatches a custom event on the element.
///
/// Usage:
/// ```html
/// <!-- Dispatches "copyCommand" event (default) -->
/// <list modifiers="onCopyCommand()">
///   ...
/// </list>
///
/// <!-- Dispatches "copy" event -->
/// <list modifiers="onCopyCommand(perform: copy)">
///   ...
/// </list>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("copyCommand", (e) => {
///     console.log("Copy command triggered!");
/// });
///
/// element.addEventListener("copy", (e) => {
///     console.log("Copy triggered!");
/// });
/// ```
#if os(macOS)
public enum OnCopyCommandModifier<Library: ElementLibrary>: @unchecked Sendable {
    case onCopyCommand(perform: String)
}

extension OnCopyCommandModifier: RuntimeViewModifier {
    public static var baseName: String { "onCopyCommand" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let perform = syntax.argument(named: "perform").flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "copyCommand"
        self = .onCopyCommand(perform: perform)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .onCopyCommand(let perform):
            OnCopyCommandModifierBody(eventName: perform, content: _content)
        }
    }
}

/// Helper view that dispatches a custom event when the copy command is triggered
private struct OnCopyCommandModifierBody<Content: View>: View {
    let eventName: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.onCopyCommand {
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
