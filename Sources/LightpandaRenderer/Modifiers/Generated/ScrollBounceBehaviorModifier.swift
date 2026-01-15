import SwiftUI
import SwiftSyntax

/// Modifier for controlling scroll bounce behavior.
///
/// Usage:
/// ```html
/// <scrollview modifiers="scrollBounceBehavior(.always)">...</scrollview>
/// <scrollview modifiers="scrollBounceBehavior(.basedOnSize)">...</scrollview>
/// <scrollview modifiers="scrollBounceBehavior(.automatic, axes: .horizontal)">...</scrollview>
/// ```
#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
@available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
public enum ScrollBounceBehaviorModifier<Library: ElementLibrary>: @unchecked Sendable {
    case scrollBounceBehavior(ScrollBounceBehavior, axes: Axis.Set)
}

@available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
extension ScrollBounceBehaviorModifier: RuntimeViewModifier {
    public static var baseName: String { "scrollBounceBehavior" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let behavior = syntax.arguments.first.flatMap({ ScrollBounceBehavior(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "ScrollBounceBehaviorModifier", argument: "behavior")
        }
        let axes: Axis.Set = syntax.argument(named: "axes").flatMap({ Axis.Set(syntax: $0.expression) }) ?? [.vertical]
        self = .scrollBounceBehavior(behavior, axes: axes)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .scrollBounceBehavior(let behavior, axes: let axes):
            _content.scrollBounceBehavior(behavior, axes: axes)
        }
    }
}
#endif
