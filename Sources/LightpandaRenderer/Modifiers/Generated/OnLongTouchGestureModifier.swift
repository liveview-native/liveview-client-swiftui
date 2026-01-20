import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for handling long touch gestures on tvOS.
/// A long touch gesture is when the finger is on the remote touch surface without actually pressing.
/// The action dispatches a custom event on the element.
///
/// Usage:
/// ```html
/// <!-- Dispatches "longTouch" event (default) -->
/// <vstack modifiers="onLongTouchGesture()">
///   ...
/// </vstack>
///
/// <!-- With custom event name -->
/// <vstack modifiers="onLongTouchGesture(perform: touched)">
///   ...
/// </vstack>
///
/// <!-- With minimum duration -->
/// <vstack modifiers="onLongTouchGesture(minimumDuration: 1.0, perform: longTouched)">
///   ...
/// </vstack>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("longTouch", (e) => {
///     console.log("Long touched!", e.detail.minimumDuration);
/// });
///
/// // Listen for touching state changes
/// element.addEventListener("longTouchChanged", (e) => {
///     console.log("Touching:", e.detail.isTouching);
/// });
/// ```
#if os(tvOS)
public enum OnLongTouchGestureModifier<Library: ElementLibrary>: @unchecked Sendable {
    case onLongTouchGesture(minimumDuration: Double, perform: String, onTouchingChanged: String?)
}

extension OnLongTouchGestureModifier: RuntimeViewModifier {
    public static var baseName: String { "onLongTouchGesture" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let minimumDuration = syntax.argument(named: "minimumDuration").flatMap({ Double(syntax: $0.expression) }) ?? 0.5
        let perform = syntax.argument(named: "perform").flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "longTouch"
        let onTouchingChanged = syntax.argument(named: "onTouchingChanged").flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text })
        self = .onLongTouchGesture(minimumDuration: minimumDuration, perform: perform, onTouchingChanged: onTouchingChanged)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .onLongTouchGesture(let minimumDuration, let perform, let onTouchingChanged):
            OnLongTouchGestureModifierBody(
                minimumDuration: minimumDuration,
                eventName: perform,
                touchingChangedEventName: onTouchingChanged,
                content: _content
            )
        }
    }
}

/// Helper view that dispatches a custom event when long touched
private struct OnLongTouchGestureModifierBody<Content: View>: View {
    let minimumDuration: Double
    let eventName: String
    let touchingChangedEventName: String?
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.onLongTouchGesture(minimumDuration: minimumDuration) {
            Task {
                try? await node.callFunction(
                    runtime: runtime,
                    function: #"""
                    function() {
                        this.dispatchEvent(new CustomEvent("\#(eventName)", {
                            bubbles: true,
                            detail: { minimumDuration: \#(minimumDuration) }
                        }));
                    }
                    """#
                )
            }
        } onTouchingChanged: { isTouching in
            if let touchingChangedEventName {
                Task {
                    try? await node.callFunction(
                        runtime: runtime,
                        function: #"""
                        function() {
                            this.dispatchEvent(new CustomEvent("\#(touchingChangedEventName)", {
                                bubbles: true,
                                detail: { isTouching: \#(isTouching) }
                            }));
                        }
                        """#
                    )
                }
            }
        }
    }
}
#endif
