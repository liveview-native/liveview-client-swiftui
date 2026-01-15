import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for handling URL open events.
/// The perform action dispatches a custom event on the element with the URL in detail.
///
/// Usage:
/// ```html
/// <!-- Dispatches "openURL" event (default) -->
/// <vstack modifiers="onOpenURL()">
///   ...
/// </vstack>
///
/// <!-- Dispatches "handleLink" event -->
/// <vstack modifiers="onOpenURL(perform: handleLink)">
///   ...
/// </vstack>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("openURL", (e) => {
///     console.log("URL opened:", e.detail.url);
/// });
///
/// element.addEventListener("handleLink", (e) => {
///     console.log("Link handled:", e.detail.url);
/// });
/// ```
public enum OnOpenURLModifier<Library: ElementLibrary>: @unchecked Sendable {
    case onOpenURL(perform: String)
}

extension OnOpenURLModifier: RuntimeViewModifier {
    public static var baseName: String { "onOpenURL" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let perform = syntax.argument(named: "perform").flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "openURL"
        self = .onOpenURL(perform: perform)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .onOpenURL(let perform):
            OnOpenURLModifierBody(eventName: perform, content: _content)
        }
    }
}

/// Helper view that dispatches a custom event when a URL is opened
private struct OnOpenURLModifierBody<Content: View>: View {
    let eventName: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.onOpenURL { url in
            Task {
                try? await node.callFunction(
                    runtime: runtime,
                    function: #"""
                    function() {
                        this.dispatchEvent(new CustomEvent("\#(eventName)", {
                            bubbles: true,
                            detail: { url: "\#(url.absoluteString)" }
                        }));
                    }
                    """#
                )
            }
        }
    }
}