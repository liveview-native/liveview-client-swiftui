import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for handling submit actions on text fields and other inputs.
/// The submit action dispatches a custom event on the element.
///
/// Usage:
/// ```html
/// <!-- Dispatches "submit" event (default) -->
/// <textfield modifiers="onSubmit()">
///
/// <!-- Dispatches "search" event -->
/// <textfield modifiers="onSubmit(action: search)">
///
/// <!-- With trigger type -->
/// <textfield modifiers="onSubmit(of: .search, action: performSearch)">
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("submit", (e) => {
///     console.log("Submitted!");
/// });
/// ```
public enum OnSubmitModifier<Library: ElementLibrary>: @unchecked Sendable {
    case onSubmit(of: SubmitTriggers, action: String)
}

extension OnSubmitModifier: RuntimeViewModifier {
    public static var baseName: String { "onSubmit" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let of = syntax.argument(named: "of").flatMap({ SubmitTriggers(syntax: $0.expression) }) ?? .text
        let action = syntax.argument(named: "action").flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "submit"
        self = .onSubmit(of: of, action: action)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .onSubmit(let of, let action):
            OnSubmitModifierBody(triggers: of, eventName: action, content: _content)
        }
    }
}

/// Helper view that dispatches a custom event when submit is triggered
private struct OnSubmitModifierBody<Content: View>: View {
    let triggers: SubmitTriggers
    let eventName: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.onSubmit(of: triggers) {
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

extension SubmitTriggers: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self),
              memberAccess.base == nil else { return nil }

        switch memberAccess.declName.baseName.text {
        case "text":
            self = .text
        case "search":
            self = .search
        default:
            return nil
        }
    }
}
