import SwiftUI
import SwiftSyntax

/// Simplified AlertModifier that supports the most common alert patterns.
/// 
/// Supported variants:
/// - `alert("Title", isPresented: $showAlert) { Button("OK") { } }`
/// - `alert("Title", isPresented: $showAlert, actions: { Button("OK") { } }, message: { Text("Message") })`
@MainActor
public enum AlertModifier<Library: ElementLibrary>: @unchecked Sendable {
    /// alert(title, isPresented: binding, actions: { ... })
    case titleIsPresentedActions(title: String, isPresented: Binding<Bool>, actions: ViewReference<Library>)
    
    /// alert(title, isPresented: binding, actions: { ... }, message: { ... })
    case titleIsPresentedActionsMessage(title: String, isPresented: Binding<Bool>, actions: ViewReference<Library>, message: ViewReference<Library>)
}

extension AlertModifier: RuntimeViewModifier {
    public static var baseName: String { "alert" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // Try to parse: alert("Title", isPresented: binding, actions: { ... }, message: { ... })
        if let title = (syntax.arguments.first).flatMap({ String(syntax: $0.expression) }),
           let isPresented = syntax.argument(named: "isPresented").flatMap({ Binding<Bool>(syntax: $0.expression) }),
           let actions = syntax.argument(named: "actions").flatMap({ ViewReference<Library>(syntax: $0.expression) }),
           let message = syntax.argument(named: "message").flatMap({ ViewReference<Library>(syntax: $0.expression) }) {
            self = .titleIsPresentedActionsMessage(title: title, isPresented: isPresented, actions: actions, message: message)
            return
        }
        
        // Try to parse: alert("Title", isPresented: binding, actions: { ... })
        if let title = (syntax.arguments.first).flatMap({ String(syntax: $0.expression) }),
           let isPresented = syntax.argument(named: "isPresented").flatMap({ Binding<Bool>(syntax: $0.expression) }),
           let actions = syntax.argument(named: "actions").flatMap({ ViewReference<Library>(syntax: $0.expression) }) {
            self = .titleIsPresentedActions(title: title, isPresented: isPresented, actions: actions)
            return
        }
        
        throw ModifierParseError.noMatchingVariant(modifier: "AlertModifier", errors: [])
    }
    
    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .titleIsPresentedActions(let title, let isPresented, let actions):
            _content.alert(title, isPresented: isPresented) {
                actions
            }
        case .titleIsPresentedActionsMessage(let title, let isPresented, let actions, let message):
            _content.alert(title, isPresented: isPresented) {
                actions
            } message: {
                message
            }
        }
    }
}
