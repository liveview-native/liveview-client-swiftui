import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for handling continuous hover state changes on views with location information.
/// The hover action dispatches a custom event on the element with phase and location.
///
/// Usage:
/// ```html
/// <!-- Dispatches "continuousHover" event (default) -->
/// <vstack modifiers="onContinuousHover()">
///   ...
/// </vstack>
///
/// <!-- Dispatches "hoverMove" event -->
/// <vstack modifiers="onContinuousHover(perform: hoverMove)">
///   ...
/// </vstack>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("continuousHover", (e) => {
///     // phase is "active" with location, or "ended"
///     console.log("Hover phase:", e.detail.phase);
///     if (e.detail.phase === "active") {
///         console.log("Location:", e.detail.location.x, e.detail.location.y);
///     }
/// });
/// ```
#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS)
@available(iOS 16.0, macOS 13.0, tvOS 16.0, visionOS 1.0, *)
public enum OnContinuousHoverModifier<Library: ElementLibrary>: @unchecked Sendable {
    case onContinuousHover(perform: String)
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, visionOS 1.0, *)
extension OnContinuousHoverModifier: RuntimeViewModifier {
    public static var baseName: String { "onContinuousHover" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let perform = syntax.argument(named: "perform").flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "continuousHover"
        self = .onContinuousHover(perform: perform)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .onContinuousHover(let perform):
            OnContinuousHoverModifierBody(eventName: perform, content: _content)
        }
    }
}

/// Helper view that dispatches a custom event when continuous hover state changes
@available(iOS 16.0, macOS 13.0, tvOS 16.0, visionOS 1.0, *)
private struct OnContinuousHoverModifierBody<Content: View>: View {
    let eventName: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.onContinuousHover { phase in
            Task {
                let phaseJS: String
                let locationJS: String
                switch phase {
                case .active(let location):
                    phaseJS = "active"
                    locationJS = "{ x: \(location.x), y: \(location.y) }"
                case .ended:
                    phaseJS = "ended"
                    locationJS = "null"
                @unknown default:
                    phaseJS = "unknown"
                    locationJS = "null"
                }
                try? await node.callFunction(
                    runtime: runtime,
                    function: #"""
                    function() {
                        this.dispatchEvent(new CustomEvent("\#(eventName)", {
                            bubbles: true,
                            detail: { phase: "\#(phaseJS)", location: \#(locationJS) }
                        }));
                    }
                    """#
                )
            }
        }
    }
}
#endif
