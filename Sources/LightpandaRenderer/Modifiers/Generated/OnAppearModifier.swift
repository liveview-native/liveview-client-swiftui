import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for handling view appearance.
/// The appear action dispatches a custom event on the element.
///
/// Usage:
/// ```html
/// <!-- Dispatches "appear" event (default) -->
/// <vstack modifiers="onAppear()">
///   ...
/// </vstack>
///
/// <!-- Dispatches "viewLoaded" event -->
/// <vstack modifiers="onAppear(perform: viewLoaded)">
///   ...
/// </vstack>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("appear", (e) => {
///     console.log("View appeared!");
/// });
///
/// element.addEventListener("viewLoaded", (e) => {
///     console.log("View loaded!");
/// });
/// ```
public enum OnAppearModifier<Library: ElementLibrary>: @unchecked Sendable {
    case onAppear(perform: String)
}

extension OnAppearModifier: RuntimeViewModifier {
    public static var baseName: String { "onAppear" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let perform = syntax.argument(named: "perform").flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "appear"
        self = .onAppear(perform: perform)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .onAppear(let perform):
            OnAppearModifierBody(eventName: perform, content: _content)
        }
    }
}

/// Helper view that dispatches a custom event when the view appears
private struct OnAppearModifierBody<Content: View>: View {
    let eventName: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.onAppear {
            Task {
                try? await node.callFunction(
                    runtime: runtime,
                    function: #"""
                    function() {
                        this.dispatchEvent(new CustomEvent("\#(eventName)", {
                            bubbles: true,
                            detail: {}
                        }));
                    }
                    """#
                )
            }
        }
    }
}
