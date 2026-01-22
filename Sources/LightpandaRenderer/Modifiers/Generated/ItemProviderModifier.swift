import SwiftUI
import SwiftSyntax
import LightpandaClient
import UniformTypeIdentifiers

/// Modifier for providing drag data for items in a ForEach or List.
/// The payload is read from the `data-drag-payload` attribute on the element,
/// or from the provided payload argument.
///
/// Usage:
/// ```html
/// <!-- Simple item provider with string payload -->
/// <text modifiers="itemProvider(\"item-1\")">Drag me</text>
///
/// <!-- Without payload - will use element's data-drag-payload attribute -->
/// <text modifiers="itemProvider()" data-drag-payload="custom-payload">Drag me</text>
/// ```
///
/// JavaScript:
/// ```javascript
/// // Set drag payload dynamically
/// element.setAttribute("data-drag-payload", "my-custom-data");
/// ```
#if os(iOS) || os(macOS)
public enum ItemProviderModifier<Library: ElementLibrary>: @unchecked Sendable {
    case itemProvider(payload: String?)
}

extension ItemProviderModifier: RuntimeViewModifier {
    public static var baseName: String { "itemProvider" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // Parse optional payload argument (first positional argument)
        let payload = syntax.arguments.first.flatMap { String(syntax: $0.expression) }
        self = .itemProvider(payload: payload)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .itemProvider(let payload):
            ItemProviderModifierBody<Library, Content>(payload: payload, content: _content)
        }
    }
}

/// Helper view that provides the item provider closure
private struct ItemProviderModifierBody<Library: ElementLibrary, Content: View>: View {
    let payload: String?
    let content: Content

    @Environment(Node.self) private var node

    var body: some View {
        content.itemProvider {
            // Use the provided payload, or fall back to the data-drag-payload attribute
            let text = payload ?? node.attributes["data-drag-payload"] ?? ""
            guard !text.isEmpty else { return nil }

            let provider = NSItemProvider()
            provider.registerDataRepresentation(forTypeIdentifier: UTType.plainText.identifier, visibility: .all) { completion in
                completion(text.data(using: .utf8), nil)
                return nil
            }
            return provider
        }
    }
}
#endif
