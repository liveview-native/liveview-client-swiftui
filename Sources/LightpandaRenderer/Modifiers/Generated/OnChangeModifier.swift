import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for handling attribute value changes.
/// The change action dispatches a custom event on the element when the observed attribute changes.
///
/// Usage:
/// ```html
/// <!-- Observe "count" attribute and dispatch "countChanged" event (default) -->
/// <vstack modifiers="onChange(of: count)">
///   ...
/// </vstack>
///
/// <!-- Observe "count" attribute and dispatch "valueUpdated" event -->
/// <vstack modifiers="onChange(of: count, perform: valueUpdated)">
///   ...
/// </vstack>
///
/// <!-- With initial: true to dispatch on first render too -->
/// <vstack modifiers="onChange(of: count, initial: true, perform: valueUpdated)">
///   ...
/// </vstack>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("countChanged", (e) => {
///     console.log("Count changed:", e.detail.oldValue, "->", e.detail.newValue);
/// });
///
/// element.addEventListener("valueUpdated", (e) => {
///     console.log("Value updated:", e.detail.newValue);
/// });
/// ```
public enum OnChangeModifier<Library: ElementLibrary>: @unchecked Sendable {
    case onChange(of: String, initial: Bool, perform: String)
}

extension OnChangeModifier: RuntimeViewModifier {
    public static var baseName: String { "onChange" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // Parse the attribute name from the "of:" argument (must be an identifier)
        guard let attributeName = syntax.argument(named: "of").flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "OnChangeModifier", argument: "of")
        }

        let initial = syntax.argument(named: "initial").flatMap({ Bool(syntax: $0.expression) }) ?? false

        // Parse the event name from "perform:" argument, default to "{attributeName}Changed"
        let perform = syntax.argument(named: "perform").flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "\(attributeName)Changed"

        self = .onChange(of: attributeName, initial: initial, perform: perform)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .onChange(let attributeName, let initial, let eventName):
            OnChangeModifierBody(attributeName: attributeName, initial: initial, eventName: eventName, content: _content)
        }
    }
}

/// Helper view that dispatches a custom event when the observed attribute changes
private struct OnChangeModifierBody<Content: View>: View {
    let attributeName: String
    let initial: Bool
    let eventName: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    private var observedValue: String? {
        node.attributes[attributeName]
    }

    var body: some View {
        content.onChange(of: observedValue, initial: initial) { oldValue, newValue in
            Task {
                let oldValueJS = oldValue.map { "\"\($0)\"" } ?? "null"
                let newValueJS = newValue.map { "\"\($0)\"" } ?? "null"
                _ = try? await node.callFunction(
                    runtime: runtime,
                    function: #"""
                    function() {
                        this.dispatchEvent(new CustomEvent("\#(eventName)", {
                            bubbles: true,
                            detail: { oldValue: \#(oldValueJS), newValue: \#(newValueJS) }
                        }));
                    }
                    """#
                )
            }
        }
    }
}
