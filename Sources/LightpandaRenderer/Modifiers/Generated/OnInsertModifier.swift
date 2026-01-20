import SwiftUI
import SwiftSyntax
import LightpandaClient
import UniformTypeIdentifiers

/// Modifier for handling insert actions on dynamic view content (e.g., ForEach).
/// The insert action dispatches a custom event with the index and item providers.
///
/// Usage:
/// ```html
/// <!-- Apply to elements whose children should accept inserts -->
/// <!-- Dispatches "insert" event (default) with index and providers in detail -->
/// <list modifiers='onInsert(of: ["public.text"])'>
///   <text>Item 1</text>
///   <text>Item 2</text>
/// </list>
///
/// <!-- Using UTType identifiers -->
/// <list modifiers='onInsert(of: [.plainText, .url], perform: dropped)'>
///   ...
/// </list>
///
/// <!-- Dispatches custom "dropped" event -->
/// <list modifiers='onInsert(of: ["public.text"], perform: dropped)'>
///   ...
/// </list>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("insert", (e) => {
///     console.log("Index:", e.detail.index); // Index where items should be inserted
///     console.log("Provider count:", e.detail.providerCount); // Number of NSItemProviders
/// });
/// ```
public enum OnInsertModifier<Library: ElementLibrary>: @unchecked Sendable {
    case onInsert(of: [String], perform: String)
}

extension OnInsertModifier: RuntimeViewModifier {
    public static var baseName: String { "onInsert" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // Parse the 'of' parameter as an array of strings (type identifiers)
        guard let ofArg = syntax.argument(named: "of"),
              let typeIdentifiers = [String](syntax: ofArg.expression) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "OnInsertModifier", argument: "of")
        }

        // Parse the optional 'perform' parameter as an identifier for the event name
        let perform = syntax.argument(named: "perform")
            .flatMap { $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text } ?? "insert"

        self = .onInsert(of: typeIdentifiers, perform: perform)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .onInsert(let typeIdentifiers, let perform):
            OnInsertModifierBody<Library, Content>(
                typeIdentifiers: typeIdentifiers,
                eventName: perform,
                content: _content
            )
        }
    }
}

/// Helper view that creates a ForEach with onInsert support.
/// Since onInsert only works on DynamicViewContent, we create a ForEach over the node's children.
private struct OnInsertModifierBody<Library: ElementLibrary, Content: View>: View {
    let typeIdentifiers: [String]
    let eventName: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        ForEach(node.children) { child in
            NodeView<Library>(node: child)
        }
        .onInsert(of: typeIdentifiers) { index, providers in
            Task {
                try? await node.callFunction(
                    runtime: runtime,
                    function: #"""
                    function() {
                        this.dispatchEvent(new CustomEvent("\#(eventName)", {
                            bubbles: true,
                            detail: { index: \#(index), providerCount: \#(providers.count) }
                        }));
                    }
                    """#
                )
            }
        }
    }
}
