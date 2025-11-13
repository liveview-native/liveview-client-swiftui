import SwiftParser
import SwiftSyntax
import Observation
import SwiftUI

@Observable

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
            let modifierName = if let modifierName = node.calledExpression.as(MemberAccessExprSyntax.self)?.declName.baseName.text {
                modifierName
            } else if let modifierName = node.calledExpression.as(DeclReferenceExprSyntax.self)?.baseName.text {
                modifierName
            } else {
                ""
            }
            
            if let modifier = AnyModifier(modifierName, arguments: node.arguments) {
                modifiers.modifiers.append(modifier)
            }
            
            return .skipChildren
        }
    }
}

struct ModifierCollection: ViewModifier {
    var modifiers: [AnyModifier] = []
    
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

enum AnyModifier: ViewModifier {
    case padding(PaddingModifier)
    case background(BackgroundModifier)
    
    init?(_ modifierName: String, arguments: LabeledExprListSyntax) {
        switch modifierName {
        case "padding":
            guard let padding = PaddingModifier(arguments: arguments)
            else { return nil }
            self = .padding(padding)
        case "background":
            guard let background = BackgroundModifier(arguments: arguments)
            else { return nil }
            self = .background(background)
        default:
            return nil
        }
    }
    
    enum BackgroundModifier: ViewModifier {
        case color(SwiftUI.Color)
        
        init?(arguments: LabeledExprListSyntax) {
            switch arguments.first?.expression.trimmedDescription {
            case ".red":
                self = .color(.red)
            case ".green":
                self = .color(.green)
            case ".blue":
                self = .color(.blue)
            default:
                return nil
            }
        }
        
        func body(content: Content) -> some View {
            switch self {
            case .color(let color):
                content.background(color)
            }
        }
    }
    
    func body(content: Content) -> some View {
        switch self {
        case .padding(let paddingModifier):
            content.modifier(paddingModifier)
        case .background(let backgroundModifier):
            content.modifier(backgroundModifier)
        }
    }
}
