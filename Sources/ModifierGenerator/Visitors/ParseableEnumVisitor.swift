import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftParser

final class ParseableEnumVisitor: SyntaxVisitor {
    var enums = [String: [String]]()
    var types = Set<String>()

    override func visit(_ node: ExtensionDeclSyntax) -> SyntaxVisitorContinueKind {
        guard
            // find extensions with conformance to `ParseableModifierValue`
            node.inheritanceClause?.inheritedTypes
                .contains(where: {
                    $0.type.trimmedDescription == "ParseableModifierValue"
                }) == true,
            // find `parser` implementation
            let parser = node.memberBlock.members.lazy
                .compactMap({ $0.decl.as(FunctionDeclSyntax.self) })
                .filter({ $0.name.text == "parser" })
                .first
        else { return .skipChildren }
        
        let name = node.extendedType.trimmedDescription
        
        // get all cases
        let caseVisitor = ConstantAtomLiteralVisitor(viewMode: SyntaxTreeViewMode.all)
        caseVisitor.walk(parser)
        
        if caseVisitor.cases.isEmpty {
            types.insert(name)
        } else {
            enums[name] = caseVisitor.cases
        }

        return .skipChildren
    }
    
    override func visit(_ node: EnumDeclSyntax) -> SyntaxVisitorContinueKind {
        // find enums with conformance to `ParseableModifierValue`
        guard node.inheritanceClause?.inheritedTypes
            .contains(where: {
                $0.type.trimmedDescription == "ParseableModifierValue"
            }) == true
        else { return .skipChildren }
        
        let name = node.name.text
        let cases = node.memberBlock.members.compactMap({ $0.decl.as(EnumCaseDeclSyntax.self)?.elements.first?.name.text })
        guard !cases.isEmpty else { return .skipChildren }
        enums[name] = cases
        
        return .skipChildren
    }
}

private final class ConstantAtomLiteralVisitor: SyntaxVisitor {
    var cases = [String]()
    
    override func visit(_ node: FunctionCallExprSyntax) -> SyntaxVisitorContinueKind {
        let baseName = node.calledExpression.as(DeclReferenceExprSyntax.self)?.baseName.text
        
        switch baseName {
        case "ConstantAtomLiteral":
            // OneOf { ... } form
            guard let value = node.arguments.first?.expression.as(StringLiteralExprSyntax.self)?.segments.description
            else { return .visitChildren }
            cases.append(value)
        case "ImplicitStaticMember":
            // ImplicitStaticMember(["case": value]) form
            guard let dictionary: DictionaryElementListSyntax = node.arguments.first?.expression.as(DictionaryExprSyntax.self)?.content.as(DictionaryElementListSyntax.self)
            else { return .visitChildren }
            let keys: [String] = dictionary.compactMap({
                $0.key.as(StringLiteralExprSyntax.self)?.segments.description
            })
            cases.append(contentsOf: keys)
        default:
            return .visitChildren
        }
        return .visitChildren
    }
}
