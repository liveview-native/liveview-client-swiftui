import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for handling user activity continuation (Handoff, Spotlight, Universal Links).
/// The perform action dispatches a custom event on the element with activity details.
///
/// Usage:
/// ```html
/// <!-- Dispatches "continueUserActivity" event (default) -->
/// <vstack modifiers="onContinueUserActivity('com.example.myactivity')">
///   ...
/// </vstack>
///
/// <!-- Dispatches "handleActivity" event -->
/// <vstack modifiers="onContinueUserActivity('com.example.myactivity', perform: handleActivity)">
///   ...
/// </vstack>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("continueUserActivity", (e) => {
///     console.log("Activity type:", e.detail.activityType);
///     console.log("User info:", e.detail.userInfo);
///     console.log("Webpage URL:", e.detail.webpageURL);
/// });
///
/// element.addEventListener("handleActivity", (e) => {
///     console.log("Activity received:", e.detail);
/// });
/// ```
public enum OnContinueUserActivityModifier<Library: ElementLibrary>: @unchecked Sendable {
    case onContinueUserActivity(activityType: String, perform: String)
}

extension OnContinueUserActivityModifier: RuntimeViewModifier {
    public static var baseName: String { "onContinueUserActivity" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let activityType = (syntax.arguments.count > 0 ? syntax.arguments[syntax.arguments.startIndex] : nil).flatMap({ String(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "OnContinueUserActivityModifier", argument: "activityType")
        }
        let perform = syntax.argument(named: "perform").flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "continueUserActivity"
        self = .onContinueUserActivity(activityType: activityType, perform: perform)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .onContinueUserActivity(let activityType, let perform):
            OnContinueUserActivityModifierBody(activityType: activityType, eventName: perform, content: _content)
        }
    }
}

/// Helper view that dispatches a custom event when a user activity is continued
private struct OnContinueUserActivityModifierBody<Content: View>: View {
    let activityType: String
    let eventName: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.onContinueUserActivity(activityType) { activity in
            Task {
                // Build the detail object with activity information
                let webpageURL = activity.webpageURL?.absoluteString ?? "null"
                let title = activity.title ?? ""

                try? await node.callFunction(
                    runtime: runtime,
                    function: #"""
                    function() {
                        this.dispatchEvent(new CustomEvent("\#(eventName)", {
                            bubbles: true,
                            detail: {
                                activityType: "\#(activityType)",
                                webpageURL: \#(webpageURL == "null" ? "null" : "\"\(webpageURL)\""),
                                title: "\#(title)"
                            }
                        }));
                    }
                    """#
                )
            }
        }
    }
}
