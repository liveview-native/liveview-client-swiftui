import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for handling play/pause commands on tvOS.
/// The action dispatches a custom event on the element.
///
/// Usage:
/// ```html
/// <!-- Dispatches "playPause" event (default) -->
/// <vstack modifiers="onPlayPauseCommand()">
///   ...
/// </vstack>
///
/// <!-- Dispatches "togglePlayback" event -->
/// <vstack modifiers="onPlayPauseCommand(perform: togglePlayback)">
///   ...
/// </vstack>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("playPause", (e) => {
///     console.log("Play/Pause pressed");
/// });
///
/// element.addEventListener("togglePlayback", (e) => {
///     console.log("Toggling playback...");
/// });
/// ```
#if os(tvOS)
public enum OnPlayPauseCommandModifier<Library: ElementLibrary>: @unchecked Sendable {
    case onPlayPauseCommand(perform: String)
}

extension OnPlayPauseCommandModifier: RuntimeViewModifier {
    public static var baseName: String { "onPlayPauseCommand" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let perform = syntax.argument(named: "perform").flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "playPause"
        self = .onPlayPauseCommand(perform: perform)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .onPlayPauseCommand(let perform):
            OnPlayPauseCommandModifierBody(eventName: perform, content: _content)
        }
    }
}

/// Helper view that dispatches a custom event when play/pause is pressed
private struct OnPlayPauseCommandModifierBody<Content: View>: View {
    let eventName: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.onPlayPauseCommand {
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
