import SwiftUI
import SwiftSyntax

/// Modifier for accessibility rotor entries.
///
/// Defines an explicit identifier tying an Accessibility element for this view
/// to an entry in an Accessibility Rotor.
///
/// Usage:
/// ```html
/// <!-- First, create a namespace context -->
/// <namespacecontext id="headings">
///     <!-- Then use accessibilityRotorEntry on views that should be rotor entries -->
///     <text modifiers="accessibilityRotorEntry(id: 'section1', in: headings)">Section 1</text>
/// </namespacecontext>
/// ```
///
/// Parameters:
/// - `id`: A unique identifier for the rotor entry (string, int, or identifier)
/// - `in`: The namespace identifier (references a parent `<namespacecontext id="...">`)
public enum AccessibilityRotorEntryModifier<Library: ElementLibrary>: @unchecked Sendable {
    case accessibilityRotorEntry(id: AnyHashable, in: String)
}

extension AccessibilityRotorEntryModifier: RuntimeViewModifier {
    public static var baseName: String { "accessibilityRotorEntry" }

    public init(syntax: FunctionCallExprSyntax) throws {
        var errors: [Error] = []
        do {
            guard let id = syntax.argument(named: "id").flatMap({ AnyHashable(syntax: $0.expression) }) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "AccessibilityRotorEntryModifier", argument: "id")
            }

            // Parse namespace as identifier (e.g., headings) or string literal (e.g., "headings")
            let namespaceId: String
            if let identifierName = syntax.argument(named: "in")?.expression.as(DeclReferenceExprSyntax.self)?.baseName.text {
                namespaceId = identifierName
            } else if let stringLiteral = syntax.argument(named: "in").flatMap({ String(syntax: $0.expression) }) {
                namespaceId = stringLiteral
            } else {
                throw ModifierParseError.missingRequiredArgument(modifier: "AccessibilityRotorEntryModifier", argument: "in")
            }

            self = .accessibilityRotorEntry(id: id, in: namespaceId)
            return
        } catch {
            errors.append(error)
        }
        throw ModifierParseError.noMatchingVariant(modifier: "AccessibilityRotorEntryModifier", errors: errors)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        AccessibilityRotorEntryBody(modifier: self, content: _content)
    }
}

private struct AccessibilityRotorEntryBody<Library: ElementLibrary, Content: View>: View {
    let modifier: AccessibilityRotorEntryModifier<Library>
    let content: Content

    @Environment(\.namespaces) private var namespaces

    var body: some View {
        switch modifier {
        case .accessibilityRotorEntry(let id, let namespaceId):
            if let namespace = namespaces[namespaceId] {
                content.accessibilityRotorEntry(id: id, in: namespace)
            } else {
                // Namespace not found - render content without the effect
                content
            }
        }
    }
}
