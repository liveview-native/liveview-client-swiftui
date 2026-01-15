import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for controlling scroll position in a ScrollView.
///
/// Usage:
/// ```html
/// <scrollview modifiers="scrollPosition(id: $scrollId).scrollTargetLayout()">
///     <lazyvstack>
///         <foreach>
///             <text id="item-1">Item 1</text>
///             <text id="item-2">Item 2</text>
///         </foreach>
///     </lazyvstack>
/// </scrollview>
/// ```
///
/// ## Event Handling
/// The binding dispatches a `{name}Changed` event when the scroll position changes:
/// ```javascript
/// element.addEventListener("scrollidchanged", (event) => {
///     console.log("Scroll position:", event.detail.value);
/// });
///
/// // Programmatically scroll to an item:
/// element.setAttribute("scrollid", "item-5");
/// ```
#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public enum ScrollPositionModifier<Library: ElementLibrary>: @unchecked Sendable {
    /// scrollPosition(id: $binding)
    case idOnly(id: NodeBinding<String?>)

    /// scrollPosition(id: $binding, anchor: .top)
    case idAnchor(id: NodeBinding<String?>, anchor: UnitPoint?)
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension ScrollPositionModifier: RuntimeViewModifier {
    public static var baseName: String { "scrollPosition" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // Try to parse: scrollPosition(id: $binding, anchor: .top)
        if let idBinding = syntax.argument(named: "id").flatMap({ NodeBinding<String?>(syntax: $0.expression) }) {
            let anchor = syntax.argument(named: "anchor").flatMap({ UnitPoint(syntax: $0.expression) })
            if anchor != nil {
                self = .idAnchor(id: idBinding, anchor: anchor)
            } else {
                self = .idOnly(id: idBinding)
            }
            return
        }

        throw ModifierParseError.noMatchingVariant(modifier: "ScrollPositionModifier", errors: [])
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        ScrollPositionModifierBody<Library>(modifier: self, content: _content)
    }
}

/// Internal view that resolves NodeBinding to Binding at runtime using environment.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
private struct ScrollPositionModifierBody<Library: ElementLibrary>: View {
    let modifier: ScrollPositionModifier<Library>
    let content: ScrollPositionModifier<Library>.Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        switch modifier {
        case .idOnly(let id):
            content.scrollPosition(id: id.binding(node: node, runtime: runtime))
        case .idAnchor(let id, let anchor):
            content.scrollPosition(id: id.binding(node: node, runtime: runtime), anchor: anchor)
        }
    }
}
#endif
