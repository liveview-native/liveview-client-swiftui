#if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
import SwiftUI
import SwiftSyntax
import LightpandaClient

/// ActionSheet presentation modifier using NodeBinding for `$identifier` syntax.
///
/// NOTE: ActionSheet is deprecated as of iOS 15. Consider using `confirmationDialog` instead.
///
/// ## Usage
/// ```html
/// <vstack modifiers='actionSheet("Choose Option", isPresented: $showSheet, buttons: sheetButtons)'>
///     <button template="sheetButtons">
///         <text template="label">Option 1</text>
///     </button>
///     <button>
///         <text template="label">Show Action Sheet</text>
///     </button>
/// </vstack>
/// ```
///
/// ## With Message
/// ```html
/// <vstack modifiers='actionSheet("Title", isPresented: $showSheet, message: "Pick an option", buttons: sheetButtons)'>
///     ...
/// </vstack>
/// ```
@available(iOS, deprecated: 15.0, message: "Use confirmationDialog instead")
@available(tvOS, deprecated: 15.0, message: "Use confirmationDialog instead")
@available(watchOS, deprecated: 8.0, message: "Use confirmationDialog instead")
@available(visionOS, deprecated: 1.0, message: "Use confirmationDialog instead")
@MainActor
public enum ActionSheetModifier<Library: ElementLibrary>: @unchecked Sendable {
    /// actionSheet(title, isPresented: $binding, buttons: { ... })
    case titleIsPresentedButtons(title: String, isPresented: NodeBinding<Bool>, buttons: ViewReference<Library>)

    /// actionSheet(title, isPresented: $binding, message: "...", buttons: { ... })
    case titleIsPresentedMessageButtons(title: String, isPresented: NodeBinding<Bool>, message: String, buttons: ViewReference<Library>)
}

@available(iOS, deprecated: 15.0)
@available(tvOS, deprecated: 15.0)
@available(watchOS, deprecated: 8.0)
@available(visionOS, deprecated: 1.0)
extension ActionSheetModifier: RuntimeViewModifier {
    public static var baseName: String { "actionSheet" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // Try to parse: actionSheet("Title", isPresented: $binding, message: "...", buttons: { ... })
        if let title = (syntax.arguments.first).flatMap({ String(syntax: $0.expression) }),
           let isPresented = syntax.argument(named: "isPresented").flatMap({ NodeBinding<Bool>(syntax: $0.expression) }),
           let message = syntax.argument(named: "message").flatMap({ String(syntax: $0.expression) }),
           let buttons = syntax.argument(named: "buttons").flatMap({ ViewReference<Library>(syntax: $0.expression) }) {
            self = .titleIsPresentedMessageButtons(title: title, isPresented: isPresented, message: message, buttons: buttons)
            return
        }

        // Try to parse: actionSheet("Title", isPresented: $binding, buttons: { ... })
        if let title = (syntax.arguments.first).flatMap({ String(syntax: $0.expression) }),
           let isPresented = syntax.argument(named: "isPresented").flatMap({ NodeBinding<Bool>(syntax: $0.expression) }),
           let buttons = syntax.argument(named: "buttons").flatMap({ ViewReference<Library>(syntax: $0.expression) }) {
            self = .titleIsPresentedButtons(title: title, isPresented: isPresented, buttons: buttons)
            return
        }

        throw ModifierParseError.noMatchingVariant(modifier: "ActionSheetModifier", errors: [])
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        ActionSheetModifierBody<Library>(modifier: self, content: _content)
    }
}

@available(iOS, deprecated: 15.0)
@available(tvOS, deprecated: 15.0)
@available(watchOS, deprecated: 8.0)
@available(visionOS, deprecated: 1.0)
private struct ActionSheetModifierBody<Library: ElementLibrary>: View {
    let modifier: ActionSheetModifier<Library>
    let content: ActionSheetModifier<Library>.Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        switch modifier {
        case .titleIsPresentedButtons(let title, let isPresented, let buttons):
            content.confirmationDialog(title, isPresented: isPresented.binding(node: node, runtime: runtime), titleVisibility: .visible) {
                buttons
            }
        case .titleIsPresentedMessageButtons(let title, let isPresented, let message, let buttons):
            content.confirmationDialog(title, isPresented: isPresented.binding(node: node, runtime: runtime), titleVisibility: .visible) {
                buttons
            } message: {
                SwiftUI.Text(message)
            }
        }
    }
}
#endif
