import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for handling tap gestures on views.
/// The tap action dispatches a custom event on the element.
///
/// Usage:
/// ```html
/// <!-- Dispatches "tap" event (default) -->
/// <vstack modifiers="onTapGesture()">
///   ...
/// </vstack>
///
/// <!-- Dispatches "clicked" event -->
/// <vstack modifiers="onTapGesture(perform: clicked)">
///   ...
/// </vstack>
///
/// <!-- Double tap with custom event -->
/// <vstack modifiers="onTapGesture(count: 2, perform: doubleTap)">
///   ...
/// </vstack>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("tap", (e) => {
///     console.log("Tapped!", e.detail.count);
/// });
///
/// element.addEventListener("clicked", (e) => {
///     console.log("Clicked!");
/// });
/// ```
public enum OnTapGestureModifier<Library: ElementLibrary>: @unchecked Sendable {
    case onTapGesture(count: Int, perform: String)
}

extension OnTapGestureModifier: RuntimeViewModifier {
    public static var baseName: String { "onTapGesture" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let count = syntax.argument(named: "count").flatMap({ Int(syntax: $0.expression) }) ?? 1
        let perform = syntax.argument(named: "perform").flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "tap"
        self = .onTapGesture(count: count, perform: perform)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .onTapGesture(let count, let perform):
            OnTapGestureModifierBody(count: count, eventName: perform, content: _content)
        }
    }
}

/// Helper view that dispatches a custom event when tapped
private struct OnTapGestureModifierBody<Content: View>: View {
    let count: Int
    let eventName: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.onTapGesture(count: count) {
            Task {
                try? await node.callFunction(
                    runtime: runtime,
                    function: #"""
                    function() {
                        this.dispatchEvent(new CustomEvent("\#(eventName)", {
                            bubbles: true,
                            detail: { count: \#(count) }
                        }));
                    }
                    """#
                )
            }
        }
    }
}
