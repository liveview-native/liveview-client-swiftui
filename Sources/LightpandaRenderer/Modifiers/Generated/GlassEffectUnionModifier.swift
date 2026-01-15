import SwiftUI
import SwiftSyntax

/// Modifier for glass effect unions.
///
/// Associates any Liquid Glass effects defined within this view to a union with the provided identifier.
///
/// Usage:
/// ```html
/// <!-- First, create a namespace context -->
/// <namespacecontext id="glassUnion">
///     <!-- Then use glassEffectUnion on views that should share the same glass union -->
///     <vstack modifiers="glassEffectUnion(id: 'myGlass', namespace: glassUnion)">
///         ...
///     </vstack>
/// </namespacecontext>
/// ```
///
/// Parameters:
/// - `id`: A unique identifier for the glass effect union (string, int, or identifier). Optional.
/// - `namespace`: The namespace identifier (references a parent `<namespacecontext id="...">`)
#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
@available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *)
public enum GlassEffectUnionModifier<Library: ElementLibrary>: @unchecked Sendable {
    case glassEffectUnion(id: AnyHashable?, namespace: String)
}

@available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *)
extension GlassEffectUnionModifier: RuntimeViewModifier {
    public static var baseName: String { "glassEffectUnion" }

    public init(syntax: FunctionCallExprSyntax) throws {
        var errors: [Error] = []
        do {
            // Parse id as optional (can be string, int, or identifier)
            let id: AnyHashable? = syntax.argument(named: "id").flatMap({ AnyHashable(syntax: $0.expression) })

            // Parse namespace as identifier (e.g., glassUnion) or string literal (e.g., "glassUnion")
            let namespaceId: String
            if let identifierName = syntax.argument(named: "namespace")?.expression.as(DeclReferenceExprSyntax.self)?.baseName.text {
                namespaceId = identifierName
            } else if let stringLiteral = syntax.argument(named: "namespace").flatMap({ String(syntax: $0.expression) }) {
                namespaceId = stringLiteral
            } else {
                throw ModifierParseError.missingRequiredArgument(modifier: "GlassEffectUnionModifier", argument: "namespace")
            }

            self = .glassEffectUnion(id: id, namespace: namespaceId)
            return
        } catch {
            errors.append(error)
        }
        throw ModifierParseError.noMatchingVariant(modifier: "GlassEffectUnionModifier", errors: errors)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        GlassEffectUnionModifierBody(modifier: self, content: _content)
    }
}

@available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *)
private struct GlassEffectUnionModifierBody<Library: ElementLibrary, Content: View>: View {
    let modifier: GlassEffectUnionModifier<Library>
    let content: Content

    @Environment(\.namespaces) private var namespaces

    var body: some View {
        switch modifier {
        case .glassEffectUnion(let id, let namespaceId):
            if let namespace = namespaces[namespaceId] {
                content.glassEffectUnion(id: id, namespace: namespace)
            } else {
                // Namespace not found - render content without the effect
                content
            }
        }
    }
}
#endif
