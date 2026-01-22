#if os(tvOS)
import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for handling page up/page down commands on tvOS.
///
/// Steps a value through a range in response to page up or page down commands.
/// Available on tvOS 14.3+.
///
/// ## Usage
/// ```html
/// <scrollview modifiers="pageCommand(value: $pageIndex, in: 0...10, step: 1)">
///     <!-- content -->
/// </scrollview>
/// ```
///
/// Or with a step size:
/// ```html
/// <scrollview modifiers="pageCommand(value: $pageIndex, in: 0...100, step: 10)">
///     <!-- content -->
/// </scrollview>
/// ```
///
/// ## Event Handling
/// The binding dispatches a `{name}Changed` event when the value changes:
/// ```javascript
/// element.addEventListener("pageindexchanged", (event) => {
///     console.log("Page index:", event.detail.value);
/// });
///
/// // Programmatically set the value:
/// element.setAttribute("pageindex", "5");
/// ```
@MainActor
public enum PageCommandModifier<Library: ElementLibrary>: @unchecked Sendable {
    /// pageCommand(value: $binding, in: lowerBound...upperBound, step: Int)
    case intValue(value: NodeBinding<Int>, bounds: ClosedRange<Int>, step: Int)
}

extension PageCommandModifier: RuntimeViewModifier {
    public static var baseName: String { "pageCommand" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // Parse: pageCommand(value: $binding, in: 0...10, step: 1)
        guard let value = syntax.argument(named: "value").flatMap({ NodeBinding<Int>(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "PageCommandModifier", argument: "value")
        }
        guard let bounds = syntax.argument(named: "in").flatMap({ ClosedRange<Int>(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "PageCommandModifier", argument: "in")
        }
        // Step defaults to 1
        let step = syntax.argument(named: "step").flatMap({ Int(syntax: $0.expression) }) ?? 1
        self = .intValue(value: value, bounds: bounds, step: step)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        if #available(tvOS 14.3, *) {
            PageCommandModifierBody<Library>(modifier: self, content: _content)
        } else {
            _content
        }
    }
}

/// Internal view that resolves NodeBinding to Binding at runtime using environment.
@available(tvOS 14.3, *)
private struct PageCommandModifierBody<Library: ElementLibrary>: View {
    let modifier: PageCommandModifier<Library>
    let content: PageCommandModifier<Library>.Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        switch modifier {
        case .intValue(let value, let bounds, let step):
            content.pageCommand(value: value.binding(node: node, runtime: runtime), in: bounds, step: step)
        }
    }
}
#endif
