import SwiftUI
import SwiftSyntax

/// Modifier for tagging views for interaction activity tracking.
///
/// Usage:
/// ```html
/// <button modifiers='interactionActivityTrackingTag("myButton")'>Click me</button>
/// ```
#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public enum InteractionActivityTrackingTagModifier<Library: ElementLibrary>: @unchecked Sendable {
    case interactionActivityTrackingTag(String)
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension InteractionActivityTrackingTagModifier: RuntimeViewModifier {
    public static var baseName: String { "interactionActivityTrackingTag" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let tag = syntax.arguments.first.flatMap({ String(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "InteractionActivityTrackingTagModifier", argument: "tag")
        }
        self = .interactionActivityTrackingTag(tag)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .interactionActivityTrackingTag(let tag):
            _content.interactionActivityTrackingTag(tag)
        }
    }
}
#endif
