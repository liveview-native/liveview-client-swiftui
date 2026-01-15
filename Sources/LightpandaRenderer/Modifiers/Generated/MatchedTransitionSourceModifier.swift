import SwiftUI
import SwiftSyntax

/// Modifier for matched transition source effects.
///
/// Identifies a view as the source of a navigation transition (like zoom).
/// Used with `navigationTransition(.zoom(sourceID:in:))` on the destination.
///
/// Usage:
/// ```html
/// <!-- First, create a namespace context -->
/// <namespacecontext id="zoomTransition">
///     <!-- Then use matchedTransitionSource on the source view -->
///     <image systemname="star.fill" modifiers="matchedTransitionSource(id: 'starIcon', in: zoomTransition)" />
/// </namespacecontext>
/// ```
///
/// Parameters:
/// - `id`: A unique identifier for the transition (string, int, or identifier)
/// - `in`: The namespace identifier (references a parent `<namespacecontext id="...">`)
@available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
public enum MatchedTransitionSourceModifier<Library: ElementLibrary>: @unchecked Sendable {
    case matchedTransitionSource(id: AnyHashable, in: String)
}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
extension MatchedTransitionSourceModifier: RuntimeViewModifier {
    public static var baseName: String { "matchedTransitionSource" }

    public init(syntax: FunctionCallExprSyntax) throws {
        var errors: [Error] = []
        do {
            guard let id = syntax.argument(named: "id").flatMap({ AnyHashable(syntax: $0.expression) }) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "MatchedTransitionSourceModifier", argument: "id")
            }

            // Parse namespace as identifier (e.g., zoomTransition) or string literal (e.g., "zoomTransition")
            let namespaceId: String
            if let identifierName = syntax.argument(named: "in")?.expression.as(DeclReferenceExprSyntax.self)?.baseName.text {
                namespaceId = identifierName
            } else if let stringLiteral = syntax.argument(named: "in").flatMap({ String(syntax: $0.expression) }) {
                namespaceId = stringLiteral
            } else {
                throw ModifierParseError.missingRequiredArgument(modifier: "MatchedTransitionSourceModifier", argument: "in")
            }

            self = .matchedTransitionSource(id: id, in: namespaceId)
            return
        } catch {
            errors.append(error)
        }
        throw ModifierParseError.noMatchingVariant(modifier: "MatchedTransitionSourceModifier", errors: errors)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        MatchedTransitionSourceBody(modifier: self, content: _content)
    }
}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
private struct MatchedTransitionSourceBody<Library: ElementLibrary, Content: View>: View {
    let modifier: MatchedTransitionSourceModifier<Library>
    let content: Content

    @Environment(\.namespaces) private var namespaces

    var body: some View {
        switch modifier {
        case .matchedTransitionSource(let id, let namespaceId):
            if let namespace = namespaces[namespaceId] {
                content.matchedTransitionSource(id: id, in: namespace)
            } else {
                // Namespace not found - render content without the effect
                content
            }
        }
    }
}
