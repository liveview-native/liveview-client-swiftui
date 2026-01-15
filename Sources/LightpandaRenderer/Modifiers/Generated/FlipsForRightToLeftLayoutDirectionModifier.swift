import SwiftUI
import SwiftSyntax

/// Modifier for flipping views for right-to-left layout direction.
///
/// Usage:
/// ```html
/// <image systemname="arrow.right" modifiers="flipsForRightToLeftLayoutDirection(true)"/>
/// <image systemname="arrow.right" modifiers="flipsForRightToLeftLayoutDirection(false)"/>
/// ```
public enum FlipsForRightToLeftLayoutDirectionModifier<Library: ElementLibrary>: @unchecked Sendable {
    case flipsForRightToLeftLayoutDirection(Bool)
}

extension FlipsForRightToLeftLayoutDirectionModifier: RuntimeViewModifier {
    public static var baseName: String { "flipsForRightToLeftLayoutDirection" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let enabled = syntax.arguments.first.flatMap({ Bool(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "FlipsForRightToLeftLayoutDirectionModifier", argument: "enabled")
        }
        self = .flipsForRightToLeftLayoutDirection(enabled)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .flipsForRightToLeftLayoutDirection(let enabled):
            _content.flipsForRightToLeftLayoutDirection(enabled)
        }
    }
}
