import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for adding accessibility actions to views.
/// The action dispatches a custom event on the element when triggered by assistive technologies.
///
/// Usage:
/// ```html
/// <!-- Default accessibility action with custom event -->
/// <vstack modifiers="accessibilityAction(perform: activate)">
///   ...
/// </vstack>
///
/// <!-- Accessibility action with specific kind -->
/// <vstack modifiers="accessibilityAction(.escape, perform: close)">
///   ...
/// </vstack>
///
/// <!-- Named accessibility action -->
/// <vstack modifiers='accessibilityAction(named: "Delete", perform: deleteItem)'>
///   ...
/// </vstack>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("activate", (e) => {
///     console.log("Accessibility action triggered!");
/// });
/// ```
public enum AccessibilityActionModifier<Library: ElementLibrary>: @unchecked Sendable {
    case accessibilityActionKind(SwiftUI.AccessibilityActionKind, String)
    case accessibilityActionNamed(String, String)
}

extension AccessibilityActionModifier: RuntimeViewModifier {
    public static var baseName: String { "accessibilityAction" }

    public init(syntax: FunctionCallExprSyntax) throws {
        var errors: [Error] = []

        // Try: accessibilityAction(named: "Name", perform: eventName)
        do {
            guard let named = syntax.argument(named: "named").flatMap({ String(syntax: $0.expression) }) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "AccessibilityActionModifier", argument: "named")
            }
            let perform = syntax.argument(named: "perform").flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "accessibilityAction"
            self = .accessibilityActionNamed(named, perform)
            return
        } catch {
            errors.append(error)
        }

        // Try: accessibilityAction(.escape, perform: eventName) or accessibilityAction(perform: eventName)
        do {
            let kind: SwiftUI.AccessibilityActionKind = (syntax.arguments.first?.label == nil ? syntax.arguments.first : nil).flatMap({ SwiftUI.AccessibilityActionKind(syntax: $0.expression) }) ?? .default
            let perform = syntax.argument(named: "perform").flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "accessibilityAction"
            self = .accessibilityActionKind(kind, perform)
            return
        } catch {
            errors.append(error)
        }

        throw ModifierParseError.noMatchingVariant(modifier: "AccessibilityActionModifier", errors: errors)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .accessibilityActionKind(let kind, let eventName):
            AccessibilityActionKindBody(kind: kind, eventName: eventName, content: _content)
        case .accessibilityActionNamed(let name, let eventName):
            AccessibilityActionNamedBody(name: name, eventName: eventName, content: _content)
        }
    }
}

/// Helper view that dispatches a custom event when accessibility action is triggered
private struct AccessibilityActionKindBody<Content: View>: View {
    let kind: SwiftUI.AccessibilityActionKind
    let eventName: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.accessibilityAction(kind) {
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

/// Helper view that dispatches a custom event when named accessibility action is triggered
private struct AccessibilityActionNamedBody<Content: View>: View {
    let name: String
    let eventName: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.accessibilityAction(named: name) {
            Task {
                try? await node.callFunction(
                    runtime: runtime,
                    function: #"""
                    function() {
                        this.dispatchEvent(new CustomEvent("\#(eventName)", {
                            bubbles: true,
                            detail: { name: "\#(name)" }
                        }));
                    }
                    """#
                )
            }
        }
    }
}
