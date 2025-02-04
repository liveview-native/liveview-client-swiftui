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
                    // @preconcurrency Swift.Decodable
                    InheritedTypeSyntax(
                        type: AttributedTypeSyntax(
                            specifiers: TypeSpecifierListSyntax([]),
                            attributes: AttributeListSyntax([.attribute(AttributeSyntax(attributeName: IdentifierTypeSyntax(name: .identifier("preconcurrency"))))]),
                            baseType: MemberTypeSyntax(baseType: IdentifierTypeSyntax(name: .identifier("Swift")), name: .identifier("Decodable"))
                        )
                    )
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
                // case _error(ErrorModifier)
                EnumCaseDeclSyntax(elements: [
                    EnumCaseElementSyntax(
                        name: .identifier("_error"),
                        parameterClause: EnumCaseParameterClauseSyntax(parameters: [
                            EnumCaseParameterSyntax(
                                type: IdentifierTypeSyntax(name: .identifier("ErrorModifier"))
                            )
                        ])
                    )
                ])
                
                for modifier in modifiers {
                    // case modifierName(_ViewModifier__modifierName<R>)
                    EnumCaseDeclSyntax(elements: [
                        EnumCaseElementSyntax(
                            name: .identifier(modifier),
                            parameterClause: EnumCaseParameterClauseSyntax(parameters: [
                                EnumCaseParameterSyntax(
                                    type: IdentifierTypeSyntax(
                                        name: .identifier("_ViewModifier__\(modifier)"),
                                        genericArgumentClause: GenericArgumentClauseSyntax {
                                            GenericArgumentSyntax(argument: IdentifierTypeSyntax(name: .identifier("R")))
                                        }
                                    )
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
//                    var container = try decoder.singleValueContainer()
//                    
//                    do {
//                        try container.decode(ModifierTypeName.self)
//                        throw BuiltinRegistryModifierError.unknownModifier
//                    } catch let modifierTypeName as ModifierTypeName {
//                        switch modifierTypeName.name {
//                        case "padding":
//                            self = .padding(try container.decode(_ViewModifier__padding<R>.self))
//                        case "background":
//                            self = .background(try container.decode(_ViewModifier__background<R>.self))
//                        default:
//                            let node = try container.decode(ASTNode.self)
//                            print(node)
//                            self = .__error(ErrorModifier(type: node.identifier, error: BuiltinRegistryModifierError.unknownModifier))
//                        }
//                    } catch {
//                        throw error
//                    }
                    
                    // single value container
                    VariableDeclSyntax(
                        .var,
                        name: PatternSyntax(IdentifierPatternSyntax(identifier: .identifier("container"))),
                        initializer: InitializerClauseSyntax(value: TryExprSyntax(expression: FunctionCallExprSyntax(
                            callee: MemberAccessExprSyntax(
                                base: DeclReferenceExprSyntax(baseName: .identifier("decoder")),
                                period: .periodToken(),
                                name: .identifier("singleValueContainer")
                            )
                        )))
                    )
                    
                    DoStmtSyntax(
                        catchClauses: CatchClauseListSyntax {
                            // catch let modifierTypeName as ModifierTypeName
                            CatchClauseSyntax(CatchItemListSyntax {
                                CatchItemSyntax(pattern: ValueBindingPatternSyntax(
                                    bindingSpecifier: .keyword(.let),
                                    pattern: ExpressionPatternSyntax(expression: AsExprSyntax(
                                        expression: PatternExprSyntax(pattern: IdentifierPatternSyntax(identifier: .identifier("modifierTypeName"))),
                                        type: IdentifierTypeSyntax(name: .identifier("ModifierTypeName"))
                                    ))
                                ))
                            }) {
                                DoStmtSyntax(
                                    catchClauses: CatchClauseListSyntax {
                                        CatchClauseSyntax {
                                            // if the specific modifier fails to decode create an ErrorModifier instead.
                                            InfixOperatorExprSyntax(
                                                leftOperand: DeclReferenceExprSyntax(baseName: .identifier("self")),
                                                operator: AssignmentExprSyntax(),
                                                rightOperand: FunctionCallExprSyntax(
                                                    callee: MemberAccessExprSyntax(name: .identifier("_error"))
                                                ) {
                                                    LabeledExprSyntax(expression: FunctionCallExprSyntax(
                                                        callee: DeclReferenceExprSyntax(baseName: .identifier("ErrorModifier"))
                                                    ) {
                                                        LabeledExprSyntax(expression: TryExprSyntax(expression: FunctionCallExprSyntax(
                                                            callee: MemberAccessExprSyntax(
                                                                base: DeclReferenceExprSyntax(baseName: .identifier("container")),
                                                                period: .periodToken(),
                                                                name: .identifier("decode")
                                                            )
                                                        ) {
                                                            LabeledExprSyntax(expression: MemberAccessExprSyntax(
                                                                base: DeclReferenceExprSyntax(baseName: .identifier("ASTNode")),
                                                                period: .periodToken(),
                                                                name: .identifier("self")
                                                            ))
                                                        }))
                                                    })
                                                }
                                            )
                                        }
                                    }
                                ) {
                                    // switch over the modifier name and decode the correct type
                                    SwitchExprSyntax(subject: MemberAccessExprSyntax(
                                        base: DeclReferenceExprSyntax(baseName: .identifier("modifierTypeName")),
                                        period: .periodToken(),
                                        name: .identifier("name")
                                    )) {
                                        for modifier in modifiers {
                                            SwitchCaseSyntax(
                                                label: .case(SwitchCaseLabelSyntax(caseItems: [
                                                    SwitchCaseItemSyntax(
                                                        pattern: ExpressionPatternSyntax(
                                                            expression: StringLiteralExprSyntax(content: modifier)
                                                        )
                                                    )
                                                ]))
                                            ) {
                                                // decode this modifier type to self
                                                InfixOperatorExprSyntax(
                                                    leftOperand: DeclReferenceExprSyntax(baseName: .identifier("self")),
                                                    operator: AssignmentExprSyntax(),
                                                    rightOperand: FunctionCallExprSyntax(
                                                        callee: MemberAccessExprSyntax(name: .identifier(modifier))
                                                    ) {
                                                        LabeledExprSyntax(expression: TryExprSyntax(expression: FunctionCallExprSyntax(
                                                            callee: MemberAccessExprSyntax(
                                                                base: DeclReferenceExprSyntax(baseName: .identifier("container")),
                                                                period: .periodToken(),
                                                                name: .identifier("decode")
                                                            )
                                                        ) {
                                                            LabeledExprSyntax(expression: MemberAccessExprSyntax(
                                                                base: GenericSpecializationExprSyntax(
                                                                    expression: DeclReferenceExprSyntax(baseName: .identifier("_ViewModifier__\(modifier)")),
                                                                    genericArgumentClause: GenericArgumentClauseSyntax {
                                                                        GenericArgumentSyntax(argument: IdentifierTypeSyntax(name: .identifier("R")))
                                                                    }
                                                                ),
                                                                period: .periodToken(),
                                                                name: .identifier("self")
                                                            ))
                                                        }))
                                                    }
                                                )
                                            }
                                        }
                                        
                                        SwitchCaseSyntax(label: .default(SwitchDefaultLabelSyntax())) {
                                            InfixOperatorExprSyntax(
                                                leftOperand: DeclReferenceExprSyntax(baseName: .identifier("self")),
                                                operator: AssignmentExprSyntax(),
                                                rightOperand: FunctionCallExprSyntax(
                                                    callee: MemberAccessExprSyntax(name: .identifier("_error"))
                                                ) {
                                                    LabeledExprSyntax(expression: FunctionCallExprSyntax(
                                                        callee: DeclReferenceExprSyntax(baseName: .identifier("ErrorModifier"))
                                                    ) {
                                                        LabeledExprSyntax(expression: TryExprSyntax(expression: FunctionCallExprSyntax(
                                                            callee: MemberAccessExprSyntax(
                                                                base: DeclReferenceExprSyntax(baseName: .identifier("container")),
                                                                period: .periodToken(),
                                                                name: .identifier("decode")
                                                            )
                                                        ) {
                                                            LabeledExprSyntax(expression: MemberAccessExprSyntax(
                                                                base: DeclReferenceExprSyntax(baseName: .identifier("ASTNode")),
                                                                period: .periodToken(),
                                                                name: .identifier("self")
                                                            ))
                                                        }))
                                                    })
                                                }
                                            )
                                        }
                                    }
                                }
                            }
                            
                            // if some other error is thrown, throw it up to the parent
                            CatchClauseSyntax {
                                ThrowStmtSyntax(expression: DeclReferenceExprSyntax(baseName: .identifier("error")))
                            }
                        }
                    ) {
                        // decode the ModifierTypeName
                        // it is supposed to throw itself as the error
                        TryExprSyntax(
                            expression: FunctionCallExprSyntax(
                                callee: MemberAccessExprSyntax(
                                    base: DeclReferenceExprSyntax(baseName: .identifier("container")),
                                    period: .periodToken(),
                                    name: .identifier("decode")
                                )
                            ) {
                                LabeledExprSyntax(expression: MemberAccessExprSyntax(
                                    base: DeclReferenceExprSyntax(baseName: .identifier("ModifierTypeName")),
                                    period: .periodToken(),
                                    name: .identifier("self")
                                ))
                            }
                        )
                        ThrowStmtSyntax(expression: MemberAccessExprSyntax(
                            base: DeclReferenceExprSyntax(baseName: .identifier("BuiltinRegistryModifierError")),
                            period: .periodToken(),
                            name: .identifier("unknownModifier")
                        ))
                    }
                }
                
                // func body(content:) -> some View
                FunctionDeclSyntax(
                    attributes: AttributeListSyntax([.attribute(AttributeSyntax(attributeName: IdentifierTypeSyntax(name: .identifier("ViewBuilder"))))]),
                    name: .identifier("body"),
                    signature: FunctionSignatureSyntax(
                        parameterClause: FunctionParameterClauseSyntax(parameters: FunctionParameterListSyntax {
                            FunctionParameterSyntax(firstName: .identifier("content"), type: IdentifierTypeSyntax(name: .identifier("Content")))
                        }),
                        returnClause: ReturnClauseSyntax(type: SomeOrAnyTypeSyntax(someOrAnySpecifier: .keyword(.some), constraint: IdentifierTypeSyntax(name: .identifier("View"))))
                    )
                ) {
                    // apply the modifier
                    SwitchExprSyntax(subject: DeclReferenceExprSyntax(baseName: .identifier("self"))) {
                        // case let ._customRegistry(modifier)
                        SwitchCaseSyntax(label: .case(SwitchCaseLabelSyntax {
                            CaseItemSyntax(pattern: ValueBindingPatternSyntax(
                                bindingSpecifier: .keyword(.let),
                                pattern: ExpressionPatternSyntax(expression: FunctionCallExprSyntax(
                                    callee: MemberAccessExprSyntax(name: .identifier("_customRegistry"))
                                ) {
                                    LabeledExprSyntax(expression: PatternExprSyntax(pattern: IdentifierPatternSyntax(identifier: .identifier("modifier"))))
                                })
                            ))
                        })) {
                            FunctionCallExprSyntax(callee: MemberAccessExprSyntax(
                                base: DeclReferenceExprSyntax(baseName: .identifier("content")),
                                period: .periodToken(),
                                name: .identifier("modifier")
                            )) {
                                LabeledExprSyntax(expression: DeclReferenceExprSyntax(baseName: .identifier("modifier")))
                            }
                        }
                        
                        // case let ._error(modifier)
                        SwitchCaseSyntax(label: .case(SwitchCaseLabelSyntax {
                            CaseItemSyntax(pattern: ValueBindingPatternSyntax(
                                bindingSpecifier: .keyword(.let),
                                pattern: ExpressionPatternSyntax(expression: FunctionCallExprSyntax(
                                    callee: MemberAccessExprSyntax(name: .identifier("_error"))
                                ) {
                                    LabeledExprSyntax(expression: PatternExprSyntax(pattern: IdentifierPatternSyntax(identifier: .identifier("modifier"))))
                                })
                            ))
                        })) {
                            FunctionCallExprSyntax(callee: MemberAccessExprSyntax(
                                base: DeclReferenceExprSyntax(baseName: .identifier("content")),
                                period: .periodToken(),
                                name: .identifier("modifier")
                            )) {
                                LabeledExprSyntax(expression: DeclReferenceExprSyntax(baseName: .identifier("modifier")))
                            }
                        }
                        
                        for modifier in modifiers {
                            // case let .modifierName(modifier)
                            SwitchCaseSyntax(label: .case(SwitchCaseLabelSyntax {
                                CaseItemSyntax(pattern: ValueBindingPatternSyntax(
                                    bindingSpecifier: .keyword(.let),
                                    pattern: ExpressionPatternSyntax(expression: FunctionCallExprSyntax(
                                        callee: MemberAccessExprSyntax(name: .identifier(modifier))
                                    ) {
                                        LabeledExprSyntax(expression: PatternExprSyntax(pattern: IdentifierPatternSyntax(identifier: .identifier("modifier"))))
                                    })
                                ))
                            })) {
                                FunctionCallExprSyntax(callee: MemberAccessExprSyntax(
                                    base: DeclReferenceExprSyntax(baseName: .identifier("content")),
                                    period: .periodToken(),
                                    name: .identifier("modifier")
                                )) {
                                    LabeledExprSyntax(expression: DeclReferenceExprSyntax(baseName: .identifier("modifier")))
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
