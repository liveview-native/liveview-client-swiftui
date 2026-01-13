import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for attaching simultaneous gestures to views.
/// Simultaneous gestures can be recognized at the same time as other gestures.
/// Gesture callbacks dispatch events to JavaScript.
///
/// Usage:
/// ```html
/// <!-- Simultaneous drag gesture -->
/// <vstack modifiers="simultaneousGesture(DragGesture().onChanged(dragging).onEnded(dragEnd))">
///
/// <!-- Simultaneous rotation gesture -->
/// <vstack modifiers="simultaneousGesture(RotationGesture().onChanged(rotating).onEnded(rotateEnd))">
///
/// <!-- With gesture mask -->
/// <vstack modifiers="simultaneousGesture(TapGesture().onEnded(tapped), including: .gesture)">
///
/// <!-- With isEnabled control -->
/// <vstack modifiers="simultaneousGesture(TapGesture().onEnded(tapped), isEnabled: false)">
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("dragging", (e) => {
///     console.log("Drag location:", e.detail.location);
/// });
/// ```
public enum SimultaneousGestureModifier<Library: ElementLibrary>: @unchecked Sendable {
    case simultaneousGesture(ParsedGesture, including: GestureMask, isEnabled: Bool)
}

extension SimultaneousGestureModifier: RuntimeViewModifier {
    public static var baseName: String { "simultaneousGesture" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let gesture = syntax.arguments.first.flatMap({ ParsedGesture(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "SimultaneousGestureModifier", argument: "gesture")
        }
        let including = syntax.argument(named: "including")
            .flatMap({ GestureMask(syntax: $0.expression) }) ?? .all
        let isEnabled = syntax.argument(named: "isEnabled")
            .flatMap({ Bool(syntax: $0.expression) }) ?? true
        self = .simultaneousGesture(gesture, including: including, isEnabled: isEnabled)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .simultaneousGesture(let gesture, let including, let isEnabled):
            SimultaneousGestureModifierBody(
                gesture: gesture,
                including: including,
                isEnabled: isEnabled,
                content: _content
            )
        }
    }
}

private struct SimultaneousGestureModifierBody<Content: View>: View {
    let gesture: ParsedGesture
    let including: GestureMask
    let isEnabled: Bool
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        if isEnabled {
            content.simultaneousGesture(
                gesture.makeGesture(node: node, runtime: runtime),
                including: including
            )
        } else {
            content
        }
    }
}
