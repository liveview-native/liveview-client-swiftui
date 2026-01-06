import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Popover presentation modifier using NodeBinding for `$identifier` syntax.
///
/// ## Usage
/// ```html
/// <button modifiers='popover(isPresented: $showPopover, content: popoverContent)'>
///     <text template="label">Show Popover</text>
///     <text template="popoverContent">Popover Content</text>
/// </button>
/// ```
@MainActor
public enum PopoverModifier<Library: ElementLibrary>: @unchecked Sendable {
    case isPresented(isPresented: NodeBinding<Bool>, content: ViewReference<Library>)
}

extension PopoverModifier: RuntimeViewModifier {
    public static var baseName: String { "popover" }

    public init(syntax: FunctionCallExprSyntax) throws {
        if let isPresented = syntax.argument(named: "isPresented").flatMap({ NodeBinding<Bool>(syntax: $0.expression) }),
           let content = syntax.argument(named: "content").flatMap({ ViewReference<Library>(syntax: $0.expression) }) {
            self = .isPresented(isPresented: isPresented, content: content)
            return
        }
        
        throw ModifierParseError.noMatchingVariant(modifier: "PopoverModifier", errors: [])
    }
    
    @ViewBuilder
    public func body(content _content: Content) -> some View {
        PopoverModifierBody<Library>(modifier: self, content: _content)
    }
}

private struct PopoverModifierBody<Library: ElementLibrary>: View {
    let modifier: PopoverModifier<Library>
    let content: PopoverModifier<Library>.Content
    
    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime
    
    var body: some View {
        switch modifier {
        case .isPresented(let isPresented, let popoverContent):
            content.popover(isPresented: isPresented.binding(node: node, runtime: runtime)) {
                popoverContent
            }
        }
    }
}
