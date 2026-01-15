#if os(watchOS)
import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for tracking Digital Crown rotation on watchOS.
///
/// Supports the simplest form of digitalCrownRotation that takes a binding to a Double value.
///
/// Usage:
/// ```html
/// <vstack modifiers="digitalCrownRotation($crownValue)">
///     <text>Crown: {crownValue}</text>
/// </vstack>
/// ```
///
/// ## Event Handling
/// The binding dispatches a `{name}Changed` event when the crown is rotated:
/// ```javascript
/// element.addEventListener("crownvaluechanged", (event) => {
///     console.log("Crown rotation:", event.detail.value);
/// });
///
/// // Programmatically set the crown value:
/// element.setAttribute("crownvalue", "0.5");
/// ```
@MainActor
public enum DigitalCrownRotationModifier<Library: ElementLibrary>: @unchecked Sendable {
    /// digitalCrownRotation($binding)
    case binding(NodeBinding<Double>)
}

extension DigitalCrownRotationModifier: RuntimeViewModifier {
    public static var baseName: String { "digitalCrownRotation" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // Try to parse: digitalCrownRotation($binding)
        if let firstArg = syntax.arguments.first,
           let binding = NodeBinding<Double>(syntax: firstArg.expression) {
            self = .binding(binding)
            return
        }

        throw ModifierParseError.noMatchingVariant(modifier: "DigitalCrownRotationModifier", errors: [])
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        DigitalCrownRotationModifierBody<Library>(modifier: self, content: _content)
    }
}

/// Internal view that resolves NodeBinding to Binding at runtime using environment.
private struct DigitalCrownRotationModifierBody<Library: ElementLibrary>: View {
    let modifier: DigitalCrownRotationModifier<Library>
    let content: DigitalCrownRotationModifier<Library>.Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        switch modifier {
        case .binding(let nodeBinding):
            content.digitalCrownRotation(nodeBinding.binding(node: node, runtime: runtime))
        }
    }
}
#endif
