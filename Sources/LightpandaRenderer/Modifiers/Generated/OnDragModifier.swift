import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for making views draggable with string payloads using the legacy onDrag API.
/// The payload is a string that can be dropped onto drop destinations.
///
/// Usage:
/// ```html
/// <!-- Simple draggable with string payload -->
/// <text modifiers="onDrag(\"item-1\")">Drag me</text>
///
/// <!-- Draggable with preview -->
/// <text modifiers="onDrag(\"item-1\", preview: dragPreview)">
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
///
/// Note: This modifier uses the legacy `onDrag(_:)` API which takes a closure.
/// For the newer Transferable-based API, use `draggable(_:)` instead.
#if os(iOS) || os(macOS)
public enum OnDragModifier<Library: ElementLibrary>: @unchecked Sendable {
    case onDrag(payload: String, preview: ViewReference<Library>?)
}

extension OnDragModifier: RuntimeViewModifier {
    public static var baseName: String { "onDrag" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let payload = syntax.arguments.first.flatMap({ String(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "OnDragModifier", argument: "payload")
        }
        let preview = syntax.argument(named: "preview")
            .flatMap({ ViewReference<Library>(syntax: $0.expression) })
        self = .onDrag(payload: payload, preview: preview)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .onDrag(let payload, let preview):
            if let preview = preview {
                _content.onDrag({
                    NSItemProvider(object: payload as NSString)
                }, preview: {
                    preview
                })
            } else {
                _content.onDrag {
                    NSItemProvider(object: payload as NSString)
                }
            }
        }
    }
}
#endif
