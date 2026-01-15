import SwiftUI
import SwiftSyntax

/// Modifier for setting menu order behavior.
///
/// Usage:
/// ```html
/// <menu modifiers="menuOrder(.automatic)">...</menu>
/// <menu modifiers="menuOrder(.priority)">...</menu>
/// <menu modifiers="menuOrder(.fixed)">...</menu>
/// ```
#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public enum MenuOrderModifier<Library: ElementLibrary>: @unchecked Sendable {
    case menuOrder(MenuOrder)
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension MenuOrderModifier: RuntimeViewModifier {
    public static var baseName: String { "menuOrder" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let order = syntax.arguments.first.flatMap({ MenuOrder(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "MenuOrderModifier", argument: "order")
        }
        self = .menuOrder(order)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .menuOrder(let order):
            _content.menuOrder(order)
        }
    }
}
#endif
