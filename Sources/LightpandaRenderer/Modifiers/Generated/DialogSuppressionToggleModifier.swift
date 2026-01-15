import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for dialog suppression toggle (macOS 14+).
///
/// Enables user suppression of dialogs and alerts presented within, with a custom
/// suppression message on macOS. This modifier is unused on other platforms.
///
/// ## Usage
/// ```html
/// <vstack modifiers='confirmationDialog("Delete?", isPresented: $showDelete, actions: deleteActions).dialogSuppressionToggle("Don't ask again", isSuppressed: $suppressDialog)'>
///     ...
/// </vstack>
/// ```
///
/// ## Event Handling
/// The `$suppressDialog` binding will dispatch a `suppressdialogchanged` event when toggled:
/// ```javascript
/// element.addEventListener("suppressdialogchanged", (event) => {
///     console.log("Suppression state:", event.detail.value);
/// });
/// ```
@MainActor
public enum DialogSuppressionToggleModifier<Library: ElementLibrary>: @unchecked Sendable {
    /// dialogSuppressionToggle("Title", isSuppressed: $binding)
    case titleIsSuppressed(title: String, isSuppressed: NodeBinding<Bool>)

    /// dialogSuppressionToggle(isSuppressed: $binding)
    case isSuppressed(isSuppressed: NodeBinding<Bool>)
}

extension DialogSuppressionToggleModifier: RuntimeViewModifier {
    public static var baseName: String { "dialogSuppressionToggle" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // Try to parse: dialogSuppressionToggle("Title", isSuppressed: $binding)
        if let title = (syntax.arguments.first).flatMap({ String(syntax: $0.expression) }),
           let isSuppressed = syntax.argument(named: "isSuppressed").flatMap({ NodeBinding<Bool>(syntax: $0.expression) }) {
            self = .titleIsSuppressed(title: title, isSuppressed: isSuppressed)
            return
        }

        // Try to parse: dialogSuppressionToggle(isSuppressed: $binding)
        if let isSuppressed = syntax.argument(named: "isSuppressed").flatMap({ NodeBinding<Bool>(syntax: $0.expression) }) {
            self = .isSuppressed(isSuppressed: isSuppressed)
            return
        }

        throw ModifierParseError.noMatchingVariant(modifier: "DialogSuppressionToggleModifier", errors: [])
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        DialogSuppressionToggleModifierBody<Library>(modifier: self, content: _content)
    }
}

/// Internal view that resolves NodeBinding to Binding at runtime using environment.
private struct DialogSuppressionToggleModifierBody<Library: ElementLibrary>: View {
    let modifier: DialogSuppressionToggleModifier<Library>
    let content: DialogSuppressionToggleModifier<Library>.Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        switch modifier {
        case .titleIsSuppressed(let title, let isSuppressed):
            content.dialogSuppressionToggle(title, isSuppressed: isSuppressed.binding(node: node, runtime: runtime))
        case .isSuppressed(let isSuppressed):
            content.dialogSuppressionToggle(isSuppressed: isSuppressed.binding(node: node, runtime: runtime))
        }
    }
}