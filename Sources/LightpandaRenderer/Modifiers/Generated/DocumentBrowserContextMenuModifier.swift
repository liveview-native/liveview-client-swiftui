import SwiftUI
import SwiftSyntax

/// Modifier for adding document browser context menus to views.
/// Supports:
/// - `.documentBrowserContextMenu(menu: myMenu)` - adds a context menu to document browser items
///
/// Available on iOS 18.1+
public enum DocumentBrowserContextMenuModifier<Library: ElementLibrary>: @unchecked Sendable {
    #if os(iOS)
    case documentBrowserContextMenu(menu: ViewReference<Library>)
    #else
    case _unavailable
    #endif
}

extension DocumentBrowserContextMenuModifier: RuntimeViewModifier {
    public static var baseName: String { "documentBrowserContextMenu" }

    public init(syntax: FunctionCallExprSyntax) throws {
        #if os(iOS)
        // Try .documentBrowserContextMenu(menu: myMenu)
        if let menu = syntax.argument(named: "menu").flatMap({ ViewReference<Library>(syntax: $0.expression) }) {
            self = .documentBrowserContextMenu(menu: menu)
            return
        }

        // Try .documentBrowserContextMenu(myMenu) - positional argument
        if let firstArg = syntax.arguments.first,
           firstArg.label == nil,
           let menu = ViewReference<Library>(syntax: firstArg.expression) {
            self = .documentBrowserContextMenu(menu: menu)
            return
        }
        #endif

        throw ModifierParseError.noMatchingVariant(modifier: "DocumentBrowserContextMenuModifier", errors: [])
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        #if os(iOS)
        case .documentBrowserContextMenu(let menu):
            if #available(iOS 18.1, *) {
                _content.documentBrowserContextMenu { _ in menu }
            } else {
                _content
            }
        #else
        case ._unavailable:
            _content
        #endif
        }
    }
}
