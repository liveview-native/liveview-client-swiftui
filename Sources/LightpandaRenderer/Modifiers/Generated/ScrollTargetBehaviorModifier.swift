import SwiftUI
import SwiftSyntax

/// Modifier for controlling scroll target/snapping behavior.
/// Usage: .scrollTargetBehavior(.paging) or .scrollTargetBehavior(.viewAligned)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public enum ScrollTargetBehaviorModifier<Library: ElementLibrary>: @unchecked Sendable {
    case scrollTargetBehavior(AnyScrollTargetBehavior)
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension ScrollTargetBehaviorModifier: RuntimeViewModifier {
    public static var baseName: String { "scrollTargetBehavior" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let firstArg = syntax.arguments.first,
              let behavior = AnyScrollTargetBehavior(syntax: firstArg.expression) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "ScrollTargetBehaviorModifier", argument: "behavior")
        }
        self = .scrollTargetBehavior(behavior)
    }
    
    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .scrollTargetBehavior(let behavior):
            _content.scrollTargetBehavior(behavior)
        }
    }
}
