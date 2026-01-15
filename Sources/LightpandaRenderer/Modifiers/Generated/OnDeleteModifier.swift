import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for handling delete actions on list items.
/// The delete action dispatches a custom event with the indices to delete.
///
/// Usage:
/// ```html
/// <!-- Apply to elements whose children should be deletable -->
/// <!-- Dispatches "delete" event (default) with indices in detail -->
/// <list modifiers="onDelete()">
///   <text>Item 1</text>
///   <text>Item 2</text>
/// </list>
///
/// <!-- Dispatches "removeItems" event -->
/// <list modifiers="onDelete(perform: removeItems)">
///   ...
/// </list>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("delete", (e) => {
///     console.log("Delete indices:", e.detail.indices); // Array of indices
/// });
/// ```
public enum OnDeleteModifier<Library: ElementLibrary>: @unchecked Sendable {
    case onDelete(perform: String)
}

extension OnDeleteModifier: RuntimeViewModifier {
    public static var baseName: String { "onDelete" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let perform = syntax.argument(named: "perform").flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "delete"
        self = .onDelete(perform: perform)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .onDelete(let perform):
            OnDeleteModifierBody<Library>(eventName: perform)
        }
    }
}

/// Helper view that creates a ForEach with onDelete support.
/// Since onDelete only works on DynamicViewContent, we create a ForEach over the node's children.
private struct OnDeleteModifierBody<Library: ElementLibrary>: View {
    let eventName: String

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        ForEach(node.children) { child in
            NodeView<Library>(node: child)
        }
        .onDelete { indexSet in
            let indices = Array(indexSet)
            Task {
                try? await node.callFunction(
                    runtime: runtime,
                    function: #"""
                    function() {
                        this.dispatchEvent(new CustomEvent("\#(eventName)", {
                            bubbles: true,
                            detail: { indices: \#(indices) }
                        }));
                    }
                    """#
                )
            }
        }
    }
}
