import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for handling scroll phase changes on scroll views.
/// The action dispatches a custom event on the element when the scroll phase changes.
///
/// Usage:
/// ```html
/// <!-- Dispatches "scrollPhaseChange" event (default) -->
/// <scrollview modifiers="onScrollPhaseChange()">
///   ...
/// </scrollview>
///
/// <!-- Dispatches "scrollStateChanged" event -->
/// <scrollview modifiers="onScrollPhaseChange(action: scrollStateChanged)">
///   ...
/// </scrollview>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("scrollPhaseChange", (e) => {
///     console.log("Scroll phase changed!", e.detail.oldPhase, e.detail.newPhase);
/// });
/// ```
#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)
@available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
public enum OnScrollPhaseChangeModifier<Library: ElementLibrary>: @unchecked Sendable {
    case onScrollPhaseChange(action: String)
}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
extension OnScrollPhaseChangeModifier: RuntimeViewModifier {
    public static var baseName: String { "onScrollPhaseChange" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let action = syntax.argument(named: "action").flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text })
            ?? (syntax.arguments.first?.expression.as(DeclReferenceExprSyntax.self)?.baseName.text)
            ?? "scrollPhaseChange"
        self = .onScrollPhaseChange(action: action)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .onScrollPhaseChange(let action):
            OnScrollPhaseChangeModifierBody(eventName: action, content: _content)
        }
    }
}

/// Helper view that dispatches a custom event when scroll phase changes
@available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
private struct OnScrollPhaseChangeModifierBody<Content: View>: View {
    let eventName: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.onScrollPhaseChange { oldPhase, newPhase in
            Task {
                try? await node.callFunction(
                    runtime: runtime,
                    function: #"""
                    function() {
                        this.dispatchEvent(new CustomEvent("\#(eventName)", {
                            bubbles: true,
                            detail: {
                                oldPhase: "\#(scrollPhaseName(oldPhase))",
                                newPhase: "\#(scrollPhaseName(newPhase))"
                            }
                        }));
                    }
                    """#
                )
            }
        }
    }

    private func scrollPhaseName(_ phase: ScrollPhase) -> String {
        switch phase {
        case .idle:
            return "idle"
        case .tracking:
            return "tracking"
        case .interacting:
            return "interacting"
        case .decelerating:
            return "decelerating"
        case .animating:
            return "animating"
        @unknown default:
            return "unknown"
        }
    }
}
#endif
