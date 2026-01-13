import SwiftUI
import SwiftSyntax
import LightpandaClient
import UniformTypeIdentifiers

/// Modifier for making views draggable with string payloads.
/// The payload is a string that can be dropped onto drop destinations.
///
/// Usage:
/// ```html
/// <!-- Simple draggable with string payload -->
/// <text modifiers="draggable(\"item-1\")">Drag me</text>
///
/// <!-- Draggable with preview -->
/// <text modifiers="draggable(\"item-1\", preview: dragPreview)">
///   Drag me
///   <text template="dragPreview">Dragging...</text>
/// </text>
/// ```
///
/// JavaScript:
/// ```javascript
/// // Access the payload from the element's data attribute
/// element.dataset.dragPayload = "custom-payload";
/// ```
#if os(iOS) || os(macOS)
public enum DraggableModifier<Library: ElementLibrary>: @unchecked Sendable {
    case draggable(payload: String, preview: ViewReference<Library>?)
}

extension DraggableModifier: RuntimeViewModifier {
    public static var baseName: String { "draggable" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let payload = syntax.arguments.first.flatMap({ String(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "DraggableModifier", argument: "payload")
        }
        let preview = syntax.argument(named: "preview")
            .flatMap({ ViewReference<Library>(syntax: $0.expression) })
        self = .draggable(payload: payload, preview: preview)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .draggable(let payload, let preview):
            if let preview = preview {
                _content.draggable(payload) {
                    preview
                }
            } else {
                _content.draggable(payload)
            }
        }
    }
}
#endif
