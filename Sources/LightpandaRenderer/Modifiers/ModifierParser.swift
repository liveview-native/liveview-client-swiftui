import SwiftParser
import SwiftSyntax
import Observation
import SwiftUI

@Observable
@MainActor
final class ModifierParser {
    /// Pre-parsed segments.
    static var cache = [String:ModifierCollection]()
    
    public init() {}
    
    /// Parse an input string into a collection of modifiers.
    public func parse(_ input: String) -> ModifierCollection {
        if let cached = Self.cache[input] {
            return cached
        }
        print("PARSING")
        let syntax = Parser.parse(source: input)
        let visitor = ModifierVisitor(viewMode: .fixedUp)
        visitor.walk(syntax)
        Self.cache[input] = visitor.modifiers
        return visitor.modifiers
    }
    
    final class ModifierVisitor: SyntaxVisitor {
        var modifiers = ModifierCollection()
        
        override func visit(_ node: FunctionCallExprSyntax) -> SyntaxVisitorContinueKind {
            if let parentModifier = node.calledExpression.as(MemberAccessExprSyntax.self)?.base?.as(FunctionCallExprSyntax.self) {
                visit(parentModifier)
            }
            
            if let modifier = try? AnyRuntimeViewModifier(node) {
                modifiers.modifiers.append(modifier)
            }
            
            return .skipChildren
        }
    }
}

struct ModifierCollection: ViewModifier {
    var modifiers: [AnyRuntimeViewModifier] = []
    
    func body(content: Content) -> some View {
        if modifiers.isEmpty {
            content
        } else {
            content
                .modifier(modifiers.first!)
                .modifier(ModifierCollection(modifiers: Array(modifiers.dropFirst())))
        }
    }
}

struct AnyRuntimeViewModifier: ViewModifier {
    static let types: [any RuntimeViewModifier.Type] = [
        PaddingModifier.self,
        StrikethroughModifier.self,
        ButtonStyleModifier.self,
        ClipShapeModifier.self,
        MultilineTextAlignmentModifier.self,
        ForegroundStyleModifier.self,
        TintModifier.self
    ]
    
    let modifier: any RuntimeViewModifier
    
    init(_ node: FunctionCallExprSyntax) throws {
        let modifierName = if let modifierName = node.calledExpression.as(MemberAccessExprSyntax.self)?.declName.baseName.text {
            modifierName
        } else if let modifierName = node.calledExpression.as(DeclReferenceExprSyntax.self)?.baseName.text {
            modifierName
        } else {
            ""
        }
        for modifierType in Self.types where modifierType.baseName == modifierName {
            do {
                self.modifier = try modifierType.init(syntax: node)
                return
            } catch {
                continue
            }
        }
        throw AnyRuntimeViewModifierError.noMatchingRuntimeViewModifier
    }
    
    func body(content: Content) -> some View {
        AnyView(_unwrap(content: content, modifier: modifier))
    }
    
    func _unwrap(content: Content, modifier: some ViewModifier) -> some View {
        content.modifier(modifier)
    }
}

enum AnyRuntimeViewModifierError: Error {
    case noMatchingRuntimeViewModifier
}
