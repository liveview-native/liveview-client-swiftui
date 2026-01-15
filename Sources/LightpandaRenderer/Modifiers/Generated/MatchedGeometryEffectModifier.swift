import SwiftUI
import SwiftSyntax

/// Modifier for matched geometry effects.
///
/// Creates a synchronized animation between views that share the same ID and namespace.
///
/// Usage:
/// ```html
/// <!-- First, create a namespace context -->
/// <namespacecontext id="heroAnimation">
///     <!-- Then use matchedGeometryEffect on views that should animate together -->
///     <image systemname="star.fill" modifiers="matchedGeometryEffect(id: 'starIcon', in: heroAnimation)" />
/// </namespacecontext>
/// ```
///
/// Parameters:
/// - `id`: A unique identifier for the geometry effect (string, int, or identifier)
/// - `in`: The namespace identifier (references a parent `<namespacecontext id="...">`)
/// - `properties`: Which properties to match (`.frame`, `.position`, `.size`). Default: `.frame`
/// - `anchor`: The anchor point for alignment. Default: `.center`
/// - `isSource`: Whether this view is the source of the geometry. Default: `true`
public enum MatchedGeometryEffectModifier<Library: ElementLibrary>: @unchecked Sendable {
    case matchedGeometryEffect(id: AnyHashable, in: String, properties: MatchedGeometryProperties, anchor: UnitPoint, isSource: Bool)
}

extension MatchedGeometryEffectModifier: RuntimeViewModifier {
    public static var baseName: String { "matchedGeometryEffect" }

    public init(syntax: FunctionCallExprSyntax) throws {
        var errors: [Error] = []
        do {
            guard let id = syntax.argument(named: "id").flatMap({ AnyHashable(syntax: $0.expression) }) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "MatchedGeometryEffectModifier", argument: "id")
            }

            // Parse namespace as identifier (e.g., heroAnimation) or string literal (e.g., "heroAnimation")
            let namespaceId: String
            if let identifierName = syntax.argument(named: "in")?.expression.as(DeclReferenceExprSyntax.self)?.baseName.text {
                namespaceId = identifierName
            } else if let stringLiteral = syntax.argument(named: "in").flatMap({ String(syntax: $0.expression) }) {
                namespaceId = stringLiteral
            } else {
                throw ModifierParseError.missingRequiredArgument(modifier: "MatchedGeometryEffectModifier", argument: "in")
            }

            let properties: MatchedGeometryProperties = syntax.argument(named: "properties").flatMap({ MatchedGeometryProperties(syntax: $0.expression) }) ?? .frame
            let anchor: UnitPoint = syntax.argument(named: "anchor").flatMap({ UnitPoint(syntax: $0.expression) }) ?? .center
            let isSource: Bool = syntax.argument(named: "isSource").flatMap({ Bool(syntax: $0.expression) }) ?? true
            self = .matchedGeometryEffect(id: id, in: namespaceId, properties: properties, anchor: anchor, isSource: isSource)
            return
        } catch {
            errors.append(error)
        }
        throw ModifierParseError.noMatchingVariant(modifier: "MatchedGeometryEffectModifier", errors: errors)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        MatchedGeometryEffectBody(modifier: self, content: _content)
    }
}

private struct MatchedGeometryEffectBody<Library: ElementLibrary, Content: View>: View {
    let modifier: MatchedGeometryEffectModifier<Library>
    let content: Content

    @Environment(\.namespaces) private var namespaces

    var body: some View {
        switch modifier {
        case .matchedGeometryEffect(let id, let namespaceId, let properties, let anchor, let isSource):
            if let namespace = namespaces[namespaceId] {
                content.matchedGeometryEffect(id: id, in: namespace, properties: properties, anchor: anchor, isSource: isSource)
            } else {
                // Namespace not found - render content without the effect
                content
            }
        }
    }
}