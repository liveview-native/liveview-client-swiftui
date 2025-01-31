//
//  makeBuiltinModifier.swift
//  LiveViewNative
//
//  Created by Carson.Katri on 1/30/25.
//

import SwiftSyntax
import SwiftSyntaxBuilder

extension ModifierGenerator {
    /// Create the `BuiltinRegistry.BuiltinModifier` definition.
    func makeBuiltinModifier(
        _ modifiers: [String]
    ) -> ExtensionDeclSyntax {
        // extension BuiltinRegistry
        ExtensionDeclSyntax(extendedType: IdentifierTypeSyntax(name: .identifier("BuiltinRegistry"))) {
            // enum BuiltinModifier: ViewModifier, Decodable
            EnumDeclSyntax(
                name: .identifier("BuiltinModifier"),
                inheritanceClause: InheritanceClauseSyntax {
                    InheritedTypeSyntax(type: IdentifierTypeSyntax(name: .identifier("ViewModifier")))
                    InheritedTypeSyntax(type: IdentifierTypeSyntax(name: .identifier("Decodable")))
                }
            ) {
                // case _customRegistry(R.CustomModifier)
                EnumCaseDeclSyntax(elements: [
                    EnumCaseElementSyntax(
                        name: .identifier("_customRegistry"),
                        parameterClause: EnumCaseParameterClauseSyntax(parameters: [
                            EnumCaseParameterSyntax(
                                type: MemberTypeSyntax(
                                    baseType: IdentifierTypeSyntax(name: .identifier("R")),
                                    name: .identifier("CustomModifier")
                                )
                            )
                        ])
                    )
                ])
                
                for modifier in modifiers {
                    // case modifierName(_ViewModifier__modifierName)
                    EnumCaseDeclSyntax(elements: [
                        EnumCaseElementSyntax(
                            name: .identifier(modifier),
                            parameterClause: EnumCaseParameterClauseSyntax(parameters: [
                                EnumCaseParameterSyntax(
                                    type: IdentifierTypeSyntax(name: .identifier("_ViewModifier__\(modifier)"))
                                )
                            ])
                        )
                    ])
                }
                
                // init(from decoder: any Decoder) throws
                InitializerDeclSyntax(
                    signature: FunctionSignatureSyntax(
                        parameterClause: FunctionParameterClauseSyntax(parameters: [
                            FunctionParameterSyntax(
                                firstName: .identifier("from"),
                                secondName: .identifier("decoder"),
                                type: SomeOrAnyTypeSyntax(someOrAnySpecifier: .keyword(.any), constraint: IdentifierTypeSyntax(name: .identifier("Decoder")))
                            )
                        ]),
                        effectSpecifiers: FunctionEffectSpecifiersSyntax(
                            throwsClause: ThrowsClauseSyntax(throwsSpecifier: .keyword(.throws))
                        )
                    )
                ) {
                    
                }
            }
        }
    }
}
