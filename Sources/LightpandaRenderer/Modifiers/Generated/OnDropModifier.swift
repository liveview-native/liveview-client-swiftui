import SwiftUI
import SwiftSyntax
import LightpandaClient
import UniformTypeIdentifiers

/// Modifier for handling dropped content using the legacy onDrop API with UTType arrays.
/// Dispatches events when items are dropped onto the view.
///
/// Usage:
/// ```html
/// <!-- Drop destination that accepts specific content types -->
/// <vstack modifiers="onDrop(of: [.image, .pdf], perform: itemDropped)">
///   Drop items here
/// </vstack>
///
/// <!-- With targeting indicator -->
/// <vstack modifiers="onDrop(of: [.plainText], isTargeted: dropTargeting, perform: itemDropped)">
///   Drop items here
/// </vstack>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("itemDropped", (e) => {
///     console.log("Drop location:", e.detail.location);
///     // Note: NSItemProvider data cannot be serialized to JS
///     // Use dropDestination modifier for Transferable types
/// });
///
/// element.addEventListener("dropTargeting", (e) => {
///     console.log("Is targeted:", e.detail.isTargeted);
/// });
/// ```
#if os(iOS) || os(macOS)
public enum OnDropModifier<Library: ElementLibrary>: @unchecked Sendable {
    case onDrop(of: [UTType], isTargeted: String?, perform: String)
}

extension OnDropModifier: RuntimeViewModifier {
    public static var baseName: String { "onDrop" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let supportedTypes = syntax.argument(named: "of").flatMap({ [UTType](syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "OnDropModifier", argument: "of")
        }
        let isTargeted = syntax.argument(named: "isTargeted")
            .flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text })
        let perform = syntax.argument(named: "perform")
            .flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "drop"
        self = .onDrop(of: supportedTypes, isTargeted: isTargeted, perform: perform)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .onDrop(let supportedTypes, let isTargeted, let perform):
            OnDropModifierBody(
                supportedTypes: supportedTypes,
                performEvent: perform,
                isTargetedEvent: isTargeted,
                content: _content
            )
        }
    }
}

private struct OnDropModifierBody<Content: View>: View {
    let supportedTypes: [UTType]
    let performEvent: String
    let isTargetedEvent: String?
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    @State private var isTargeted = false

    var body: some View {
        content.onDrop(of: supportedTypes, isTargeted: isTargetedBinding) { providers, location in
            Task {
                try? await node.callFunction(
                    runtime: runtime,
                    function: #"""
                    function() {
                        this.dispatchEvent(new CustomEvent("\#(performEvent)", {
                            bubbles: true,
                            detail: {
                                location: { x: \#(location.x), y: \#(location.y) },
                                providerCount: \#(providers.count)
                            }
                        }));
                    }
                    """#
                )
            }
            return true
        }
    }

    private var isTargetedBinding: Binding<Bool>? {
        guard isTargetedEvent != nil else { return nil }
        return Binding(
            get: { isTargeted },
            set: { newValue in
                isTargeted = newValue
                guard let isTargetedEvent = isTargetedEvent else { return }
                Task {
                    try? await node.callFunction(
                        runtime: runtime,
                        function: #"""
                        function() {
                            this.dispatchEvent(new CustomEvent("\#(isTargetedEvent)", {
                                bubbles: true,
                                detail: { isTargeted: \#(newValue) }
                            }));
                        }
                        """#
                    )
                }
            }
        )
    }
}
#endif
