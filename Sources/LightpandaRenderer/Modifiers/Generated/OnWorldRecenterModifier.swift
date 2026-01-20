import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for responding to world recentering events in visionOS.
/// When the user long-presses the digital crown to recenter their experience,
/// this modifier dispatches a custom event on the element.
///
/// Available on visionOS 26.0+
///
/// Usage:
/// ```html
/// <!-- Dispatches "worldRecenter" event (default) -->
/// <vstack modifiers="onWorldRecenter()">
///   ...
/// </vstack>
///
/// <!-- Dispatches "recenter" event -->
/// <vstack modifiers="onWorldRecenter(action: recenter)">
///   ...
/// </vstack>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("worldRecenter", (e) => {
///     console.log("World recentered!", e.detail.phase);
/// });
///
/// element.addEventListener("recenter", (e) => {
///     console.log("Recentering...");
/// });
/// ```
#if os(visionOS)
@available(visionOS 26.0, *)
public enum OnWorldRecenterModifier<Library: ElementLibrary>: @unchecked Sendable {
    case onWorldRecenter(action: String)
}

@available(visionOS 26.0, *)
extension OnWorldRecenterModifier: RuntimeViewModifier {
    public static var baseName: String { "onWorldRecenter" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let action = syntax.argument(named: "action").flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "worldRecenter"
        self = .onWorldRecenter(action: action)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .onWorldRecenter(let action):
            OnWorldRecenterModifierBody(eventName: action, content: _content)
        }
    }
}

/// Helper view that dispatches a custom event when world is recentered
@available(visionOS 26.0, *)
private struct OnWorldRecenterModifierBody<Content: View>: View {
    let eventName: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.onWorldRecenter { phase in
            Task {
                try? await node.callFunction(
                    runtime: runtime,
                    function: #"""
                    function() {
                        this.dispatchEvent(new CustomEvent("\#(eventName)", {
                            bubbles: true,
                            detail: { phase: "\#(String(describing: phase))" }
                        }));
                    }
                    """#
                )
            }
        }
    }
}
#endif
