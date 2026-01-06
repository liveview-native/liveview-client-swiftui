import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Confirmation dialog presentation modifier using NodeBinding for `$identifier` syntax.
///
/// ## Usage
/// ```html
/// <vstack modifiers='confirmationDialog("Choose Option", isPresented: $showDialog, actions: dialogActions)'>
///     <button template="dialogActions">
///         <text template="label">Option 1</text>
///     </button>
///     <button>
///         <text template="label">Show Dialog</text>
///     </button>
/// </vstack>
/// ```
@MainActor
public enum ConfirmationDialogModifier<Library: ElementLibrary>: @unchecked Sendable {
    case titleIsPresentedActions(title: String, isPresented: NodeBinding<Bool>, actions: ViewReference<Library>)
    case titleIsPresentedActionsMessage(title: String, isPresented: NodeBinding<Bool>, actions: ViewReference<Library>, message: ViewReference<Library>)
}

extension ConfirmationDialogModifier: RuntimeViewModifier {
    public static var baseName: String { "confirmationDialog" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // Try with message first
        if let title = (syntax.arguments.first).flatMap({ String(syntax: $0.expression) }),
           let isPresented = syntax.argument(named: "isPresented").flatMap({ NodeBinding<Bool>(syntax: $0.expression) }),
           let actions = syntax.argument(named: "actions").flatMap({ ViewReference<Library>(syntax: $0.expression) }),
           let message = syntax.argument(named: "message").flatMap({ ViewReference<Library>(syntax: $0.expression) }) {
            self = .titleIsPresentedActionsMessage(title: title, isPresented: isPresented, actions: actions, message: message)
            return
        }
        
        // Try without message
        if let title = (syntax.arguments.first).flatMap({ String(syntax: $0.expression) }),
           let isPresented = syntax.argument(named: "isPresented").flatMap({ NodeBinding<Bool>(syntax: $0.expression) }),
           let actions = syntax.argument(named: "actions").flatMap({ ViewReference<Library>(syntax: $0.expression) }) {
            self = .titleIsPresentedActions(title: title, isPresented: isPresented, actions: actions)
            return
        }
        
        throw ModifierParseError.noMatchingVariant(modifier: "ConfirmationDialogModifier", errors: [])
    }
    
    @ViewBuilder
    public func body(content _content: Content) -> some View {
        ConfirmationDialogModifierBody<Library>(modifier: self, content: _content)
    }
}

private struct ConfirmationDialogModifierBody<Library: ElementLibrary>: View {
    let modifier: ConfirmationDialogModifier<Library>
    let content: ConfirmationDialogModifier<Library>.Content
    
    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime
    
    var body: some View {
        switch modifier {
        case .titleIsPresentedActions(let title, let isPresented, let actions):
            content.confirmationDialog(title, isPresented: isPresented.binding(node: node, runtime: runtime), titleVisibility: .visible) {
                actions
            }
        case .titleIsPresentedActionsMessage(let title, let isPresented, let actions, let message):
            content.confirmationDialog(title, isPresented: isPresented.binding(node: node, runtime: runtime), titleVisibility: .visible) {
                actions
            } message: {
                message
            }
        }
    }
}
