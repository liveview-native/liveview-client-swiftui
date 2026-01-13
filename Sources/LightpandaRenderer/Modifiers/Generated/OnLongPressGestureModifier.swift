import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for handling long press gestures on views.
/// The long press action dispatches a custom event on the element.
///
/// Usage:
/// ```html
/// <!-- Dispatches "longPress" event (default) -->
/// <vstack modifiers="onLongPressGesture()">
///   ...
/// </vstack>
///
/// <!-- With custom event name -->
/// <vstack modifiers="onLongPressGesture(perform: held)">
///   ...
/// </vstack>
///
/// <!-- With minimum duration -->
/// <vstack modifiers="onLongPressGesture(minimumDuration: 1.0, perform: longHeld)">
///   ...
/// </vstack>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("longPress", (e) => {
///     console.log("Long pressed!", e.detail.minimumDuration);
/// });
/// ```
#if !os(tvOS)
public enum OnLongPressGestureModifier<Library: ElementLibrary>: @unchecked Sendable {
    case onLongPressGesture(minimumDuration: Double, maximumDistance: CGFloat, perform: String)
}

extension OnLongPressGestureModifier: RuntimeViewModifier {
    public static var baseName: String { "onLongPressGesture" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let minimumDuration = syntax.argument(named: "minimumDuration").flatMap({ Double(syntax: $0.expression) }) ?? 0.5
        let maximumDistance = syntax.argument(named: "maximumDistance").flatMap({ CGFloat(syntax: $0.expression) }) ?? 10
        let perform = syntax.argument(named: "perform").flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "longPress"
        self = .onLongPressGesture(minimumDuration: minimumDuration, maximumDistance: maximumDistance, perform: perform)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .onLongPressGesture(let minimumDuration, let maximumDistance, let perform):
            OnLongPressGestureModifierBody(
                minimumDuration: minimumDuration,
                maximumDistance: maximumDistance,
                eventName: perform,
                content: _content
            )
        }
    }
}

/// Helper view that dispatches a custom event when long pressed
private struct OnLongPressGestureModifierBody<Content: View>: View {
    let minimumDuration: Double
    let maximumDistance: CGFloat
    let eventName: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.onLongPressGesture(minimumDuration: minimumDuration, maximumDistance: maximumDistance) {
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
        }
    }
}
#endif
