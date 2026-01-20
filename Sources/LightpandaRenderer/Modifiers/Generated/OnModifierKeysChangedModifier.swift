import SwiftUI
import SwiftSyntax
import LightpandaClient

#if os(macOS)
/// Modifier for handling modifier key changes (Command, Option, Shift, Control).
/// The action dispatches a custom event on the element with old and new modifier states.
///
/// macOS 15+ only.
///
/// Usage:
/// ```html
/// <!-- Dispatches "modifierKeysChanged" event (default) -->
/// <vstack modifiers="onModifierKeysChanged()">
///   ...
/// </vstack>
///
/// <!-- Dispatches "modifiersChanged" event with mask for .option -->
/// <vstack modifiers="onModifierKeysChanged(mask: .option, action: modifiersChanged)">
///   ...
/// </vstack>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("modifierKeysChanged", (e) => {
///     console.log("Old modifiers:", e.detail.old);
///     console.log("New modifiers:", e.detail.new);
/// });
/// ```
public enum OnModifierKeysChangedModifier<Library: ElementLibrary>: @unchecked Sendable {
    case onModifierKeysChanged(mask: SwiftUICore.EventModifiers, initial: Bool, action: String)
}

extension OnModifierKeysChangedModifier: RuntimeViewModifier {
    public static var baseName: String { "onModifierKeysChanged" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let mask: SwiftUICore.EventModifiers = syntax.argument(named: "mask").flatMap({ SwiftUICore.EventModifiers(syntax: $0.expression) }) ?? .all
        let initial: Bool = syntax.argument(named: "initial").flatMap({ Bool(syntax: $0.expression) }) ?? true
        // Accept either unlabeled trailing argument or "action:" labeled argument
        let action: String
        if let actionArg = syntax.argument(named: "action") {
            action = actionArg.expression.as(DeclReferenceExprSyntax.self)?.baseName.text ?? "modifierKeysChanged"
        } else if syntax.arguments.count > 2,
                  let lastArg = syntax.arguments.last,
                  lastArg.label == nil,
                  let ref = lastArg.expression.as(DeclReferenceExprSyntax.self) {
            action = ref.baseName.text
        } else {
            action = "modifierKeysChanged"
        }
        self = .onModifierKeysChanged(mask: mask, initial: initial, action: action)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .onModifierKeysChanged(let mask, let initial, let action):
            OnModifierKeysChangedModifierBody(mask: mask, initial: initial, eventName: action, content: _content)
        }
    }
}

/// Helper view that dispatches a custom event when modifier keys change
private struct OnModifierKeysChangedModifierBody<Content: View>: View {
    let mask: SwiftUICore.EventModifiers
    let initial: Bool
    let eventName: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.onModifierKeysChanged(mask: mask, initial: initial) { old, new in
            let oldArray = eventModifiersToArray(old)
            let newArray = eventModifiersToArray(new)
            Task {
                try? await node.callFunction(
                    runtime: runtime,
                    function: #"""
                    function() {
                        this.dispatchEvent(new CustomEvent("\#(eventName)", {
                            bubbles: true,
                            detail: {
                                old: \#(oldArray),
                                new: \#(newArray)
                            }
                        }));
                    }
                    """#
                )
            }
        }
    }

    /// Convert EventModifiers to a JSON array of strings for JavaScript
    private func eventModifiersToArray(_ modifiers: SwiftUICore.EventModifiers) -> String {
        var names: [String] = []
        if modifiers.contains(.capsLock) { names.append("\"capsLock\"") }
        if modifiers.contains(.shift) { names.append("\"shift\"") }
        if modifiers.contains(.control) { names.append("\"control\"") }
        if modifiers.contains(.option) { names.append("\"option\"") }
        if modifiers.contains(.command) { names.append("\"command\"") }
        if modifiers.contains(.numericPad) { names.append("\"numericPad\"") }
        if modifiers.contains(.function) { names.append("\"function\"") }
        return "[\(names.joined(separator: ", "))]"
    }
}
#endif
