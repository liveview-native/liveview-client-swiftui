import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for handling scroll visibility changes.
/// The action dispatches a custom event on the element with the visibility state.
///
/// Usage:
/// ```html
/// <!-- Dispatches "scrollVisibilityChange" event (default) with threshold 0.5 -->
/// <vstack modifiers="onScrollVisibilityChange()">
///   ...
/// </vstack>
///
/// <!-- Dispatches "scrollVisibilityChange" event with custom threshold -->
/// <vstack modifiers="onScrollVisibilityChange(threshold: 0.75)">
///   ...
/// </vstack>
///
/// <!-- Dispatches "visibilityChanged" event -->
/// <vstack modifiers="onScrollVisibilityChange(threshold: 0.5, action: visibilityChanged)">
///   ...
/// </vstack>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("scrollVisibilityChange", (e) => {
///     console.log("Visibility changed:", e.detail.isVisible);
/// });
/// ```
@available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
public enum OnScrollVisibilityChangeModifier<Library: ElementLibrary>: @unchecked Sendable {
    case onScrollVisibilityChange(threshold: Double, action: String)
}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
extension OnScrollVisibilityChangeModifier: RuntimeViewModifier {
    public static var baseName: String { "onScrollVisibilityChange" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let threshold = syntax.argument(named: "threshold").flatMap({ Double(syntax: $0.expression) }) ?? 0.5
        let action = syntax.argument(named: "action").flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "scrollVisibilityChange"
        self = .onScrollVisibilityChange(threshold: threshold, action: action)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .onScrollVisibilityChange(let threshold, let action):
            OnScrollVisibilityChangeModifierBody(threshold: threshold, eventName: action, content: _content)
        }
    }
}

/// Helper view that dispatches a custom event when scroll visibility changes
@available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
private struct OnScrollVisibilityChangeModifierBody<Content: View>: View {
    let threshold: Double
    let eventName: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.onScrollVisibilityChange(threshold: threshold) { isVisible in
            Task {
                try? await node.callFunction(
                    runtime: runtime,
                    function: #"""
                    function() {
                        this.dispatchEvent(new CustomEvent("\#(eventName)", {
                            bubbles: true,
                            detail: { isVisible: \#(isVisible) }
                        }));
                    }
                    """#
                )
            }
        }
    }
}
