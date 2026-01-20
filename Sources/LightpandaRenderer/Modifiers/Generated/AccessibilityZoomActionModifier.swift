import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for handling accessibility zoom actions.
/// The zoom action dispatches a custom event on the element with the direction in the detail.
///
/// Usage:
/// ```html
/// <!-- Dispatches "accessibilityZoom" event (default) -->
/// <image modifiers="accessibilityZoomAction()">
///   ...
/// </image>
///
/// <!-- Dispatches "zoom" event -->
/// <image modifiers="accessibilityZoomAction(zoom)">
///   ...
/// </image>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("accessibilityZoom", (e) => {
///     console.log("Zoom direction:", e.detail); // "zoomIn" or "zoomOut"
/// });
/// ```
public enum AccessibilityZoomActionModifier<Library: ElementLibrary>: @unchecked Sendable {
    case accessibilityZoomAction(String)
}

extension AccessibilityZoomActionModifier: RuntimeViewModifier {
    public static var baseName: String { "accessibilityZoomAction" }

    public init(syntax: FunctionCallExprSyntax) throws {
        var errors: [Error] = []
        do {
            let handler = (syntax.arguments.count > 0 ? syntax.arguments[0] : nil).flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "accessibilityZoom"
            self = .accessibilityZoomAction(handler)
            return
        } catch {
            errors.append(error)
        }
        throw ModifierParseError.noMatchingVariant(modifier: "AccessibilityZoomActionModifier", errors: errors)
    }
    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .accessibilityZoomAction(let handler):
            AccessibilityZoomActionBody(content: _content, eventName: handler)
        }
    }
}

struct AccessibilityZoomActionBody<Content: View>: View {
    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    let content: Content
    let eventName: String

    var body: some View {
        content.accessibilityZoomAction { action in
            Task {
                _ = try? await node.callFunction(
                    runtime: runtime,
                    function: #"""
                    function() {
                        this.dispatchEvent(new CustomEvent("\#(eventName)", {
                            bubbles: true,
                            detail: \#(String(data: try JSONEncoder().encode(action.direction), encoding: .utf8) ?? "null")
                        }));
                    }
                    """#
                )
            }
        }
    }
}

extension AccessibilityZoomGestureAction.Direction: Encodable {
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .zoomIn:
            try container.encode("zoomIn")
        case .zoomOut:
            try container.encode("zoomOut")
        @unknown default:
            try container.encode(String(reflecting: self))
        }
    }
}
