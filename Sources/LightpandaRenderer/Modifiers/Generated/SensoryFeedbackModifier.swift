import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for playing haptic/audio feedback when a trigger value changes.
///
/// Usage:
/// ```html
/// <!-- Play success feedback when "count" attribute changes -->
/// <button modifiers="sensoryFeedback(.success, trigger: count)">
///     <text template="label">Tap me</text>
/// </button>
///
/// <!-- Play impact feedback with custom weight -->
/// <vstack modifiers="sensoryFeedback(.impact(weight: .heavy), trigger: state)">
/// ```
///
/// The `trigger` parameter should be an identifier that corresponds to an attribute
/// on the element. When that attribute's value changes, the feedback will play.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public enum SensoryFeedbackModifier<Library: ElementLibrary>: @unchecked Sendable {
    case sensoryFeedback(SensoryFeedback, attributeName: String)
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SensoryFeedbackModifier: RuntimeViewModifier {
    public static var baseName: String { "sensoryFeedback" }

    public init(syntax: FunctionCallExprSyntax) throws {
        var errors: [Error] = []

        // Parse .sensoryFeedback(.success, trigger: attributeName)
        do {
            guard let feedbackArg = syntax.arguments.first,
                  let feedback = SensoryFeedback(syntax: feedbackArg.expression) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "SensoryFeedbackModifier", argument: "feedback")
            }

            guard let triggerArg = syntax.argument(named: "trigger") else {
                throw ModifierParseError.missingRequiredArgument(modifier: "SensoryFeedbackModifier", argument: "trigger")
            }

            // The trigger should be an identifier (attribute name)
            guard let declRef = triggerArg.expression.as(DeclReferenceExprSyntax.self) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "SensoryFeedbackModifier", argument: "trigger must be an identifier")
            }

            let attributeName = declRef.baseName.text.lowercased()
            self = .sensoryFeedback(feedback, attributeName: attributeName)
            return
        } catch {
            errors.append(error)
        }

        throw ModifierParseError.noMatchingVariant(modifier: "SensoryFeedbackModifier", errors: errors)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .sensoryFeedback(let feedback, let attributeName):
            SensoryFeedbackModifierBody(feedback: feedback, attributeName: attributeName, content: _content)
        }
    }
}

/// Helper view that reads the attribute value from the node environment
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
private struct SensoryFeedbackModifierBody<Content: View>: View {
    let feedback: SensoryFeedback
    let attributeName: String
    let content: Content

    @Environment(Node.self) private var node

    var body: some View {
        // Read the attribute value to use as the feedback trigger
        let value = node.attributes[attributeName] ?? ""
        content.sensoryFeedback(feedback, trigger: value)
    }
}
