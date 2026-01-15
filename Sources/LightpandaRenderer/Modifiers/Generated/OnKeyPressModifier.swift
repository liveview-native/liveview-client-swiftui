import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for handling key press events on focusable views.
/// The action dispatches a custom event on the element with key information.
///
/// Usage:
/// ```html
/// <!-- Listen for Return key, dispatches "keyPress" event (default) -->
/// <textfield modifiers='focusable().onKeyPress(.return, action: submit)' />
///
/// <!-- Listen for Escape key with custom event name -->
/// <vstack modifiers='focusable().onKeyPress(.escape, action: cancel)'>
///   ...
/// </vstack>
///
/// <!-- Listen for character key -->
/// <vstack modifiers='focusable().onKeyPress("a", action: pressedA)'>
///   ...
/// </vstack>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("submit", (e) => {
///     console.log("Key pressed:", e.detail.key);
/// });
/// ```
#if os(iOS) || os(macOS)
@available(iOS 17.0, macOS 14.0, *)
public enum OnKeyPressModifier<Library: ElementLibrary>: @unchecked Sendable {
    case onKeyPress(key: KeyEquivalent, action: String)
}

@available(iOS 17.0, macOS 14.0, *)
extension OnKeyPressModifier: RuntimeViewModifier {
    public static var baseName: String { "onKeyPress" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // Parse key (first argument, required)
        guard let firstArg = syntax.arguments.first,
              let key = KeyEquivalent(syntax: firstArg.expression) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "OnKeyPressModifier", argument: "key")
        }

        // Parse action (event name), defaults to "keyPress"
        let action = syntax.argument(named: "action")
            .flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "keyPress"

        self = .onKeyPress(key: key, action: action)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .onKeyPress(let key, let action):
            OnKeyPressModifierBody(key: key, eventName: action, content: _content)
        }
    }
}

/// Helper view that dispatches a custom event when the key is pressed
@available(iOS 17.0, macOS 14.0, *)
private struct OnKeyPressModifierBody<Content: View>: View {
    let key: KeyEquivalent
    let eventName: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.onKeyPress(key) {
            Task {
                try? await node.callFunction(
                    runtime: runtime,
                    function: #"""
                    function() {
                        this.dispatchEvent(new CustomEvent("\#(eventName)", {
                            bubbles: true,
                            detail: { key: "\#(keyDescription)" }
                        }));
                    }
                    """#
                )
            }
            return .handled
        }
    }

    private var keyDescription: String {
        switch key {
        case .return: return "return"
        case .tab: return "tab"
        case .space: return "space"
        case .clear: return "clear"
        case .delete: return "delete"
        case .deleteForward: return "deleteForward"
        case .upArrow: return "upArrow"
        case .downArrow: return "downArrow"
        case .leftArrow: return "leftArrow"
        case .rightArrow: return "rightArrow"
        case .pageUp: return "pageUp"
        case .pageDown: return "pageDown"
        case .home: return "home"
        case .end: return "end"
        case .escape: return "escape"
        default: return String(key.character)
        }
    }
}
#endif
