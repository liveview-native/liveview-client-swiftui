import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for advertising a user activity type (Handoff, Siri, Spotlight).
/// The update closure is replaced with an event that dispatches to JavaScript.
///
/// Usage:
/// ```html
/// <!-- Dispatches "userActivity" event (default) with activityType in detail -->
/// <vstack modifiers='userActivity("com.example.viewItem")'>
///   ...
/// </vstack>
///
/// <!-- With isActive control and custom event name -->
/// <vstack modifiers='userActivity("com.example.viewItem", isActive: true, update: configureActivity)'>
///   ...
/// </vstack>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("userActivity", (e) => {
///     console.log("Activity type:", e.detail.activityType);
///     // Configure the activity via element attributes or state
/// });
///
/// element.addEventListener("configureActivity", (e) => {
///     console.log("Configure activity:", e.detail.activityType);
/// });
/// ```
public enum UserActivityModifier<Library: ElementLibrary>: @unchecked Sendable {
    case userActivity(activityType: String, isActive: Bool, update: String)
}

extension UserActivityModifier: RuntimeViewModifier {
    public static var baseName: String { "userActivity" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // Parse activity type (first positional argument)
        guard let activityType = (syntax.arguments.first).flatMap({ String(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "UserActivityModifier", argument: "activityType")
        }

        // Parse isActive (optional, defaults to true)
        let isActive = syntax.argument(named: "isActive").flatMap({ Bool(syntax: $0.expression) }) ?? true

        // Parse update event name (identifier, defaults to "userActivity")
        let update = syntax.argument(named: "update")
            .flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "userActivity"

        self = .userActivity(activityType: activityType, isActive: isActive, update: update)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .userActivity(let activityType, let isActive, let update):
            UserActivityModifierBody(
                activityType: activityType,
                isActive: isActive,
                eventName: update,
                content: _content
            )
        }
    }
}

/// Helper view that dispatches a custom event when the user activity is configured
private struct UserActivityModifierBody<Content: View>: View {
    let activityType: String
    let isActive: Bool
    let eventName: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.userActivity(activityType, isActive: isActive) { _ in
            Task {
                try? await node.callFunction(
                    runtime: runtime,
                    function: #"""
                    function() {
                        this.dispatchEvent(new CustomEvent("\#(eventName)", {
                            bubbles: true,
                            detail: {
                                activityType: "\#(activityType)"
                            }
                        }));
                    }
                    """#
                )
            }
        }
    }
}
