import SwiftUI
import SwiftSyntax

/// Modifier for displaying an immersive environment picker on visionOS.
///
/// Usage:
/// ```html
/// <vstack modifiers="immersiveEnvironmentPicker(content: environmentOptions)">
///     <button template="environmentOptions">
///         <text template="label">Option 1</text>
///     </button>
/// </vstack>
/// ```
///
/// Note: This modifier is only available on visionOS.
#if os(visionOS)
public enum ImmersiveEnvironmentPickerModifier<Library: ElementLibrary>: @unchecked Sendable {
    case immersiveEnvironmentPicker(content: ViewReference<Library>)
}

extension ImmersiveEnvironmentPickerModifier: RuntimeViewModifier {
    public static var baseName: String { "immersiveEnvironmentPicker" }

    public init(syntax: FunctionCallExprSyntax) throws {
        var errors: [Error] = []
        do {
            guard let content = syntax.argument(named: "content").flatMap({ ViewReference<Library>(syntax: $0.expression) }) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "ImmersiveEnvironmentPickerModifier", argument: "content")
            }
            self = .immersiveEnvironmentPicker(content: content)
            return
        } catch {
            errors.append(error)
        }
        throw ModifierParseError.noMatchingVariant(modifier: "ImmersiveEnvironmentPickerModifier", errors: errors)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .immersiveEnvironmentPicker(content: let content):
            _content.immersiveEnvironmentPicker(content: { content })
        }
    }
}
#endif