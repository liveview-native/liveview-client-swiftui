import SwiftUI
import SwiftSyntax

#if os(macOS) || os(tvOS) || os(visionOS)
/// Modifier for controlling pointer visibility.
///
/// Usage:
/// ```html
/// <vstack modifiers="pointerVisibility(.hidden)">...</vstack>
/// <vstack modifiers="pointerVisibility(.visible)">...</vstack>
/// <vstack modifiers="pointerVisibility(.automatic)">...</vstack>
/// ```
public enum PointerVisibilityModifier<Library: ElementLibrary>: @unchecked Sendable {
    case pointerVisibility(Visibility)
}

extension PointerVisibilityModifier: RuntimeViewModifier {
    public static var baseName: String { "pointerVisibility" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let visibility = syntax.arguments.first.flatMap({ Visibility(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "PointerVisibilityModifier", argument: "visibility")
        }
        self = .pointerVisibility(visibility)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .pointerVisibility(let visibility):
            _content.pointerVisibility(visibility)
        }
    }
}
#endif
