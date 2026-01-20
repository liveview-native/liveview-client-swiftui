import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for observing scroll target visibility changes in ScrollViews.
/// Dispatches a custom event with the visible IDs when scroll targets become visible/hidden.
///
/// This modifier uses String as the ID type. Use the `id` modifier to assign string IDs
/// to scroll targets, and ensure `scrollTargetLayout()` is applied to the content.
///
/// Usage:
/// ```html
/// <!-- Dispatches "scrollTargetVisibilityChange" event (default) -->
/// <scrollview modifiers="onScrollTargetVisibilityChange()">
///   <lazyvstack modifiers="scrollTargetLayout()">
///     <text id="item1">Item 1</text>
///     <text id="item2">Item 2</text>
///   </lazyvstack>
/// </scrollview>
///
/// <!-- Dispatches "visibleItemsChanged" event with custom threshold -->
/// <scrollview modifiers="onScrollTargetVisibilityChange(threshold: 0.8, action: visibleItemsChanged)">
///   ...
/// </scrollview>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("scrollTargetVisibilityChange", (e) => {
///     console.log("Visible IDs:", e.detail.visibleIds);
/// });
/// ```
@available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
public enum OnScrollTargetVisibilityChangeModifier<Library: ElementLibrary>: @unchecked Sendable {
    case onScrollTargetVisibilityChange(threshold: Double, action: String)
}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
extension OnScrollTargetVisibilityChangeModifier: RuntimeViewModifier {
    public static var baseName: String { "onScrollTargetVisibilityChange" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // Parse threshold from 'threshold:' parameter, default to 0.5
        let threshold = syntax.argument(named: "threshold").flatMap({ Double(syntax: $0.expression) }) ?? 0.5
        // Parse event name from 'action:' parameter, default to "scrollTargetVisibilityChange"
        let action = syntax.argument(named: "action").flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "scrollTargetVisibilityChange"
        self = .onScrollTargetVisibilityChange(threshold: threshold, action: action)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .onScrollTargetVisibilityChange(let threshold, let action):
            OnScrollTargetVisibilityChangeModifierBody(threshold: threshold, eventName: action, content: _content)
        }
    }
}

/// Helper view that dispatches a custom event when scroll target visibility changes
@available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
private struct OnScrollTargetVisibilityChangeModifierBody<Content: View>: View {
    let threshold: Double
    let eventName: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.onScrollTargetVisibilityChange(idType: String.self, threshold: threshold) { visibleIds in
            Task {
                // Convert array of IDs to JSON array string
                let idsJson = visibleIds.map { "\"\($0)\"" }.joined(separator: ", ")
                try? await node.callFunction(
                    runtime: runtime,
                    function: #"""
                    function() {
                        this.dispatchEvent(new CustomEvent("\#(eventName)", {
                            bubbles: true,
                            detail: {
                                visibleIds: [\#(idsJson)]
                            }
                        }));
                    }
                    """#
                )
            }
        }
    }
}
