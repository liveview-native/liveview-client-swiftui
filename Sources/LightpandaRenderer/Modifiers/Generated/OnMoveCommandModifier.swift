import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for handling move commands (macOS and tvOS only).
/// The move action dispatches a custom event on the element with the direction in the detail.
///
/// Usage:
/// ```html
/// <!-- Dispatches "moveCommand" event (default) -->
/// <vstack modifiers="onMoveCommand()">
///   ...
/// </vstack>
///
/// <!-- Dispatches "navigate" event -->
/// <vstack modifiers="onMoveCommand(perform: navigate)">
///   ...
/// </vstack>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("moveCommand", (e) => {
///     console.log("Move command:", e.detail.direction); // "up", "down", "left", or "right"
/// });
///
/// element.addEventListener("navigate", (e) => {
///     switch (e.detail.direction) {
///         case "up": // handle up
///         case "down": // handle down
///         case "left": // handle left
///         case "right": // handle right
///     }
/// });
/// ```
#if os(macOS) || os(tvOS)
public enum OnMoveCommandModifier<Library: ElementLibrary>: @unchecked Sendable {
    case onMoveCommand(perform: String)
}

extension OnMoveCommandModifier: RuntimeViewModifier {
    public static var baseName: String { "onMoveCommand" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let perform = syntax.argument(named: "perform").flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "moveCommand"
        self = .onMoveCommand(perform: perform)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .onMoveCommand(let perform):
            OnMoveCommandModifierBody(eventName: perform, content: _content)
        }
    }
}

/// Helper view that dispatches a custom event when a move command is triggered
private struct OnMoveCommandModifierBody<Content: View>: View {
    let eventName: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.onMoveCommand { direction in
            let directionString: String
            switch direction {
            case .up:
                directionString = "up"
            case .down:
                directionString = "down"
            case .left:
                directionString = "left"
            case .right:
                directionString = "right"
            @unknown default:
                directionString = "unknown"
            }
            Task {
                try? await node.callFunction(
                    runtime: runtime,
                    function: #"""
                    function() {
                        this.dispatchEvent(new CustomEvent("\#(eventName)", {
                            bubbles: true,
                            detail: { direction: "\#(directionString)" }
                        }));
                    }
                    """#
                )
            }
        }
    }
}
#endif
