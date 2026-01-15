import SwiftUI
import SwiftSyntax

#if os(tvOS) || os(visionOS)
/// Modifier for setting the hover effect on a list row.
///
/// Usage:
/// ```html
/// <text modifiers="listRowHoverEffect(.automatic)">
/// <text modifiers="listRowHoverEffect(.highlight)">
/// <text modifiers="listRowHoverEffect(.lift)">
/// ```
@available(tvOS 17.0, visionOS 1.0, *)
public enum ListRowHoverEffectModifier<Library: ElementLibrary>: @unchecked Sendable {
    case listRowHoverEffect(SwiftUI.HoverEffect?)
}

@available(tvOS 17.0, visionOS 1.0, *)
extension ListRowHoverEffectModifier: RuntimeViewModifier {
    public static var baseName: String { "listRowHoverEffect" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let value0: SwiftUI.HoverEffect? = (syntax.arguments.count > 0 ? syntax.arguments[0] : nil).flatMap({ SwiftUI.HoverEffect(syntax: $0.expression) }) ?? nil
        self = .listRowHoverEffect(value0)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .listRowHoverEffect(let value0):
            _content.listRowHoverEffect(value0)
        }
    }
}
#endif
