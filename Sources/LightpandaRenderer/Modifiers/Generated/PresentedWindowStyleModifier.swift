import SwiftUI
import SwiftSyntax

/// Modifier for presentedWindowStyle(_:) - sets the window style for presented windows.
/// Available on macOS 13+ and visionOS 1+.
#if os(macOS) || os(visionOS)
@available(macOS 13.0, visionOS 1.0, *)
public enum PresentedWindowStyleModifier<Library: ElementLibrary>: @unchecked Sendable {
    case presentedWindowStyle(AnyWindowStyle)
}

@available(macOS 13.0, visionOS 1.0, *)
extension PresentedWindowStyleModifier: RuntimeViewModifier {
    public static var baseName: String { "presentedWindowStyle" }

    public init(syntax: FunctionCallExprSyntax) throws {
        var errors: [Error] = []
        do {
            guard let style = (syntax.arguments.count > 0 ? syntax.arguments[syntax.arguments.startIndex] : nil).flatMap({ AnyWindowStyle(syntax: $0.expression) }) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "PresentedWindowStyleModifier", argument: "style")
            }
            self = .presentedWindowStyle(style)
            return
        } catch {
            errors.append(error)
        }
        throw ModifierParseError.noMatchingVariant(modifier: "PresentedWindowStyleModifier", errors: errors)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .presentedWindowStyle(let style):
            _content.presentedWindowStyle(style)
        }
    }
}
#endif
