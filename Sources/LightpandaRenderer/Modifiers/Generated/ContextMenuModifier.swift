import SwiftUI
import SwiftSyntax

/// Modifier for adding context menus to views.
/// Supports:
/// - `.contextMenu(menuItems: myMenu)` - basic context menu
/// - `.contextMenu(menuItems: myMenu, preview: myPreview)` - with custom preview
public enum ContextMenuModifier<Library: ElementLibrary>: @unchecked Sendable {
    case menuItems(ViewReference<Library>)
    case menuItemsWithPreview(menuItems: ViewReference<Library>, preview: ViewReference<Library>)
}

extension ContextMenuModifier: RuntimeViewModifier {
    public static var baseName: String { "contextMenu" }

    public init(syntax: FunctionCallExprSyntax) throws {
        var errors: [Error] = []
        
        // Try .contextMenu(menuItems: myMenu, preview: myPreview)
        if let menuItems = syntax.argument(named: "menuItems").flatMap({ ViewReference<Library>(syntax: $0.expression) }),
           let preview = syntax.argument(named: "preview").flatMap({ ViewReference<Library>(syntax: $0.expression) }) {
            self = .menuItemsWithPreview(menuItems: menuItems, preview: preview)
            return
        }
        
        // Try .contextMenu(menuItems: myMenu)
        if let menuItems = syntax.argument(named: "menuItems").flatMap({ ViewReference<Library>(syntax: $0.expression) }) {
            self = .menuItems(menuItems)
            return
        }
        
        // Try .contextMenu(myMenu) - positional argument
        if let firstArg = syntax.arguments.first,
           firstArg.label == nil,
           let menuItems = ViewReference<Library>(syntax: firstArg.expression) {
            self = .menuItems(menuItems)
            return
        }
        
        throw ModifierParseError.noMatchingVariant(modifier: "ContextMenuModifier", errors: errors)
    }
    
    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .menuItems(let menuItems):
            _content.contextMenu { menuItems }
        case .menuItemsWithPreview(let menuItems, let preview):
            _content.contextMenu(menuItems: { menuItems }, preview: { preview })
        }
    }
}