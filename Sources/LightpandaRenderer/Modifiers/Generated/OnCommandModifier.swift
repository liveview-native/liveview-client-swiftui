#if os(macOS)
import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for handling Objective-C selector commands (macOS only).
/// The action dispatches a custom event on the element.
///
/// Usage:
/// ```html
/// <!-- Dispatches "command" event (default) when selector is invoked -->
/// <vstack modifiers='onCommand(#selector(NSResponder.selectAll(_:)), perform: selectAll)'>
///   ...
/// </vstack>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("selectAll", (e) => {
///     console.log("Select all command triggered!");
/// });
/// ```
public enum OnCommandModifier<Library: ElementLibrary>: @unchecked Sendable {
    case onCommand(selector: ObjectiveC.Selector, perform: String)
}

extension OnCommandModifier: RuntimeViewModifier {
    public static var baseName: String { "onCommand" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let selectorArg = (syntax.arguments.count > 0 ? syntax.arguments[syntax.arguments.startIndex] : nil),
              let selector = ObjectiveC.Selector(syntax: selectorArg.expression) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "OnCommandModifier", argument: "selector")
        }
        let perform = syntax.argument(named: "perform").flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "command"
        self = .onCommand(selector: selector, perform: perform)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .onCommand(let selector, let perform):
            OnCommandModifierBody(selector: selector, eventName: perform, content: _content)
        }
    }
}

/// Helper view that dispatches a custom event when the command is invoked
private struct OnCommandModifierBody<Content: View>: View {
    let selector: ObjectiveC.Selector
    let eventName: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.onCommand(selector) {
            Task {
                try? await node.callFunction(
                    runtime: runtime,
                    function: #"""
                    function() {
                        this.dispatchEvent(new CustomEvent("\#(eventName)", {
                            bubbles: true,
                            detail: { selector: "\#(selector)" }
                        }));
                    }
                    """#
                )
            }
        }
    }
}
#endif
