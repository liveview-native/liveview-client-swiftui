import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for programmatically presenting the find and replace interface.
///
/// ## Usage
/// ```html
/// <texteditor modifiers='findNavigator(isPresented: $showFind)'>...</texteditor>
/// ```
///
/// ## JavaScript Integration
/// ```javascript
/// // Show the find navigator
/// element.setAttribute("showFind", "true");
///
/// // Listen for changes
/// element.addEventListener("showFindChanged", (e) => {
///     console.log("Find navigator visible:", e.detail.value);
/// });
/// ```
#if os(iOS) || os(macOS)
@available(iOS 16.0, macOS 26.0, *)
@MainActor
public enum FindNavigatorModifier<Library: ElementLibrary>: @unchecked Sendable {
    case findNavigator(isPresented: NodeBinding<Bool>)
}

@available(iOS 16.0, macOS 26.0, *)
extension FindNavigatorModifier: RuntimeViewModifier {
    public static var baseName: String { "findNavigator" }

    public init(syntax: FunctionCallExprSyntax) throws {
        if let isPresented = syntax.argument(named: "isPresented").flatMap({ NodeBinding<Bool>(syntax: $0.expression) }) {
            self = .findNavigator(isPresented: isPresented)
            return
        }

        throw ModifierParseError.noMatchingVariant(modifier: "FindNavigatorModifier", errors: [])
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        FindNavigatorModifierBody<Library>(modifier: self, content: _content)
    }
}

@available(iOS 16.0, macOS 26.0, *)
private struct FindNavigatorModifierBody<Library: ElementLibrary>: View {
    let modifier: FindNavigatorModifier<Library>
    let content: FindNavigatorModifier<Library>.Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        switch modifier {
        case .findNavigator(let isPresented):
            if #available(iOS 16.0, macOS 26.0, *) {
                content.findNavigator(isPresented: isPresented.binding(node: node, runtime: runtime))
            } else {
                content
            }
        }
    }
}
#endif