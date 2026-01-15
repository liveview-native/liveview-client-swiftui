import SwiftUI
import SwiftSyntax

#if os(iOS) || os(tvOS) || os(visionOS)
/// Modifier for setting the default hover effect.
///
/// Usage:
/// ```html
/// <button modifiers="defaultHoverEffect(.automatic)">
/// <button modifiers="defaultHoverEffect(.highlight)">
/// <button modifiers="defaultHoverEffect(.lift)">
/// ```
@available(iOS 13.4, tvOS 16.0, *)
public enum DefaultHoverEffectModifier<Library: ElementLibrary>: @unchecked Sendable {
    case defaultHoverEffect(SwiftUI.HoverEffect?)
}

@available(iOS 13.4, tvOS 16.0, *)
extension DefaultHoverEffectModifier: RuntimeViewModifier {
    public static var baseName: String { "defaultHoverEffect" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let value0: SwiftUI.HoverEffect? = (syntax.arguments.count > 0 ? syntax.arguments[0] : nil).flatMap({ SwiftUI.HoverEffect(syntax: $0.expression) }) ?? nil
        self = .defaultHoverEffect(value0)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .defaultHoverEffect(let value0):
            _content.defaultHoverEffect(value0)
        }
    }
}
#endif