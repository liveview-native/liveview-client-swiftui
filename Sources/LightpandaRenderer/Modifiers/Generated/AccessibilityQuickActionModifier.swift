import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Simplified AccessibilityQuickActionModifier for watchOS accessibility quick actions.
///
/// Supported variants:
/// - `accessibilityQuickAction(style: .outline, content: contentView)`
/// - `accessibilityQuickAction(style: .outline, isActive: $isActive, content: contentView)`
///
/// ## Usage
/// ```html
/// <vstack modifiers='accessibilityQuickAction(style: .outline, content: quickActionContent)'>
///     <text template="quickActionContent">Quick Action</text>
/// </vstack>
/// ```
///
/// Note: This modifier is only available on watchOS 8.0+
#if os(watchOS)
@MainActor
public enum AccessibilityQuickActionModifier<Library: ElementLibrary>: @unchecked Sendable {
    /// accessibilityQuickAction(style:, content:)
    case styleContent(style: AccessibilityQuickActionStyle, content: ViewReference<Library>)

    /// accessibilityQuickAction(style:, isActive:, content:)
    case styleIsActiveContent(style: AccessibilityQuickActionStyle, isActive: NodeBinding<Bool>, content: ViewReference<Library>)
}

extension AccessibilityQuickActionModifier: RuntimeViewModifier {
    public static var baseName: String { "accessibilityQuickAction" }

    public init(syntax: FunctionCallExprSyntax) throws {
        var errors: [Error] = []

        // Try to parse: accessibilityQuickAction(style:, isActive:, content:)
        do {
            guard let style = syntax.argument(named: "style").flatMap({ AccessibilityQuickActionStyle(syntax: $0.expression) }) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "AccessibilityQuickActionModifier", argument: "style")
            }
            guard let isActive = syntax.argument(named: "isActive").flatMap({ NodeBinding<Bool>(syntax: $0.expression) }) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "AccessibilityQuickActionModifier", argument: "isActive")
            }
            guard let content = syntax.argument(named: "content").flatMap({ ViewReference<Library>(syntax: $0.expression) }) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "AccessibilityQuickActionModifier", argument: "content")
            }
            self = .styleIsActiveContent(style: style, isActive: isActive, content: content)
            return
        } catch {
            errors.append(error)
        }

        // Try to parse: accessibilityQuickAction(style:, content:)
        do {
            guard let style = syntax.argument(named: "style").flatMap({ AccessibilityQuickActionStyle(syntax: $0.expression) }) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "AccessibilityQuickActionModifier", argument: "style")
            }
            guard let content = syntax.argument(named: "content").flatMap({ ViewReference<Library>(syntax: $0.expression) }) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "AccessibilityQuickActionModifier", argument: "content")
            }
            self = .styleContent(style: style, content: content)
            return
        } catch {
            errors.append(error)
        }

        throw ModifierParseError.noMatchingVariant(modifier: "AccessibilityQuickActionModifier", errors: errors)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        AccessibilityQuickActionModifierBody<Library>(modifier: self, content: _content)
    }
}

/// Internal view that resolves NodeBinding to Binding at runtime using environment.
private struct AccessibilityQuickActionModifierBody<Library: ElementLibrary>: View {
    let modifier: AccessibilityQuickActionModifier<Library>
    let content: AccessibilityQuickActionModifier<Library>.Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        switch modifier {
        case .styleContent(let style, let contentView):
            content.accessibilityQuickAction(style: style) {
                contentView
            }
        case .styleIsActiveContent(let style, let isActive, let contentView):
            content.accessibilityQuickAction(style: style, isActive: isActive.binding(node: node, runtime: runtime)) {
                contentView
            }
        }
    }
}

// MARK: - SyntaxConvertible for AccessibilityQuickActionStyle

extension AccessibilityQuickActionStyle: @retroactive SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }
        let name = memberAccess.declName.baseName.text
        switch name {
        case "outline":
            self = .outline
        case "prompt":
            self = .prompt
        default:
            return nil
        }
    }
}
#endif
