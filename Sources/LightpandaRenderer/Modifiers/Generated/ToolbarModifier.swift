import SwiftUI
import SwiftSyntax

/// Toolbar modifier using ViewReference for content.
///
/// ## Usage
/// ```html
/// <navigationstack modifiers='toolbar(content: toolbarContent)'>
///     <toolbaritem template="toolbarContent">
///         <button>
///             <text template="label">Action</text>
///         </button>
///     </toolbaritem>
/// </navigationstack>
/// ```
@MainActor
public enum ToolbarModifier<Library: ElementLibrary>: @unchecked Sendable {
    case content(content: ViewReference<Library>)
}

extension ToolbarModifier: RuntimeViewModifier {
    public static var baseName: String { "toolbar" }

    public init(syntax: FunctionCallExprSyntax) throws {
        if let content = syntax.argument(named: "content").flatMap({ ViewReference<Library>(syntax: $0.expression) }) {
            self = .content(content: content)
            return
        }
        
        throw ModifierParseError.noMatchingVariant(modifier: "ToolbarModifier", errors: [])
    }
    
    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .content(let toolbarContent):
            _content.toolbar {
                toolbarContent
            }
        }
    }
}
