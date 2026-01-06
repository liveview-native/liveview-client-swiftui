import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Sheet presentation modifier using NodeBinding for `$identifier` syntax.
///
/// ## Usage
/// ```html
/// <vstack modifiers='sheet(isPresented: $showSheet, content: sheetContent)'>
///     <text template="sheetContent">Sheet Content</text>
///     <button>
///         <text template="label">Show Sheet</text>
///     </button>
/// </vstack>
/// ```
@MainActor
public enum SheetModifier<Library: ElementLibrary>: @unchecked Sendable {
    case isPresented(isPresented: NodeBinding<Bool>, content: ViewReference<Library>)
}

extension SheetModifier: RuntimeViewModifier {
    public static var baseName: String { "sheet" }

    public init(syntax: FunctionCallExprSyntax) throws {
        if let isPresented = syntax.argument(named: "isPresented").flatMap({ NodeBinding<Bool>(syntax: $0.expression) }),
           let content = syntax.argument(named: "content").flatMap({ ViewReference<Library>(syntax: $0.expression) }) {
            self = .isPresented(isPresented: isPresented, content: content)
            return
        }
        
        throw ModifierParseError.noMatchingVariant(modifier: "SheetModifier", errors: [])
    }
    
    @ViewBuilder
    public func body(content _content: Content) -> some View {
        SheetModifierBody<Library>(modifier: self, content: _content)
    }
}

private struct SheetModifierBody<Library: ElementLibrary>: View {
    let modifier: SheetModifier<Library>
    let content: SheetModifier<Library>.Content
    
    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime
    
    var body: some View {
        switch modifier {
        case .isPresented(let isPresented, let sheetContent):
            content.sheet(isPresented: isPresented.binding(node: node, runtime: runtime)) {
                sheetContent
            }
        }
    }
}
