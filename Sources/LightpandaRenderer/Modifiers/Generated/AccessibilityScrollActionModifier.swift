import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for adding an accessibility scroll action to the view.
/// The scroll action dispatches a custom event with the scroll edge direction.
///
/// Usage:
/// ```html
/// <!-- Dispatches "accessibilityScroll" event (default) -->
/// <scrollview modifiers="accessibilityScrollAction()">
///   ...
/// </scrollview>
///
/// <!-- Dispatches "scroll" event -->
/// <scrollview modifiers="accessibilityScrollAction(scroll)">
///   ...
/// </scrollview>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("accessibilityScroll", (e) => {
///     console.log("Scroll direction:", e.detail); // "top", "bottom", "leading", "trailing"
/// });
/// ```
public enum AccessibilityScrollActionModifier<Library: ElementLibrary>: @unchecked Sendable {
    case accessibilityScrollAction(String)
}

extension AccessibilityScrollActionModifier: RuntimeViewModifier {
    public static var baseName: String { "accessibilityScrollAction" }

    public init(syntax: FunctionCallExprSyntax) throws {
        var errors: [Error] = []
        do {
            let handler = (syntax.arguments.count > 0 ? syntax.arguments[0] : nil).flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "accessibilityScroll"
            self = .accessibilityScrollAction(handler)
            return
        } catch {
            errors.append(error)
        }
        throw ModifierParseError.noMatchingVariant(modifier: "AccessibilityScrollActionModifier", errors: errors)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .accessibilityScrollAction(let handler):
            AccessibilityScrollActionBody(content: _content, eventName: handler)
        }
    }
}

struct AccessibilityScrollActionBody<Content: View>: View {
    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    let content: Content
    let eventName: String

    var body: some View {
        content.accessibilityScrollAction { edge in
            Task {
                _ = try? await node.callFunction(
                    runtime: runtime,
                    function: #"""
                    function() {
                        this.dispatchEvent(new CustomEvent("\#(eventName)", {
                            bubbles: true,
                            detail: \#(String(data: try JSONEncoder().encode(edge), encoding: .utf8) ?? "null")
                        }));
                    }
                    """#
                )
            }
        }
    }
}

extension Edge: Encodable {
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .top:
            try container.encode("top")
        case .bottom:
            try container.encode("bottom")
        case .leading:
            try container.encode("leading")
        case .trailing:
            try container.encode("trailing")
        }
    }
}
