import SwiftUI
import SwiftSyntax

#if os(tvOS) || os(visionOS)
/// Modifier for disabling the hover effect on a list row.
///
/// Usage:
/// ```html
/// <text modifiers="listRowHoverEffectDisabled()">
/// <text modifiers="listRowHoverEffectDisabled(true)">
/// <text modifiers="listRowHoverEffectDisabled(false)">
/// ```
@available(tvOS 17.0, visionOS 1.0, *)
public enum ListRowHoverEffectDisabledModifier<Library: ElementLibrary>: @unchecked Sendable {
    case listRowHoverEffectDisabled(Swift.Bool)
}

@available(tvOS 17.0, visionOS 1.0, *)
extension ListRowHoverEffectDisabledModifier: RuntimeViewModifier {
    public static var baseName: String { "listRowHoverEffectDisabled" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let value0: Swift.Bool = (syntax.arguments.count > 0 ? syntax.arguments[0] : nil).flatMap({ Swift.Bool(syntax: $0.expression) }) ?? true
        self = .listRowHoverEffectDisabled(value0)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .listRowHoverEffectDisabled(let value0):
            _content.listRowHoverEffectDisabled(value0)
        }
    }
}
#endif
