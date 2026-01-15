import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for handling move/reorder actions on list items.
/// The move action dispatches a custom event with source indices and destination index.
///
/// Usage:
/// ```html
/// <!-- Apply to elements whose children should be movable -->
/// <!-- Dispatches "move" event (default) with indices in detail -->
/// <list modifiers="onMove()">
///   <text>Item 1</text>
///   <text>Item 2</text>
/// </list>
///
/// <!-- Dispatches "reorder" event -->
/// <list modifiers="onMove(perform: reorder)">
///   ...
/// </list>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("move", (e) => {
///     console.log("Source indices:", e.detail.source); // Array of source indices
///     console.log("Destination:", e.detail.destination); // Destination index
/// });
/// ```
public enum OnMoveModifier<Library: ElementLibrary>: @unchecked Sendable {
    case onMove(perform: String)
}

extension OnMoveModifier: RuntimeViewModifier {
    public static var baseName: String { "onMove" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let perform = syntax.argument(named: "perform").flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "move"
        self = .onMove(perform: perform)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .onMove(let perform):
            OnMoveModifierBody<Library, Content>(eventName: perform, content: _content)
        }
    }
}

/// Helper view that creates a ForEach with onMove support.
/// Since onMove only works on DynamicViewContent, we create a ForEach over the node's children.
private struct OnMoveModifierBody<Library: ElementLibrary, Content: View>: View {
    let eventName: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        ForEach(node.children) { child in
            NodeView<Library>(node: child)
        }
        .onMove { indexSet, destination in
            let source = Array(indexSet)
            Task {
                try? await node.callFunction(
                    runtime: runtime,
                    function: #"""
                    function() {
                        this.dispatchEvent(new CustomEvent("\#(eventName)", {
                            bubbles: true,
                            detail: { source: \#(source), destination: \#(destination) }
                        }));
                    }
                    """#
                )
            }
        }
    }
}
