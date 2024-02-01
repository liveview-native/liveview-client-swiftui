import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftParser

final class ParseableModifierVisitor: SyntaxVisitor {
    var modifiers = [String: [StylesheetLanguageSchema.Signature]]()
    
    override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
        // find structs with the `ParseableExpression` macro
        guard node.attributes.contains(where: { $0.as(AttributeSyntax.self)?.attributeName.as(IdentifierTypeSyntax.self)?.name.text == "ParseableExpression" }),
              let name: String = node.memberBlock.members.lazy.compactMap({
                  guard let decl: VariableDeclSyntax = $0.decl.as(VariableDeclSyntax.self),
                        let binding: PatternBindingSyntax = decl.bindings.first?.as(PatternBindingSyntax.self),
                        binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text == "name",
                        let name = (
                            binding.initializer?.value.as(StringLiteralExprSyntax.self)
                            ?? binding.accessorBlock?.accessors.getter?.first?.item.as(StringLiteralExprSyntax.self)
                        )?.segments.description
                  else { return nil }
                  return name
              }).first
        else { return .skipChildren }
        
        let visitor = ParseableModifierInitVisitor(viewMode: .all)
        visitor.walk(node.memberBlock)
        
        modifiers[name] = visitor.signatures
        
        return .skipChildren
    }
    
    override func visit(_ node: ExtensionDeclSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }
}

private final class ParseableModifierInitVisitor: SyntaxVisitor {
    var signatures = [StylesheetLanguageSchema.Signature]()
    
    override func visit(_ node: InitializerDeclSyntax) -> SyntaxVisitorContinueKind {
        signatures.append(
            .init(
                parameters: node.signature.parameterClause.parameters.map { (parameter: FunctionParameterSyntax) in
                    StylesheetLanguageSchema.Signature.Parameter(firstName: parameter.firstName.text, secondName: parameter.secondName?.text, type: parameter.type.trimmedDescription)
                }
            )
        )
        return .skipChildren
    }
}

extension AccessorBlockSyntax.Accessors {
    var getter: CodeBlockItemListSyntax? {
        guard case let .getter(codeBlockItemList) = self else { return nil }
        return codeBlockItemList
    }
}
