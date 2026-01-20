import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Simplified AccessibilityRotorModifier that supports the most common accessibility rotor patterns.
///
/// Supported variants:
/// - `accessibilityRotor("Label", entries: entriesTemplate)` - Custom rotor with ViewReference entries
/// - `accessibilityRotor(.links, entries: entriesTemplate)` - System rotor with ViewReference entries
///
/// ## Usage
/// ```html
/// <vstack modifiers='accessibilityRotor("Headings", entries: rotorEntries)'>
///     <accessibilityrotorentry template="rotorEntries" id="heading1">
///         <text>First Heading</text>
///     </accessibilityrotorentry>
///     <accessibilityrotorentry template="rotorEntries" id="heading2">
///         <text>Second Heading</text>
///     </accessibilityrotorentry>
/// </vstack>
/// ```
///
/// Note: The textRanges variants and KeyPath-based entry variants cannot be supported
/// at runtime due to the inability to parse Range<String.Index> or KeyPath from syntax.
@MainActor
public enum AccessibilityRotorModifier<Library: ElementLibrary>: @unchecked Sendable {
    /// accessibilityRotor("Label", entries: { ... })
    case labelEntries(label: String, entries: String)

    /// accessibilityRotor(.systemRotor, entries: { ... })
    case systemRotorEntries(systemRotor: AccessibilitySystemRotor, entries: String)
}

extension AccessibilityRotorModifier: RuntimeViewModifier {
    public static var baseName: String { "accessibilityRotor" }

    public init(syntax: FunctionCallExprSyntax) throws {
        var errors: [Error] = []

        // Try to parse: accessibilityRotor(.systemRotor, entries: ...)
        do {
            guard let systemRotor = (syntax.arguments.first).flatMap({ AccessibilitySystemRotor(syntax: $0.expression) }) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "AccessibilityRotorModifier", argument: "systemRotor")
            }
            guard let entries = syntax.argument(named: "entries").flatMap({ String(syntax: $0.expression) }) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "AccessibilityRotorModifier", argument: "entries")
            }
            self = .systemRotorEntries(systemRotor: systemRotor, entries: entries)
            return
        } catch {
            errors.append(error)
        }

        // Try to parse: accessibilityRotor("Label", entries: ...)
        do {
            guard let label = (syntax.arguments.first).flatMap({ String(syntax: $0.expression) }) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "AccessibilityRotorModifier", argument: "label")
            }
            guard let entries = syntax.argument(named: "entries").flatMap({ String(syntax: $0.expression) }) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "AccessibilityRotorModifier", argument: "entries")
            }
            self = .labelEntries(label: label, entries: entries)
            return
        } catch {
            errors.append(error)
        }

        throw ModifierParseError.noMatchingVariant(modifier: "AccessibilityRotorModifier", errors: errors)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        AccessibilityRotorModifierBody<Library>(modifier: self, content: _content)
    }
}

/// Internal view that resolves ViewReference at runtime using environment.
private struct AccessibilityRotorModifierBody<Library: ElementLibrary>: View {
    let modifier: AccessibilityRotorModifier<Library>
    let content: AccessibilityRotorModifier<Library>.Content

    @Environment(Node.self) private var node
    
    @Environment(\.namespaces) private var namespaces

    var body: some View {
        switch modifier {
        case .labelEntries(let label, let entries):
            content.accessibilityRotor(label) {
                makeEntries(entries)
            }
        case .systemRotorEntries(let systemRotor, let entries):
            content.accessibilityRotor(systemRotor) {
                makeEntries(entries)
            }
        }
    }
    
    func makeEntries(_ template: String) -> some AccessibilityRotorContent {
        ForEach(node.children) { node in
            if node.name.lowercased() == "accessibilityrotorentry" && node.hasTemplate(template) {
                if let namespace = namespaces[node.attributeValue(for: "namespace") ?? ""] {
                    AccessibilityRotorEntry(
                        node.attributeValue(for: "label") ?? "",
                        node.attributeValue(for: "id") ?? "",
                        in: namespace
                    )
                }
            }
        }
    }
}
