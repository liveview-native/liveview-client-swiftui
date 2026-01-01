import SwiftSyntax
import SwiftParser
import SwiftUI

/// Parses text modifier strings and returns a collection of text modifiers.
///
/// Example:
/// ```swift
/// let modifiers = TextModifierParser.parse("bold().italic().foregroundStyle(.red)")
/// let styledText = modifiers.apply(to: Text("Hello"))
/// ```
@MainActor
public enum TextModifierParser {
    /// All modifier types that support text transformations.
    /// These types conform to both RuntimeViewModifier and RuntimeTextModifier.
    public static var types: [any RuntimeTextModifier.Type] {
        [
            BoldModifier<SwiftUIElementLibrary>.self,
            ItalicModifier<SwiftUIElementLibrary>.self,
            UnderlineModifier<SwiftUIElementLibrary>.self,
            StrikethroughModifier<SwiftUIElementLibrary>.self,
            FontModifier<SwiftUIElementLibrary>.self,
            ForegroundStyleModifier<SwiftUIElementLibrary>.self,
            BaselineOffsetModifier<SwiftUIElementLibrary>.self,
            KerningModifier<SwiftUIElementLibrary>.self,
            TrackingModifier<SwiftUIElementLibrary>.self,
            MonospacedModifier<SwiftUIElementLibrary>.self,
            MonospacedDigitModifier<SwiftUIElementLibrary>.self,
        ]
    }
    
    /// Parse a modifier string and return a collection of text modifiers
    public static func parse(_ modifiers: String) -> TextModifierCollection {
        let sourceFile = Parser.parse(source: modifiers)
        
        // First pass: collect function call syntax nodes
        let visitor = FunctionCallCollector(viewMode: .sourceAccurate)
        visitor.walk(sourceFile)
        
        // Second pass: create modifiers on MainActor
        var result = [AnyRuntimeTextModifier]()
        for node in visitor.functionCalls {
            // Get the function name
            let baseName: String
            if let memberAccess = node.calledExpression.as(MemberAccessExprSyntax.self) {
                baseName = memberAccess.declName.baseName.text
            } else if let identifier = node.calledExpression.as(DeclReferenceExprSyntax.self) {
                baseName = identifier.baseName.text
            } else {
                continue
            }
            
            // Try to find a matching text modifier type
            for type in types {
                if type.baseName == baseName {
                    do {
                        let modifier = try type.init(syntax: node)
                        result.append(AnyRuntimeTextModifier(modifier))
                    } catch {
                        // Failed to parse this modifier, skip it
                    }
                    break
                }
            }
        }
        
        return TextModifierCollection(modifiers: result)
    }
}

/// A collection of parsed text modifiers that can be applied to Text
@MainActor
public struct TextModifierCollection: Sendable {
    public let modifiers: [AnyRuntimeTextModifier]
    
    public init(modifiers: [AnyRuntimeTextModifier] = []) {
        self.modifiers = modifiers
    }
    
    /// Apply all modifiers to the given Text
    public func apply(to text: Text) -> Text {
        modifiers.reduce(text) { result, modifier in
            modifier.textBody(content: result)
        }
    }
}

/// Simple visitor that collects function call syntax nodes
private final class FunctionCallCollector: SyntaxVisitor {
    var functionCalls = [FunctionCallExprSyntax]()
    
    override func visit(_ node: FunctionCallExprSyntax) -> SyntaxVisitorContinueKind {
        functionCalls.append(node)
        return .visitChildren
    }
}
