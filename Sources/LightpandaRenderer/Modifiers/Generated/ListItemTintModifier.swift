import SwiftUI
import SwiftSyntax

/// Modifier for setting list item tint.
///
/// Usage:
/// ```html
/// <text modifiers="listItemTint(.red)">Red tint</text>
/// <text modifiers="listItemTint(.monochrome)">Monochrome</text>
/// <text modifiers="listItemTint(.fixed(.blue))">Fixed blue</text>
/// <text modifiers="listItemTint(.preferred(.green))">Preferred green</text>
/// ```
public enum ListItemTintModifier<Library: ElementLibrary>: @unchecked Sendable {
    case listItemTintColor(Color?)
    case listItemTintStyle(ListItemTint?)
}

extension ListItemTintModifier: RuntimeViewModifier {
    public static var baseName: String { "listItemTint" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // Try ListItemTint first (.monochrome, .fixed(), .preferred())
        if let tint = syntax.arguments.first.flatMap({ ListItemTint(syntax: $0.expression) }) {
            self = .listItemTintStyle(tint)
            return
        }

        // Try Color
        let color = syntax.arguments.first.flatMap({ Color(syntax: $0.expression) })
        self = .listItemTintColor(color)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .listItemTintColor(let color):
            _content.listItemTint(color)
        case .listItemTintStyle(let tint):
            _content.listItemTint(tint)
        }
    }
}
