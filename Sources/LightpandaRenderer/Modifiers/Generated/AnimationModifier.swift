import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for applying animations to views.
/// Supports:
/// - `.animation(.easeInOut)` - animates all changes
/// - `.animation(.spring, value: identifier)` - animates when the attribute named `identifier` changes
public enum AnimationModifier<Library: ElementLibrary>: @unchecked Sendable {
    case animation(Animation?)
    case animationWithValue(Animation?, attributeName: String)
}

extension AnimationModifier: RuntimeViewModifier {
    public static var baseName: String { "animation" }

    public init(syntax: FunctionCallExprSyntax) throws {
        var errors: [Error] = []
        
        // Try to parse .animation(.easeInOut, value: identifier)
        if let valueArg = syntax.argument(named: "value") {
            // Parse the identifier from the value argument
            if let declRef = valueArg.expression.as(DeclReferenceExprSyntax.self) {
                let attributeName = declRef.baseName.text.lowercased()
                
                // Parse the animation (first argument)
                let animation: Animation?
                if let firstArg = syntax.arguments.first,
                   firstArg.label?.text != "value" {
                    if firstArg.expression.as(NilLiteralExprSyntax.self) != nil {
                        animation = nil
                    } else {
                        animation = Animation(syntax: firstArg.expression)
                    }
                } else {
                    animation = .default
                }
                
                self = .animationWithValue(animation, attributeName: attributeName)
                return
            } else {
                errors.append(ModifierParseError.missingRequiredArgument(modifier: "AnimationModifier", argument: "value must be an identifier"))
            }
        }
        
        // Parse .animation(.easeInOut) or .animation(nil)
        if syntax.arguments.isEmpty {
            // .animation() with no args - use default
            self = .animation(.default)
            return
        }
        
        if let firstArg = syntax.arguments.first {
            // Check for nil literal
            if firstArg.expression.as(NilLiteralExprSyntax.self) != nil {
                self = .animation(nil)
                return
            }
            
            // Try to parse as Animation
            if let animation = Animation(syntax: firstArg.expression) {
                self = .animation(animation)
                return
            }
        }
        
        throw ModifierParseError.noMatchingVariant(modifier: "AnimationModifier", errors: errors)
    }
    
    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .animation(let animation):
            _content.animation(animation, value: true)
        case .animationWithValue(let animation, let attributeName):
            AnimationModifierBody(animation: animation, attributeName: attributeName, content: _content)
        }
    }
}

/// Helper view that reads the attribute value from the node environment
private struct AnimationModifierBody<Content: View>: View {
    let animation: Animation?
    let attributeName: String
    let content: Content
    
    @Environment(Node.self) private var node
    
    var body: some View {
        // Read the attribute value to use as the animation trigger
        let value = node.attributes[attributeName] ?? ""
        content.animation(animation, value: value)
    }
}