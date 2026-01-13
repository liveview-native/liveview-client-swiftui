import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for attaching gestures to views.
/// Gesture callbacks dispatch events to JavaScript.
///
/// Usage:
/// ```html
/// <!-- Simple gestures with callbacks -->
/// <vstack modifiers="gesture(DragGesture().onChanged(dragging).onEnded(dragEnd))">
/// <vstack modifiers="gesture(TapGesture(count: 2).onEnded(doubleTapped))">
///
/// <!-- Gestures without explicit callbacks use default event names -->
/// <vstack modifiers="gesture(DragGesture())">  <!-- dispatches "drag" and "dragEnd" -->
///
/// <!-- Composed gestures -->
/// <vstack modifiers="gesture(LongPressGesture().sequenced(before: DragGesture()).onEnded(dragAfterPress))">
/// <vstack modifiers="gesture(MagnificationGesture().simultaneously(with: RotationGesture()).onChanged(transform))">
/// <vstack modifiers="gesture(TapGesture().exclusively(before: LongPressGesture()).onEnded(tapOrPress))">
///
/// <!-- With gesture mask -->
/// <vstack modifiers="gesture(TapGesture().onEnded(tapped), including: .gesture)">
///
/// <!-- With isEnabled control -->
/// <vstack modifiers="gesture(TapGesture().onEnded(tapped), isEnabled: false)">
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("dragging", (e) => {
///     console.log("Drag location:", e.detail.location);
/// });
/// ```
public enum GestureModifier<Library: ElementLibrary>: @unchecked Sendable {
    case gesture(ParsedGesture, including: GestureMask, isEnabled: Bool)
}

extension GestureModifier: RuntimeViewModifier {
    public static var baseName: String { "gesture" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let gesture = syntax.arguments.first.flatMap({ ParsedGesture(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "GestureModifier", argument: "gesture")
        }
        let including = syntax.argument(named: "including")
            .flatMap({ GestureMask(syntax: $0.expression) }) ?? .all
        let isEnabled = syntax.argument(named: "isEnabled")
            .flatMap({ Bool(syntax: $0.expression) }) ?? true
        self = .gesture(gesture, including: including, isEnabled: isEnabled)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .gesture(let gesture, let including, let isEnabled):
            GestureModifierBody(
                gesture: gesture,
                including: including,
                isEnabled: isEnabled,
                content: _content
            )
        }
    }
}

private struct GestureModifierBody<Content: View>: View {
    let gesture: ParsedGesture
    let including: GestureMask
    let isEnabled: Bool
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        if isEnabled {
            content.gesture(
                gesture.makeGesture(node: node, runtime: runtime),
                including: including
            )
        } else {
            content
        }
    }
}
