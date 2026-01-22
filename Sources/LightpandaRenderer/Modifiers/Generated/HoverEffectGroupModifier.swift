import SwiftUI
import SwiftSyntax

/// Modifier for grouping hover effects together on visionOS.
///
/// Creates a hover effect group that coordinates multiple hover effects on descendant views.
/// When any view in the group is hovered, all effects in the group activate together.
///
/// Usage:
/// ```html
/// <!-- Simple usage - creates an implicit group for all descendant effects -->
/// <vstack modifiers="hoverEffectGroup()">
///     <text modifiers="hoverEffect()">Item 1</text>
///     <text modifiers="hoverEffect()">Item 2</text>
/// </vstack>
///
/// <!-- With explicit namespace for more control -->
/// <namespacecontext id="myGroup">
///     <vstack modifiers="hoverEffectGroup(in: myGroup)">
///         <text modifiers="hoverEffect()">Item 1</text>
///         <text modifiers="hoverEffect()">Item 2</text>
///     </vstack>
/// </namespacecontext>
///
/// <!-- With id and behavior -->
/// <namespacecontext id="myGroup">
///     <vstack modifiers="hoverEffectGroup(id: 'groupId', in: myGroup, behavior: .activatesGroup)">
///         ...
///     </vstack>
/// </namespacecontext>
/// ```
///
/// Parameters:
/// - `id`: Optional unique identifier for the group (string or identifier)
/// - `in`: The namespace identifier (references a parent `<namespacecontext id="...">`)
/// - `behavior`: How the group activates (`.activatesGroup` or `.containsGroup`). Default: `.activatesGroup`
///
/// Note: This modifier is only available on visionOS 2.0+.
#if os(visionOS)
@available(visionOS 2.0, *)
public enum HoverEffectGroupModifier<Library: ElementLibrary>: @unchecked Sendable {
    case hoverEffectGroupWithNamespace(id: String?, in: String, behavior: HoverEffectGroup.Behavior)
    case hoverEffectGroupWithGroup(HoverEffectGroup?)
    case hoverEffectGroup
}

@available(visionOS 2.0, *)
extension HoverEffectGroupModifier: RuntimeViewModifier {
    public static var baseName: String { "hoverEffectGroup" }

    public init(syntax: FunctionCallExprSyntax) throws {
        var errors: [Error] = []

        // Try to parse: hoverEffectGroup(id: "...", in: namespace, behavior: .activatesGroup)
        do {
            // Parse optional id as string or identifier
            let id: String?
            if let idArg = syntax.argument(named: "id") {
                if let stringValue = String(syntax: idArg.expression) {
                    id = stringValue
                } else if let identValue = idArg.expression.as(DeclReferenceExprSyntax.self)?.baseName.text {
                    id = identValue
                } else {
                    id = nil
                }
            } else {
                id = nil
            }

            // Parse namespace as identifier or string literal
            let namespaceId: String
            if let identifierName = syntax.argument(named: "in")?.expression.as(DeclReferenceExprSyntax.self)?.baseName.text {
                namespaceId = identifierName
            } else if let stringLiteral = syntax.argument(named: "in").flatMap({ String(syntax: $0.expression) }) {
                namespaceId = stringLiteral
            } else {
                throw ModifierParseError.missingRequiredArgument(modifier: "HoverEffectGroupModifier", argument: "in")
            }

            // Parse behavior
            let behavior: HoverEffectGroup.Behavior = syntax.argument(named: "behavior").flatMap({ HoverEffectGroup.Behavior(syntax: $0.expression) }) ?? .activatesGroup

            self = .hoverEffectGroupWithNamespace(id: id, in: namespaceId, behavior: behavior)
            return
        } catch {
            errors.append(error)
        }

        // Try to parse: hoverEffectGroup(group) or hoverEffectGroup()
        do {
            if syntax.arguments.isEmpty {
                self = .hoverEffectGroup
                return
            }

            // Check if first argument is a HoverEffectGroup (we can't really parse this from syntax)
            // So we just use the simple form
            self = .hoverEffectGroup
            return
        } catch {
            errors.append(error)
        }

        throw ModifierParseError.noMatchingVariant(modifier: "HoverEffectGroupModifier", errors: errors)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .hoverEffectGroupWithNamespace(let id, let namespaceId, let behavior):
            HoverEffectGroupBody(id: id, namespaceId: namespaceId, behavior: behavior, content: _content)
        case .hoverEffectGroupWithGroup(let group):
            _content.hoverEffectGroup(group)
        case .hoverEffectGroup:
            _content.hoverEffectGroup()
        }
    }
}

@available(visionOS 2.0, *)
private struct HoverEffectGroupBody<Content: View>: View {
    let id: String?
    let namespaceId: String
    let behavior: HoverEffectGroup.Behavior
    let content: Content

    @Environment(\.namespaces) private var namespaces

    var body: some View {
        if let namespace = namespaces[namespaceId] {
            content.hoverEffectGroup(id: id, in: namespace, behavior: behavior)
        } else {
            // Namespace not found - apply without explicit namespace
            content.hoverEffectGroup()
        }
    }
}

// MARK: - SyntaxConvertible for HoverEffectGroup.Behavior

@available(visionOS 2.0, *)
extension HoverEffectGroup.Behavior: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "activatesGroup": self = .activatesGroup
        case "containsGroup": self = .containsGroup
        default: return nil
        }
    }
}
#endif
