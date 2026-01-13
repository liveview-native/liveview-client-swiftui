import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for attaching high-priority gestures to views.
/// High-priority gestures take precedence over gestures defined by the containing view.
/// Gesture callbacks dispatch events to JavaScript.
///
/// Usage:
/// ```html
/// <!-- High-priority drag gesture -->
/// <vstack modifiers="highPriorityGesture(DragGesture().onChanged(dragging).onEnded(dragEnd))">
///
/// <!-- High-priority tap gesture -->
/// <vstack modifiers="highPriorityGesture(TapGesture().onEnded(tapped))">
///
/// <!-- With gesture mask -->
/// <vstack modifiers="highPriorityGesture(TapGesture().onEnded(tapped), including: .gesture)">
///
/// <!-- With isEnabled control -->
/// <vstack modifiers="highPriorityGesture(TapGesture().onEnded(tapped), isEnabled: false)">
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("dragging", (e) => {
///     console.log("Drag location:", e.detail.location);
/// });
/// ```
public enum HighPriorityGestureModifier<Library: ElementLibrary>: @unchecked Sendable {
    case highPriorityGesture(ParsedGesture, including: GestureMask, isEnabled: Bool)
}

extension HighPriorityGestureModifier: RuntimeViewModifier {
    public static var baseName: String { "highPriorityGesture" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let gesture = syntax.arguments.first.flatMap({ ParsedGesture(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "HighPriorityGestureModifier", argument: "gesture")
        }
        let including = syntax.argument(named: "including")
            .flatMap({ GestureMask(syntax: $0.expression) }) ?? .all
        let isEnabled = syntax.argument(named: "isEnabled")
            .flatMap({ Bool(syntax: $0.expression) }) ?? true
        self = .highPriorityGesture(gesture, including: including, isEnabled: isEnabled)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .highPriorityGesture(let gesture, let including, let isEnabled):
            HighPriorityGestureModifierBody(
                gesture: gesture,
                including: including,
                isEnabled: isEnabled,
                content: _content
            )
        }
    }
}

private struct HighPriorityGestureModifierBody<Content: View>: View {
    let gesture: ParsedGesture
    let including: GestureMask
    let isEnabled: Bool
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        if isEnabled {
            content.highPriorityGesture(
                gesture.makeGesture(node: node, runtime: runtime),
                including: including
            )
        } else {
            content
        }
    }
}
