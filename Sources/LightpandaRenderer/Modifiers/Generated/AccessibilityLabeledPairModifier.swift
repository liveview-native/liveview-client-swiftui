import SwiftUI
import SwiftSyntax

/// Modifier for accessibility labeled pairs.
///
/// Pairs an accessibility element representing a label with the element for the matching content.
/// This helps VoiceOver understand the relationship between a label and its associated control.
///
/// Usage:
/// ```html
/// <!-- First, create a namespace context -->
/// <namespacecontext id="myAccessibility">
///     <!-- Label element -->
///     <text modifiers="accessibilityLabeledPair(role: .label, id: 'myControl', in: myAccessibility)">
///         Username
///     </text>
///     <!-- Content element -->
///     <textfield modifiers="accessibilityLabeledPair(role: .content, id: 'myControl', in: myAccessibility)" />
/// </namespacecontext>
/// ```
///
/// Parameters:
/// - `role`: Either `.label` for the label element or `.content` for the control element
/// - `id`: A unique identifier that pairs the label and content together (string, int, or identifier)
/// - `in`: The namespace identifier (references a parent `<namespacecontext id="...">`)
public enum AccessibilityLabeledPairModifier<Library: ElementLibrary>: @unchecked Sendable {
    case accessibilityLabeledPair(role: SwiftUI.AccessibilityLabeledPairRole, id: AnyHashable, in: String)
}

extension AccessibilityLabeledPairModifier: RuntimeViewModifier {
    public static var baseName: String { "accessibilityLabeledPair" }

    public init(syntax: FunctionCallExprSyntax) throws {
        var errors: [Error] = []
        do {
            guard let role = syntax.argument(named: "role").flatMap({ SwiftUI.AccessibilityLabeledPairRole(syntax: $0.expression) }) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "AccessibilityLabeledPairModifier", argument: "role")
            }
            guard let id = syntax.argument(named: "id").flatMap({ AnyHashable(syntax: $0.expression) }) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "AccessibilityLabeledPairModifier", argument: "id")
            }

            // Parse namespace as identifier (e.g., myAccessibility) or string literal (e.g., "myAccessibility")
            let namespaceId: String
            if let identifierName = syntax.argument(named: "in")?.expression.as(DeclReferenceExprSyntax.self)?.baseName.text {
                namespaceId = identifierName
            } else if let stringLiteral = syntax.argument(named: "in").flatMap({ String(syntax: $0.expression) }) {
                namespaceId = stringLiteral
            } else {
                throw ModifierParseError.missingRequiredArgument(modifier: "AccessibilityLabeledPairModifier", argument: "in")
            }

            self = .accessibilityLabeledPair(role: role, id: id, in: namespaceId)
            return
        } catch {
            errors.append(error)
        }
        throw ModifierParseError.noMatchingVariant(modifier: "AccessibilityLabeledPairModifier", errors: errors)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        AccessibilityLabeledPairBody(modifier: self, content: _content)
    }
}

private struct AccessibilityLabeledPairBody<Library: ElementLibrary, Content: View>: View {
    let modifier: AccessibilityLabeledPairModifier<Library>
    let content: Content

    @Environment(\.namespaces) private var namespaces

    var body: some View {
        switch modifier {
        case .accessibilityLabeledPair(let role, let id, let namespaceId):
            if let namespace = namespaces[namespaceId] {
                content.accessibilityLabeledPair(role: role, id: id, in: namespace)
            } else {
                // Namespace not found - render content without the effect
                content
            }
        }
    }
}
