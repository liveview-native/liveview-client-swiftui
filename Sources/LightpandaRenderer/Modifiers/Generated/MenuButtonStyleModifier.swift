#if os(macOS)
import SwiftUI
import SwiftSyntax

/// Generated modifier enum for MenuButtonStyleModifier modifiers.
/// Note: MenuButtonStyle is deprecated in macOS 12.3+ but still available for compatibility.
@available(macOS, deprecated: 12.3, message: "Use Menu with menuStyle instead")
public enum MenuButtonStyleModifier<Library: ElementLibrary>: @unchecked Sendable {
    case menuButtonStyle(AnyMenuButtonStyle)
}

@available(macOS, deprecated: 12.3, message: "Use Menu with menuStyle instead")
extension MenuButtonStyleModifier: RuntimeViewModifier {
    public static var baseName: String { "menuButtonStyle" }

    public init(syntax: FunctionCallExprSyntax) throws {
        var errors: [Error] = []
        do {
            guard let value0 = (syntax.arguments.count > 0 ? syntax.arguments[0] : nil).flatMap({ AnyMenuButtonStyle(syntax: $0.expression) }) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "MenuButtonStyleModifier", argument: "style")
            }
            self = .menuButtonStyle(value0)
            return
        } catch {
            errors.append(error)
        }
        throw ModifierParseError.noMatchingVariant(modifier: "MenuButtonStyleModifier", errors: errors)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .menuButtonStyle(let value0):
            _content.menuButtonStyle(value0)
        }
    }
}
#endif
