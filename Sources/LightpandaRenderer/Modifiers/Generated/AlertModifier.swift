import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Simplified AlertModifier that supports the most common alert patterns.
/// 
/// Supported variants:
/// - `alert("Title", isPresented: $showAlert) { actions }`
/// - `alert("Title", isPresented: $showAlert, actions: { actions }, message: { message })`
///
/// ## Usage
/// ```html
/// <vstack modifiers='alert("Delete Item?", isPresented: $showDeleteAlert, actions: deleteAlertActions, message: deleteAlertMessage)'>
///     <button template="deleteAlertActions">
///         <text template="label">Delete</text>
///     </button>
///     <text template="deleteAlertMessage">This action cannot be undone.</text>
///     
///     <button>
///         <text template="label">Show Alert</text>
///     </button>
/// </vstack>
/// ```
///
/// ## Event Handling
/// The `$showDeleteAlert` binding will dispatch a `showDeleteAlertChanged` event when toggled:
/// ```javascript
/// element.addEventListener("showDeleteAlertChanged", (event) => {
///     console.log("Alert visibility:", event.detail.value);
/// });
/// ```
@MainActor
public enum AlertModifier<Library: ElementLibrary>: @unchecked Sendable {
    /// alert(title, isPresented: $binding, actions: { ... })
    case titleIsPresentedActions(title: String, isPresented: NodeBinding<Bool>, actions: ViewReference<Library>)
    
    /// alert(title, isPresented: $binding, actions: { ... }, message: { ... })
    case titleIsPresentedActionsMessage(title: String, isPresented: NodeBinding<Bool>, actions: ViewReference<Library>, message: ViewReference<Library>)
}

extension AlertModifier: RuntimeViewModifier {
    public static var baseName: String { "alert" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // Try to parse: alert("Title", isPresented: $binding, actions: { ... }, message: { ... })
        if let title = (syntax.arguments.first).flatMap({ String(syntax: $0.expression) }),
           let isPresented = syntax.argument(named: "isPresented").flatMap({ NodeBinding<Bool>(syntax: $0.expression) }),
           let actions = syntax.argument(named: "actions").flatMap({ ViewReference<Library>(syntax: $0.expression) }),
           let message = syntax.argument(named: "message").flatMap({ ViewReference<Library>(syntax: $0.expression) }) {
            self = .titleIsPresentedActionsMessage(title: title, isPresented: isPresented, actions: actions, message: message)
            return
        }
        
        // Try to parse: alert("Title", isPresented: $binding, actions: { ... })
        if let title = (syntax.arguments.first).flatMap({ String(syntax: $0.expression) }),
           let isPresented = syntax.argument(named: "isPresented").flatMap({ NodeBinding<Bool>(syntax: $0.expression) }),
           let actions = syntax.argument(named: "actions").flatMap({ ViewReference<Library>(syntax: $0.expression) }) {
            self = .titleIsPresentedActions(title: title, isPresented: isPresented, actions: actions)
            return
        }
        
        throw ModifierParseError.noMatchingVariant(modifier: "AlertModifier", errors: [])
    }
    
    @ViewBuilder
    public func body(content _content: Content) -> some View {
        AlertModifierBody<Library>(modifier: self, content: _content)
    }
}

/// Internal view that resolves NodeBinding to Binding at runtime using environment.
private struct AlertModifierBody<Library: ElementLibrary>: View {
    let modifier: AlertModifier<Library>
    let content: AlertModifier<Library>.Content
    
    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime
    
    var body: some View {
        switch modifier {
        case .titleIsPresentedActions(let title, let isPresented, let actions):
            content.alert(title, isPresented: isPresented.binding(node: node, runtime: runtime)) {
                actions
            }
        case .titleIsPresentedActionsMessage(let title, let isPresented, let actions, let message):
            content.alert(title, isPresented: isPresented.binding(node: node, runtime: runtime)) {
                actions
            } message: {
                message
            }
        }
    }
}
