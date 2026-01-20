import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for handling the exit command (Menu button on tvOS, Escape key on macOS).
/// The exit action dispatches a custom event on the element.
///
/// Availability: macOS 10.15+, tvOS 13.0+
///
/// Usage:
/// ```html
/// <!-- Dispatches "exitCommand" event (default) -->
/// <vstack modifiers="onExitCommand()">
///   ...
/// </vstack>
///
/// <!-- Dispatches "back" event -->
/// <vstack modifiers="onExitCommand(perform: back)">
///   ...
/// </vstack>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("exitCommand", (e) => {
///     console.log("Exit command received!");
/// });
///
/// element.addEventListener("back", (e) => {
///     console.log("Back pressed!");
/// });
/// ```
#if os(macOS) || os(tvOS)
public enum OnExitCommandModifier<Library: ElementLibrary>: @unchecked Sendable {
    case onExitCommand(perform: String)
}

extension OnExitCommandModifier: RuntimeViewModifier {
    public static var baseName: String { "onExitCommand" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let perform = syntax.argument(named: "perform").flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "exitCommand"
        self = .onExitCommand(perform: perform)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .onExitCommand(let perform):
            OnExitCommandModifierBody(eventName: perform, content: _content)
        }
    }
}

/// Helper view that dispatches a custom event when the exit command is received
private struct OnExitCommandModifierBody<Content: View>: View {
    let eventName: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.onExitCommand {
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
