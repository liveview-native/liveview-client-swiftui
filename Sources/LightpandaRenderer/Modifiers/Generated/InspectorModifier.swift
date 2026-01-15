import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Inspector presentation modifier using NodeBinding for `$identifier` syntax.
///
/// ## Usage
/// ```html
/// <vstack modifiers='inspector(isPresented: $showInspector, content: inspectorContent)'>
///     <text template="inspectorContent">Inspector Content</text>
///     <button>
///         <text template="label">Show Inspector</text>
///     </button>
/// </vstack>
/// ```
@available(iOS 17.0, macOS 14.0, *)
@MainActor
public enum InspectorModifier<Library: ElementLibrary>: @unchecked Sendable {
    case isPresented(isPresented: NodeBinding<Bool>, content: ViewReference<Library>)
}

@available(iOS 17.0, macOS 14.0, *)
extension InspectorModifier: RuntimeViewModifier {
    public static var baseName: String { "inspector" }

    public init(syntax: FunctionCallExprSyntax) throws {
        if let isPresented = syntax.argument(named: "isPresented").flatMap({ NodeBinding<Bool>(syntax: $0.expression) }),
           let content = syntax.argument(named: "content").flatMap({ ViewReference<Library>(syntax: $0.expression) }) {
            self = .isPresented(isPresented: isPresented, content: content)
            return
        }

        throw ModifierParseError.noMatchingVariant(modifier: "InspectorModifier", errors: [])
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        InspectorModifierBody<Library>(modifier: self, content: _content)
    }
}

@available(iOS 17.0, macOS 14.0, *)
private struct InspectorModifierBody<Library: ElementLibrary>: View {
    let modifier: InspectorModifier<Library>
    let content: InspectorModifier<Library>.Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        switch modifier {
        case .isPresented(let isPresented, let inspectorContent):
            content.inspector(isPresented: isPresented.binding(node: node, runtime: runtime)) {
                inspectorContent
            }
        }
    }
}