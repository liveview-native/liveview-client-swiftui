import SwiftUI
import SwiftSyntax

/// Modifier for glass effect IDs.
///
/// Associates an identity value to Liquid Glass effects defined within a view,
/// enabling fluid morphing transitions between glass elements.
///
/// Usage:
/// ```html
/// <!-- First, create a namespace context -->
/// <namespacecontext id="glassAnimation">
///     <!-- Then use glassEffectID on views with glassEffect that should animate together -->
///     <button modifiers="glassEffect().glassEffectID('mainButton', in: glassAnimation)">
///         <text template="label">Button</text>
///     </button>
/// </namespacecontext>
/// ```
///
/// Parameters:
/// - `id`: A unique identifier for the glass effect (string, int, or identifier). Pass nil to remove association.
/// - `in`: The namespace identifier (references a parent `<namespacecontext id="...">`)
#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
public enum GlassEffectIDModifier<Library: ElementLibrary>: @unchecked Sendable {
    case glassEffectID(id: AnyHashableSendable?, in: String)
}

extension GlassEffectIDModifier: RuntimeViewModifier {
    public static var baseName: String { "glassEffectID" }

    public init(syntax: FunctionCallExprSyntax) throws {
        var errors: [Error] = []
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *) {
            do {
                // Parse id - can be nil, string, int, etc.
                let id: AnyHashableSendable?
                if let firstArg = syntax.arguments.first {
                    if firstArg.expression.is(NilLiteralExprSyntax.self) {
                        id = nil
                    } else if let parsedId = AnyHashableSendable(syntax: firstArg.expression) {
                        id = parsedId
                    } else {
                        // Try parsing as identifier reference
                        if let identifierName = firstArg.expression.as(DeclReferenceExprSyntax.self)?.baseName.text {
                            id = AnyHashableSendable(identifierName)
                        } else {
                            throw ModifierParseError.missingRequiredArgument(modifier: "GlassEffectIDModifier", argument: "id")
                        }
                    }
                } else {
                    throw ModifierParseError.missingRequiredArgument(modifier: "GlassEffectIDModifier", argument: "id")
                }

                // Parse namespace as identifier (e.g., heroAnimation) or string literal (e.g., "heroAnimation")
                let namespaceId: String
                if let identifierName = syntax.argument(named: "in")?.expression.as(DeclReferenceExprSyntax.self)?.baseName.text {
                    namespaceId = identifierName
                } else if let stringLiteral = syntax.argument(named: "in").flatMap({ String(syntax: $0.expression) }) {
                    namespaceId = stringLiteral
                } else {
                    throw ModifierParseError.missingRequiredArgument(modifier: "GlassEffectIDModifier", argument: "in")
                }

                self = .glassEffectID(id: id, in: namespaceId)
                return
            } catch {
                errors.append(error)
            }
        }
        throw ModifierParseError.noMatchingVariant(modifier: "GlassEffectIDModifier", errors: errors)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        GlassEffectIDBody(modifier: self, content: _content)
    }
}

@available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *)
private struct GlassEffectIDBody<Library: ElementLibrary, Content: View>: View {
    let modifier: GlassEffectIDModifier<Library>
    let content: Content

    @Environment(\.namespaces) private var namespaces

    var body: some View {
        switch modifier {
        case .glassEffectID(let id, let namespaceId):
            if let namespace = namespaces[namespaceId] {
                content.glassEffectID(id, in: namespace)
            } else {
                // Namespace not found - render content without the effect
                content
            }
        }
    }
}

public struct AnyHashableSendable: Hashable, @unchecked Sendable, SyntaxConvertible {
    let value: AnyHashable
    
    public init?(syntax: some SyntaxProtocol) {
        guard let value = AnyHashable(syntax: syntax)
        else { return nil }
        self.value = value
    }
    
    init(_ value: some Hashable & Sendable) {
        self.value = AnyHashable(value)
    }
}
#endif
