import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for handling asynchronous tasks when a view appears.
/// The action dispatches a custom event on the element.
///
/// Usage:
/// ```html
/// <!-- Dispatches "task" event (default) -->
/// <vstack modifiers="task()">
///   ...
/// </vstack>
///
/// <!-- Dispatches "load" event -->
/// <vstack modifiers="task(action: load)">
///   ...
/// </vstack>
///
/// <!-- With priority -->
/// <vstack modifiers="task(priority: .background, action: fetchData)">
///   ...
/// </vstack>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("task", (e) => {
///     console.log("Task started!");
/// });
///
/// element.addEventListener("load", (e) => {
///     console.log("Loading data!");
/// });
/// ```
public enum TaskModifier<Library: ElementLibrary>: @unchecked Sendable {
    case task(priority: TaskPriority, action: String)
}

extension TaskModifier: RuntimeViewModifier {
    public static var baseName: String { "task" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let priority = syntax.argument(named: "priority").flatMap({ TaskPriority(syntax: $0.expression) }) ?? .userInitiated
        let action = syntax.argument(named: "action").flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "task"
        self = .task(priority: priority, action: action)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .task(let priority, let action):
            TaskModifierBody(priority: priority, eventName: action, content: _content)
        }
    }
}

/// Helper view that dispatches a custom event when the task runs
private struct TaskModifierBody<Content: View>: View {
    let priority: TaskPriority
    let eventName: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.task(priority: priority) {
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
