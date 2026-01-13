import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for setting the default focused view within a scope.
/// Works with NodeBinding to coordinate focus state.
///
/// Usage:
/// ```html
/// <!-- Set default focus for a binding to a specific value -->
/// <vstack modifiers="focusScope(loginForm)">
///     <textfield modifiers="focused($focusedField, equals: .username).defaultFocus($focusedField, .username)">
///     <textfield modifiers="focused($focusedField, equals: .password)">
/// </vstack>
///
/// <!-- With priority -->
/// <textfield modifiers="defaultFocus($focusedField, .username, priority: .userInitiated)">
/// ```
///
/// Note: DefaultFocus works with the focused() modifier to set which field
/// receives focus by default.
#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
public enum DefaultFocusModifier<Library: ElementLibrary>: @unchecked Sendable {
    case defaultFocus(NodeBinding<String>, String, priority: DefaultFocusEvaluationPriority)
}

@available(iOS 17.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension DefaultFocusModifier: RuntimeViewModifier {
    public static var baseName: String { "defaultFocus" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // Parse defaultFocus($binding, .value, priority: .automatic)
        guard let binding = syntax.arguments.first.flatMap({ NodeBinding<String>(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "DefaultFocusModifier", argument: "binding")
        }

        // Get the value (second argument)
        guard syntax.arguments.count > 1,
              let value = syntax.arguments[syntax.arguments.index(after: syntax.arguments.startIndex)]
                  .expression.as(MemberAccessExprSyntax.self)?.declName.baseName.text else {
            throw ModifierParseError.missingRequiredArgument(modifier: "DefaultFocusModifier", argument: "value")
        }

        let priority = syntax.argument(named: "priority")
            .flatMap({ DefaultFocusEvaluationPriority(syntax: $0.expression) }) ?? .automatic

        self = .defaultFocus(binding, value, priority: priority)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .defaultFocus(let binding, let value, let priority):
            DefaultFocusBody(binding: binding, value: value, priority: priority, content: _content)
        }
    }
}

@available(iOS 17.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
private struct DefaultFocusBody<Content: View>: View {
    let binding: NodeBinding<String>
    let value: String
    let priority: DefaultFocusEvaluationPriority
    let content: Content

    @Environment(Node.self) private var node
    @FocusState private var focusedField: String?

    var body: some View {
        content
            .defaultFocus($focusedField, value, priority: priority)
            .onAppear {
                // Sync initial state
                if let attrValue = node.attributes[binding.attributeName] {
                    focusedField = attrValue
                }
            }
            .onChange(of: focusedField) { _, newValue in
                if let value = newValue {
                    node.attributes[binding.attributeName] = value
                } else {
                    node.attributes.removeValue(forKey: binding.attributeName)
                }
            }
    }
}

// MARK: - DefaultFocusEvaluationPriority SyntaxConvertible

@available(iOS 17.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension DefaultFocusEvaluationPriority: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self),
           memberAccess.base == nil {
            switch memberAccess.declName.baseName.text {
            case "automatic":
                self = .automatic
            case "userInitiated":
                self = .userInitiated
            default:
                return nil
            }
            return
        }
        return nil
    }
}
#endif
