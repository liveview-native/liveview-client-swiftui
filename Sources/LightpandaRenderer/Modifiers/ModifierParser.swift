import SwiftParser
import SwiftSyntax
import Observation
import SwiftUI

@Observable
@MainActor
final class ModifierParser<Library: ElementLibrary> {
    /// Pre-parsed segments.
    var cache = [String:ModifierCollection<Library>]()
    
    public init() {}
    
    /// Parse an input string into a collection of modifiers.
    public func parse(_ input: String) -> ModifierCollection<Library> {
        if let cached = cache[input] {
            return cached
        }
        print("PARSING")
        let syntax = Parser.parse(source: input)
        let visitor = ModifierVisitor(viewMode: .fixedUp)
        visitor.walk(syntax)
        cache[input] = visitor.modifiers
        return visitor.modifiers
    }
    
    final class ModifierVisitor: SyntaxVisitor {
        var modifiers = ModifierCollection<Library>()
        
        override func visit(_ node: FunctionCallExprSyntax) -> SyntaxVisitorContinueKind {
            if let parentModifier = node.calledExpression.as(MemberAccessExprSyntax.self)?.base?.as(FunctionCallExprSyntax.self) {
                visit(parentModifier)
            }
            
            do {
                let modifier = try AnyRuntimeViewModifier<Library>(node)
                modifiers.modifiers.append(modifier)
            } catch {
                print("=== MODIFIER PARSE ERROR ===")
                print(error.localizedDescription)
            }
            
            return .skipChildren
        }
    }
}

struct ModifierCollection<Library: ElementLibrary>: ViewModifier {
    var modifiers: [AnyRuntimeViewModifier<Library>] = []
    
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

struct AnyRuntimeViewModifier<Library: ElementLibrary>: ViewModifier {
    static var types: [any RuntimeViewModifier<Library>.Type] {
        [
            PaddingModifier<Library>.self,
            StrikethroughModifier<Library>.self,
            ButtonStyleModifier<Library>.self,
            ClipShapeModifier<Library>.self,
            MultilineTextAlignmentModifier<Library>.self,
            ForegroundStyleModifier<Library>.self,
            TintModifier<Library>.self,
            FrameModifier<Library>.self,
            FontModifier<Library>.self,
            SwipeActionsModifier<Library>.self,
            SafeAreaInsetModifier<Library>.self,
            BackgroundModifier<Library>.self,
            OverlayModifier<Library>.self,
            GlassEffectModifier<Library>.self,
            NavigationTitleModifier<Library>.self,
            TextFieldStyleModifier<Library>.self,
        ]
    }
    
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
        throw AnyRuntimeViewModifierError.noMatchingRuntimeViewModifier(modifierName)
    }
    
    func body(content: Content) -> some View {
        AnyView(_unwrap(content: content, modifier: modifier))
    }
    
    func _unwrap(content: Content, modifier: some ViewModifier) -> some View {
        content.modifier(modifier)
    }
}

enum AnyRuntimeViewModifierError: Error, LocalizedError {
    case noMatchingRuntimeViewModifier(String)
    
    var errorDescription: String? {
        switch self {
        case .noMatchingRuntimeViewModifier(let name):
            return "No matching modifier for '\(name)'"
        }
    }
}
