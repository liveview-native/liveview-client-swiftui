import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for drag container selection.
///
/// Provides multiple item selection support for drag containers.
/// The selection is bound to an attribute on the element, with selection IDs as a JSON array of strings.
///
/// ## Usage
/// ```html
/// <!-- Selection is bound to the 'selectedItems' attribute -->
/// <list modifiers="dragContainerSelection($selectedItems, containerNamespace: dragNamespace)">
///     <!-- List content -->
/// </list>
/// ```
///
/// ## JavaScript Event Handling
/// ```javascript
/// // Listen for selection changes
/// element.addEventListener("selecteditemschanged", (event) => {
///     console.log("Selection changed:", event.detail.value);
/// });
///
/// // Get current selection
/// const selection = JSON.parse(element.getAttribute("selecteditems") || "[]");
///
/// // Set selection programmatically
/// element.setAttribute("selecteditems", JSON.stringify(["item1", "item2"]));
/// ```
///
/// ## Parameters
/// - `selection`: A binding to the selection (use `$attributeName` syntax)
/// - `containerNamespace`: Optional namespace ID (references a parent `<namespacecontext id="...">`)
#if os(macOS)
@available(macOS 26.0, *)
@MainActor
public enum DragContainerSelectionModifier<Library: ElementLibrary>: @unchecked Sendable {
    /// dragContainerSelection($selection, containerNamespace: namespace)
    case dragContainerSelection(selection: NodeBinding<Set<String>>, containerNamespace: String?)
}

@available(macOS 26.0, *)
extension DragContainerSelectionModifier: RuntimeViewModifier {
    public static var baseName: String { "dragContainerSelection" }

    public init(syntax: FunctionCallExprSyntax) throws {
        var errors: [Error] = []
        do {
            // Parse the selection binding ($identifier syntax)
            guard let selection = (syntax.arguments.first).flatMap({ NodeBinding<Set<String>>(syntax: $0.expression) }) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "DragContainerSelectionModifier", argument: "selection")
            }

            // Parse containerNamespace as identifier (e.g., dragNamespace) or string literal (e.g., "dragNamespace"), or nil
            let containerNamespace: String?
            if let identifierName = syntax.argument(named: "containerNamespace")?.expression.as(DeclReferenceExprSyntax.self)?.baseName.text {
                containerNamespace = identifierName
            } else if let stringLiteral = syntax.argument(named: "containerNamespace").flatMap({ String(syntax: $0.expression) }) {
                containerNamespace = stringLiteral
            } else if let nilLiteral = syntax.argument(named: "containerNamespace")?.expression.as(NilLiteralExprSyntax.self) {
                _ = nilLiteral
                containerNamespace = nil
            } else if syntax.argument(named: "containerNamespace") == nil {
                // No containerNamespace argument provided - that's fine, it's optional
                containerNamespace = nil
            } else {
                throw ModifierParseError.invalidArgumentValue(modifier: "DragContainerSelectionModifier", argument: "containerNamespace", reason: "expected namespace identifier, string, or nil")
            }

            self = .dragContainerSelection(selection: selection, containerNamespace: containerNamespace)
            return
        } catch {
            errors.append(error)
        }
        throw ModifierParseError.noMatchingVariant(modifier: "DragContainerSelectionModifier", errors: errors)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        DragContainerSelectionModifierBody<Library>(modifier: self, content: _content)
    }
}

/// Internal view that resolves NodeBinding to Binding at runtime using environment.
@available(macOS 26.0, *)
private struct DragContainerSelectionModifierBody<Library: ElementLibrary>: View {
    let modifier: DragContainerSelectionModifier<Library>
    let content: DragContainerSelectionModifier<Library>.Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime
    @Environment(\.namespaces) private var namespaces

    var body: some View {
        switch modifier {
        case .dragContainerSelection(let selection, let containerNamespace):
            let setBinding: Binding<Set<String>> = selection.binding(node: node, runtime: runtime)
            // Get the current selection as an array for dragContainerSelection
            let selectionArray: [String] = Array(setBinding.wrappedValue)
            if let namespaceId = containerNamespace, let namespace = namespaces[namespaceId] {
                content.dragContainerSelection(selectionArray, containerNamespace: namespace)
            } else {
                content.dragContainerSelection(selectionArray)
            }
        }
    }
}
#endif
