import SwiftUI
import SwiftSyntax
import LightpandaClient
import UniformTypeIdentifiers

/// Modifier for handling the system Paste command on macOS.
/// Dispatches events when content is pasted using the system paste command.
///
/// Usage:
/// ```html
/// <!-- Paste command that accepts specific content types -->
/// <vstack modifiers="onPasteCommand(of: [.plainText, .pdf], perform: itemPasted)">
///   Content that accepts paste
/// </vstack>
///
/// <!-- With default event name "paste" -->
/// <vstack modifiers="onPasteCommand(of: [.image])">
///   Content that accepts paste
/// </vstack>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("itemPasted", (e) => {
///     console.log("Paste occurred with provider count:", e.detail.providerCount);
/// });
/// ```
///
/// Note: NSItemProvider data cannot be directly serialized to JavaScript.
/// The event includes metadata about the paste operation including provider count.
#if os(macOS)
@available(macOS 11.0, *)
public enum OnPasteCommandModifier<Library: ElementLibrary>: @unchecked Sendable {
    case onPasteCommand(of: [UTType], perform: String)
}

@available(macOS 11.0, *)
extension OnPasteCommandModifier: RuntimeViewModifier {
    public static var baseName: String { "onPasteCommand" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let supportedTypes = syntax.argument(named: "of").flatMap({ [UTType](syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "OnPasteCommandModifier", argument: "of")
        }
        let perform = syntax.argument(named: "perform")
            .flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "paste"
        self = .onPasteCommand(of: supportedTypes, perform: perform)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .onPasteCommand(let supportedTypes, let perform):
            OnPasteCommandModifierBody(
                supportedTypes: supportedTypes,
                performEvent: perform,
                content: _content
            )
        }
    }
}

@available(macOS 11.0, *)
private struct OnPasteCommandModifierBody<Content: View>: View {
    let supportedTypes: [UTType]
    let performEvent: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.onPasteCommand(of: supportedTypes) { providers in
            Task {
                try? await node.callFunction(
                    runtime: runtime,
                    function: #"""
                    function() {
                        this.dispatchEvent(new CustomEvent("\#(performEvent)", {
                            bubbles: true,
                            detail: {
                                providerCount: \#(providers.count)
                            }
                        }));
                    }
                    """#
                )
            }
        }
    }
}
#endif
