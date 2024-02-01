import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftParser

final class EnumTypeVisitor: SyntaxVisitor {
    let typeNames: Set<String>

    var types = [String: [(String, (AvailabilityArgumentListSyntax, Set<String>))]]()

    var availability = [String: (AvailabilityArgumentListSyntax, Set<String>)]()

    init(typeNames: Set<String>) {
        self.typeNames = typeNames
        super.init(viewMode: .all)
    }

    override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
        let name = node.name.text
        guard typeNames.contains(name)
        else { return .skipChildren }
        
        if !availability.keys.contains(name) {
            availability[name] = ModifierVisitor.availability(node.attributes, node.attributes)
        }
        
        for member in node.memberBlock.members {
            guard let decl = member.decl.as(VariableDeclSyntax.self),
                  decl.modifiers.contains(where: { $0.name.tokenKind == .keyword(.static) }),
                  let binding = decl.bindings.first,
                  binding.typeAnnotation?.type.as(MemberTypeSyntax.self)?.name.text == name,
                  let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text
            else { continue }
            types[name, default: []].append((identifier, ModifierVisitor.availability(node.attributes, decl.attributes)))
        }

        return .skipChildren
    }

    override func visit(_ node: ExtensionDeclSyntax) -> SyntaxVisitorContinueKind {
        let name = node.extendedType.as(IdentifierTypeSyntax.self)?.name.text
            ?? node.extendedType.as(MemberTypeSyntax.self)?.name.text
            ?? node.extendedType.trimmedDescription
        guard typeNames.contains(name)
        else { return .skipChildren }
        
        if !availability.keys.contains(name) {
            availability[name] = ModifierVisitor.availability(node.attributes, node.attributes)
        }
        
        for member in node.memberBlock.members {
            guard let decl = member.decl.as(VariableDeclSyntax.self),
                  decl.modifiers.contains(where: { $0.name.tokenKind == .keyword(.static) }),
                  let binding = decl.bindings.first,
                  binding.typeAnnotation?.type.as(MemberTypeSyntax.self)?.name.text == name,
                  let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text
            else { continue }
            types[name, default: []].append((identifier, ModifierVisitor.availability(node.attributes, decl.attributes)))
        }

        return .skipChildren
    }
    
    override func visit(_ node: EnumDeclSyntax) -> SyntaxVisitorContinueKind {
        let name = node.name.text
        guard typeNames.contains(name)
        else { return .skipChildren }

        if !availability.keys.contains(name) {
            availability[name] = ModifierVisitor.availability(node.attributes, node.attributes)
        }

        for member in node.memberBlock.members {
            guard let `case` = member.decl.as(EnumCaseDeclSyntax.self),
                  let element = `case`.elements.first,
                  element.parameterClause == nil
            else { continue }
            types[name, default: []].append((element.name.text, ModifierVisitor.availability(node.attributes, `case`.attributes)))
        }

        return .skipChildren
    }
}
