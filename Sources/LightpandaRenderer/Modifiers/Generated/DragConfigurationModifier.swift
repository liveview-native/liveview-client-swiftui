import SwiftUI
import SwiftSyntax

/// Modifier for configuring drag sessions.
///
/// Usage:
/// ```html
/// <!-- Default drag configuration -->
/// <vstack modifiers="dragConfiguration(.default)">
///   <text>Drag me</text>
/// </vstack>
///
/// <!-- Custom operations -->
/// <vstack modifiers="dragConfiguration(.init(supportedOperations: .copy))">
///   <text>Copy only</text>
/// </vstack>
/// ```
#if os(macOS)
@available(macOS 26.0, *)
public enum DragConfigurationModifier<Library: ElementLibrary>: @unchecked Sendable {
    case dragConfiguration(SwiftUI.DragConfiguration)
}

@available(macOS 26.0, *)
extension DragConfigurationModifier: RuntimeViewModifier {
    public static var baseName: String { "dragConfiguration" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let config = syntax.arguments.first.flatMap({ DragConfiguration(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "DragConfigurationModifier", argument: "configuration")
        }
        self = .dragConfiguration(config)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .dragConfiguration(let config):
            _content.dragConfiguration(config)
        }
    }
}
#endif