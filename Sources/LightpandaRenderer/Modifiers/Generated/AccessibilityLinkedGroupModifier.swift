import SwiftUI
import SwiftSyntax

/// Modifier for accessibility linked groups.
///
/// Links multiple accessibility elements so that the user can quickly navigate
/// from one element to another, even when the elements are not near each other
/// in the accessibility hierarchy.
///
/// Usage:
/// ```html
/// <!-- First, create a namespace context -->
/// <namespacecontext id="linkedGroup">
///     <!-- Then use accessibilityLinkedGroup on views that should be linked -->
///     <text modifiers="accessibilityLinkedGroup(id: 'group1', in: linkedGroup)">Item 1</text>
///     <text modifiers="accessibilityLinkedGroup(id: 'group1', in: linkedGroup)">Item 2</text>
/// </namespacecontext>
/// ```
///
/// Parameters:
/// - `id`: A unique identifier for the linked group (string, int, or identifier)
/// - `in`: The namespace identifier (references a parent `<namespacecontext id="...">`)
public enum AccessibilityLinkedGroupModifier<Library: ElementLibrary>: @unchecked Sendable {
    case accessibilityLinkedGroup(id: AnyHashable, in: String)
}

extension AccessibilityLinkedGroupModifier: RuntimeViewModifier {
    public static var baseName: String { "accessibilityLinkedGroup" }

    public init(syntax: FunctionCallExprSyntax) throws {
        var errors: [Error] = []
        do {
            guard let id = syntax.argument(named: "id").flatMap({ AnyHashable(syntax: $0.expression) }) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "AccessibilityLinkedGroupModifier", argument: "id")
            }

            // Parse namespace as identifier (e.g., linkedGroup) or string literal (e.g., "linkedGroup")
            let namespaceId: String
            if let identifierName = syntax.argument(named: "in")?.expression.as(DeclReferenceExprSyntax.self)?.baseName.text {
                namespaceId = identifierName
            } else if let stringLiteral = syntax.argument(named: "in").flatMap({ String(syntax: $0.expression) }) {
                namespaceId = stringLiteral
            } else {
                throw ModifierParseError.missingRequiredArgument(modifier: "AccessibilityLinkedGroupModifier", argument: "in")
            }

            self = .accessibilityLinkedGroup(id: id, in: namespaceId)
            return
        } catch {
            errors.append(error)
        }
        throw ModifierParseError.noMatchingVariant(modifier: "AccessibilityLinkedGroupModifier", errors: errors)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        AccessibilityLinkedGroupBody(modifier: self, content: _content)
    }
}

private struct AccessibilityLinkedGroupBody<Library: ElementLibrary, Content: View>: View {
    let modifier: AccessibilityLinkedGroupModifier<Library>
    let content: Content

    @Environment(\.namespaces) private var namespaces

    var body: some View {
        switch modifier {
        case .accessibilityLinkedGroup(let id, let namespaceId):
            if let namespace = namespaces[namespaceId] {
                content.accessibilityLinkedGroup(id: id, in: namespace)
            } else {
                // Namespace not found - render content without the effect
                content
            }
        }
    }
}
