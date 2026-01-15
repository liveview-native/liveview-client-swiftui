import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for adding rename action functionality.
/// The rename action dispatches a custom event on the element when triggered.
///
/// Usage:
/// ```html
/// <!-- Dispatches "rename" event (default) -->
/// <vstack modifiers="renameAction()">
///   ...
/// </vstack>
///
/// <!-- Dispatches "startRename" event -->
/// <vstack modifiers="renameAction(action: startRename)">
///   ...
/// </vstack>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("rename", (e) => {
///     console.log("Rename action triggered");
/// });
/// ```
#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public enum RenameActionModifier<Library: ElementLibrary>: @unchecked Sendable {
    case renameAction(action: String)
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension RenameActionModifier: RuntimeViewModifier {
    public static var baseName: String { "renameAction" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let action = syntax.argument(named: "action").flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "rename"
        self = .renameAction(action: action)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .renameAction(let action):
            RenameActionModifierBody(eventName: action, content: _content)
        }
    }
}

/// Helper view that dispatches a custom event when rename action is triggered
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
private struct RenameActionModifierBody<Content: View>: View {
    let eventName: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.renameAction {
            Task {
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
}
#endif
