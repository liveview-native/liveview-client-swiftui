//
//  AutoAddon.swift
//  LiveViewNative
//
//  Created by Carson Katri on 3/6/25.
//

import ArgumentParser
import Foundation
import SwiftSyntax
import SwiftParser
import SwiftSyntaxBuilder

@main
struct AutoAddon: ParsableCommand {
    @Argument private var name: String
    @Argument private var outputFile: String
    @Argument private var inputFiles: [String]
    
    func run() throws {
        let visitor = LiveElementVisitor(viewMode: .fixedUp)
        
        for inputFile in self.inputFiles {
            guard let inputFile = URL(string: inputFile)
            else { continue }
            let source = try String(contentsOf: inputFile, encoding: .utf8)
            let sourceFile = Parser.parse(source: source)
            visitor.walk(sourceFile)
        }
        
        /// The `TagName` enum required by `CustomRegistry`.
        let tagNameDecl = EnumDeclSyntax(
            modifiers: [
                DeclModifierSyntax(name: .keyword(.public))
            ],
            name: .identifier("TagName"),
            inheritanceClause: InheritanceClauseSyntax {
                InheritedTypeSyntax(type: IdentifierTypeSyntax(name: .identifier("String")))
            }
        ) {
            EnumCaseDeclSyntax {
                for liveElement in visitor.liveElements {
                    EnumCaseElementSyntax(name: .identifier(liveElement))
                }
            }
        }
        
        /// static `lookup` function required by `CustomRegistry`.
        /// ```
        /// static func lookup(_ name: TagName, element: ElementNode) -> some View
        /// ```
        let lookupDecl = FunctionDeclSyntax(
            attributes: [
                .attribute(AttributeSyntax(attributeName: IdentifierTypeSyntax(name: .identifier("MainActor")))),
                .attribute(AttributeSyntax(attributeName: IdentifierTypeSyntax(name: .identifier("ViewBuilder")))),
            ],
            modifiers: [
                DeclModifierSyntax(name: .keyword(.public)),
                DeclModifierSyntax(name: .keyword(.static))
            ],
            name: .identifier("lookup"),
            signature: FunctionSignatureSyntax(
                parameterClause: FunctionParameterClauseSyntax {
                    FunctionParameterSyntax(
                        firstName: .wildcardToken(),
                        secondName: .identifier("name"),
                        type: IdentifierTypeSyntax(name: .identifier("TagName"))
                    )
                    FunctionParameterSyntax(
                        firstName: .identifier("element"),
                        type: IdentifierTypeSyntax(name: .identifier("ElementNode"))
                    )
                },
                returnClause: ReturnClauseSyntax(
                    type: SomeOrAnyTypeSyntax(
                        someOrAnySpecifier: .keyword(.some),
                        constraint: IdentifierTypeSyntax(name: .identifier("View"))
                    )
                )
            )
        ) {
            SwitchExprSyntax(subject: DeclReferenceExprSyntax(baseName: .identifier("name"))) {
                for liveElement in visitor.liveElements {
                    SwitchCaseSyntax(label: .case(SwitchCaseLabelSyntax {
                        SwitchCaseItemSyntax(pattern: ExpressionPatternSyntax(
                            expression: MemberAccessExprSyntax(name: .identifier(liveElement))
                        ))
                    })) {
                        // create the matching View for the TagName
                        FunctionCallExprSyntax(
                            callee: TypeExprSyntax(
                                type: IdentifierTypeSyntax(
                                    name: .identifier(liveElement),
                                    genericArgumentClause: GenericArgumentClauseSyntax {
                                        GenericArgumentSyntax(argument: IdentifierTypeSyntax(name: .identifier("Root")))
                                    }
                                )
                            )
                        )
                    }
                }
            }
        }
        
        /// Addon struct declaration using the `@Addon` macro in an extension of `Addons`.
        let addonDecl = ExtensionDeclSyntax(
            modifiers: [DeclModifierSyntax(name: .keyword(.public))],
            extendedType: IdentifierTypeSyntax(name: .identifier("Addons"))
        ) {
            StructDeclSyntax(
                attributes: [.attribute(AttributeSyntax(attributeName: IdentifierTypeSyntax(name: .identifier("Addon"))))],
                name: .identifier(name),
                genericParameterClause: GenericParameterClauseSyntax {
                    GenericParameterSyntax(
                        name: .identifier("Root"),
                        colon: .colonToken(),
                        inheritedType: IdentifierTypeSyntax(name: .identifier("RootRegistry"))
                    )
                }
            ) {
                tagNameDecl
                lookupDecl
            }
        }
        
        try SourceFileSyntax {
            ImportDeclSyntax(path: [ImportPathComponentSyntax(name: .identifier("SwiftUI"))])
            ImportDeclSyntax(path: [ImportPathComponentSyntax(name: .identifier("LiveViewNative"))])
            
            addonDecl
        }
        .formatted()
        .description
        .write(to: URL(string: outputFile)!, atomically: true, encoding: .utf8)
    }
}

final class LiveElementVisitor: SyntaxVisitor {
    var liveElements = Set<String>()
    
    override func visit(_ decl: StructDeclSyntax) -> SyntaxVisitorContinueKind {
        guard decl.attributes.contains(where: {
            guard case let .attribute(attribute) = $0
            else { return false }
            return attribute.attributeName.isLiveElementMacro
        })
        else { return .visitChildren }
        
        liveElements.insert(decl.name.text)
        
        return .visitChildren
    }
}

extension TypeSyntax {
    var isLiveElementMacro: Bool {
        if let identifierType = self.as(IdentifierTypeSyntax.self) {
            return identifierType.name.text == "LiveElement"
        } else if let memberType = self.as(MemberTypeSyntax.self) {
            return memberType.baseType.as(IdentifierTypeSyntax.self)?.name.text == ""
                && memberType.name.text == "LiveElement"
        } else {
            return false
        }
    }
}
