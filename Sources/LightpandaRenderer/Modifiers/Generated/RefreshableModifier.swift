import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for adding pull-to-refresh functionality to scrollable views.
/// The refresh action dispatches a "refresh" event on the element.
///
/// Usage:
/// ```html
/// <list modifiers="refreshable()" onRefresh={(e) => handleRefresh()}>
///   ...
/// </list>
/// ```
public enum RefreshableModifier<Library: ElementLibrary>: @unchecked Sendable {
    case refreshable
}

extension RefreshableModifier: RuntimeViewModifier {
    public static var baseName: String { "refreshable" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // .refreshable() takes no arguments - the action is dispatched as an event
        self = .refreshable
    }
    
    @ViewBuilder
    public func body(content _content: Content) -> some View {
        RefreshableModifierBody(content: _content)
    }
}

/// Helper view that dispatches a refresh event when pulled
private struct RefreshableModifierBody<Content: View>: View {
    let content: Content
    
    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime
    
    var body: some View {
        content.refreshable {
            // Dispatch a refresh event to JavaScript
            try? await node.callFunction(
                runtime: runtime,
                function: #"""
                function() {
                    this.dispatchEvent(new CustomEvent("refresh", {
                        bubbles: true,
                        detail: {}
                    }));
                }
                """#
            )
        }
    }
}
