import SwiftUI
import SwiftSyntax

/// Modifier for controlling menu indicator visibility.
///
/// Usage:
/// ```html
/// <menu modifiers="menuIndicator(.hidden)">...</menu>
/// <menu modifiers="menuIndicator(.visible)">...</menu>
/// <menu modifiers="menuIndicator(.automatic)">...</menu>
/// ```
public enum MenuIndicatorModifier<Library: ElementLibrary>: @unchecked Sendable {
    case menuIndicator(Visibility)
}

extension MenuIndicatorModifier: RuntimeViewModifier {
    public static var baseName: String { "menuIndicator" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let visibility = syntax.arguments.first.flatMap({ Visibility(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "MenuIndicatorModifier", argument: "visibility")
        }
        self = .menuIndicator(visibility)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .menuIndicator(let visibility):
            _content.menuIndicator(visibility)
        }
    }
}
