import SwiftUI
import SwiftSyntax

#if os(macOS)
/// Modifier for presentedWindowToolbarStyle - sets the toolbar style for windows created by interacting with this view.
/// macOS only.
public enum PresentedWindowToolbarStyleModifier<Library: ElementLibrary>: @unchecked Sendable {
    case presentedWindowToolbarStyle(AnyWindowToolbarStyle)
}

extension PresentedWindowToolbarStyleModifier: RuntimeViewModifier {
    public static var baseName: String { "presentedWindowToolbarStyle" }

    public init(syntax: FunctionCallExprSyntax) throws {
        var errors: [Error] = []
        do {
            guard let value0 = (syntax.arguments.count > 0 ? syntax.arguments[0] : nil).flatMap({ AnyWindowToolbarStyle(syntax: $0.expression) }) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "PresentedWindowToolbarStyleModifier", argument: "style")
            }
            self = .presentedWindowToolbarStyle(value0)
            return
        } catch {
            errors.append(error)
        }
        throw ModifierParseError.noMatchingVariant(modifier: "PresentedWindowToolbarStyleModifier", errors: errors)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .presentedWindowToolbarStyle(let style):
            _content.presentedWindowToolbarStyle(style)
        }
    }
}
#endif
