//
//  EnumCasesDecoder.swift
//  JSONStylesheet
//
//  Created by Carson.Katri on 10/1/24.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftDiagnostics
import SwiftSyntaxMacros

struct EnumCasesDecoder<TypeSyntaxType: TypeSyntaxProtocol> {
    let name: TokenSyntax
    let type: TypeSyntaxType
    let identifierEnumReference: DeclReferenceExprSyntax
    let cases: [EnumCaseDeclSyntax]
    
    func makeSyntax(in context: MacroExpansionContext) -> StructDeclSyntax {
        // Names for decoding that won't collide with user-provided names.
        let decoderName = context.makeUniqueName("decoder")
        let decoderReference = DeclReferenceExprSyntax(baseName: decoderName)
        
        let containerName = context.makeUniqueName("container")
        let containerReference = DeclReferenceExprSyntax(baseName: containerName)
        
        let annotationsName = context.makeUniqueName("annotations")
        let annotationsReference = DeclReferenceExprSyntax(baseName: annotationsName)
        
        let argumentsContainerName = context.makeUniqueName("argumentsContainer")
        let argumentsContainerReference = DeclReferenceExprSyntax(baseName: argumentsContainerName)
        
        let errorsName = context.makeUniqueName("errors")
        let errorsReference = DeclReferenceExprSyntax(baseName: errorsName)
        
        let errorName = context.makeUniqueName("error")
        let errorReference = DeclReferenceExprSyntax(baseName: errorName)
        
        let memberAccessIdentifier = MemberAccessExprSyntax(
            base: MemberAccessExprSyntax(
                base: DeclReferenceExprSyntax(baseName: .identifier("ASTNode")),
                name: .identifier("Identifiers")
            ),
            name: .identifier("MemberAccess")
        )
        
        return StructDeclSyntax(
            name: name,
            inheritanceClause: InheritanceClauseSyntax(inheritedTypes: [
                InheritedTypeSyntax(type: TypeSyntax("Swift.Decodable"))
            ])
        ) {
            // decoded value
            VariableDeclSyntax(bindingSpecifier: .keyword(.let)) {
                PatternBindingSyntax(
                    pattern: IdentifierPatternSyntax(identifier: .identifier("value")),
                    typeAnnotation: TypeAnnotationSyntax(type: type)
                )
            }
            
            // init from decoder
            InitializerDeclSyntax(
                signature: FunctionSignatureSyntax(
                    parameterClause: FunctionParameterClauseSyntax {
                        FunctionParameterSyntax(
                            firstName: .identifier("from"),
                            secondName: decoderName,
                            type: TypeSyntax("any Swift.Decoder")
                        )
                    },
                    effectSpecifiers: FunctionEffectSpecifiersSyntax(
                        throwsSpecifier: .keyword(.throws)
                    )
                )
            ) {
                // unkeyed container
                VariableDeclSyntax(bindingSpecifier: .keyword(.var)) {
                    PatternBindingSyntax(
                        pattern: IdentifierPatternSyntax(identifier: containerName),
                        initializer: InitializerClauseSyntax(
                            value: TryExprSyntax(
                                expression: FunctionCallExprSyntax(
                                    callee: MemberAccessExprSyntax(
                                        base: decoderReference,
                                        name: .identifier("unkeyedContainer")
                                    )
                                )
                            )
                        )
                    )
                }
                
                // enums use `.` (a member access operator) for the identifier
                // and use the type identifier or `null` as the first argument
                InfixOperatorExprSyntax(
                    leftOperand: DiscardAssignmentExprSyntax(),
                    operator: AssignmentExprSyntax(),
                    rightOperand: TryExprSyntax(
                        expression: FunctionCallExprSyntax(
                            callee: MemberAccessExprSyntax(
                                base: containerReference,
                                name: .identifier("decode")
                            )
                        ) {
                            LabeledExprSyntax(
                                expression: MemberAccessExprSyntax(
                                    base: memberAccessIdentifier,
                                    name: .identifier("self")
                                )
                            )
                        }
                    )
                )
                
                // annotations
                VariableDeclSyntax.decodeAnnotations(to: annotationsName, in: containerReference)

                // arguments container
                VariableDeclSyntax(bindingSpecifier: .keyword(.var)) {
                    PatternBindingSyntax(
                        pattern: IdentifierPatternSyntax(identifier: argumentsContainerName),
                        initializer: InitializerClauseSyntax(
                            value: TryExprSyntax(
                                expression: FunctionCallExprSyntax(
                                    callee: MemberAccessExprSyntax(
                                        base: containerReference,
                                        name: .identifier("nestedUnkeyedContainer")
                                    )
                                )
                            )
                        )
                    )
                }
                
                // store clause errors in array
                VariableDeclSyntax(
                    bindingSpecifier: .keyword(.var)
                ) {
                    PatternBindingSyntax(
                        pattern: IdentifierPatternSyntax(identifier: errorsName),
                        typeAnnotation: TypeAnnotationSyntax(
                            type: ArrayTypeSyntax(
                                element: TypeSyntax("any Swift.Error")
                            )
                        ),
                        initializer: InitializerClauseSyntax(
                            value: ArrayExprSyntax {}
                        )
                    )
                }
                
                // enum type name or `nil`
                IfExprSyntax(conditions: ConditionElementListSyntax {
                    ConditionElementSyntax(
                        condition: .expression(ExprSyntax(
                            TryExprSyntax(
                                expression: PrefixOperatorExprSyntax(
                                    operator: .prefixOperator("!"),
                                    expression: FunctionCallExprSyntax(
                                        callee: MemberAccessExprSyntax(
                                            base: argumentsContainerReference,
                                            name: .identifier("decodeNil")
                                        )
                                    )
                                )
                            )
                        ))
                    )
                }) {
                    InfixOperatorExprSyntax(
                        leftOperand: DiscardAssignmentExprSyntax(),
                        operator: AssignmentExprSyntax(),
                        rightOperand: TryExprSyntax(
                            expression: FunctionCallExprSyntax(
                                callee: MemberAccessExprSyntax(
                                    base: argumentsContainerReference,
                                    name: .identifier("decode")
                                )
                            ) {
                                LabeledExprSyntax(
                                    expression: MemberAccessExprSyntax(
                                        base: identifierEnumReference,
                                        name: .identifier("self")
                                    )
                                )
                            }
                        )
                    )
                }
                
                // parameterized cases
                for caseDecl in cases {
                    for element in caseDecl.elements {
                        if let parameters = element.parameterClause?.parameters {
                            DoStmtSyntax(
                                // store caught error in the `errors` array.
                                catchClauses: CatchClauseListSyntax {
                                    CatchClauseSyntax(CatchItemListSyntax {
                                        CatchItemSyntax(
                                            pattern: ValueBindingPatternSyntax(
                                                bindingSpecifier: .keyword(.let),
                                                pattern: IdentifierPatternSyntax(identifier: errorName)
                                            )
                                        )
                                    }) {
                                        FunctionCallExprSyntax(
                                            calledExpression: MemberAccessExprSyntax(
                                                base: errorsReference,
                                                name: .identifier("append")
                                            ),
                                            leftParen: .leftParenToken(),
                                            rightParen: .rightParenToken()
                                        ) {
                                            LabeledExprSyntax(expression: errorReference)
                                        }
                                    }
                                }
                            ) {
                                InfixOperatorExprSyntax(
                                    leftOperand: MemberAccessExprSyntax(
                                        base: DeclReferenceExprSyntax(baseName: .identifier("self")),
                                        name: .identifier("value")
                                    ),
                                    operator: AssignmentExprSyntax(),
                                    rightOperand: TryExprSyntax(
                                        expression: FunctionCallExprSyntax(
                                            callee: MemberAccessExprSyntax(name: element.name)
                                        ) {
                                            for parameter in parameters {
                                                let expression = FunctionCallExprSyntax(
                                                    callee: MemberAccessExprSyntax(
                                                        base: argumentsContainerReference,
                                                        name: .identifier("decode")
                                                    )
                                                ) {
                                                    LabeledExprSyntax(
                                                        expression: MemberAccessExprSyntax(
                                                            base: TypeExprSyntax(type: parameter.type),
                                                            name: .identifier("self")
                                                        )
                                                    )
                                                }
                                                if let name = parameter.firstName,
                                                   name.tokenKind != .wildcard
                                                {
                                                    LabeledExprSyntax(label: name.trimmed, colon: .colonToken(), expression: expression)
                                                } else {
                                                    LabeledExprSyntax(expression: expression)
                                                }
                                            }
                                        }
                                    )
                                )
                                ReturnStmtSyntax()
                            }
                        }
                    }
                }
                
                // parameter-less cases
                SwitchExprSyntax(
                    subject: TryExprSyntax(
                        expression: FunctionCallExprSyntax(
                            callee: MemberAccessExprSyntax(
                                base: argumentsContainerReference,
                                name: .identifier("decode")
                            )
                        ) {
                            LabeledExprSyntax(
                                expression: MemberAccessExprSyntax(
                                    base: TypeExprSyntax(type: TypeSyntax("Swift.String")),
                                    name: .identifier("self")
                                )
                            )
                        }
                    )
                ) {
                    for caseDecl in cases {
                        for element in caseDecl.elements where element.parameterClause == nil {
                            SwitchCaseSyntax(label: .case(SwitchCaseLabelSyntax {
                                SwitchCaseItemSyntax(
                                    pattern: ExpressionPatternSyntax(expression: StringLiteralExprSyntax(
                                        openingQuote: .stringQuoteToken(),
                                        segments: [
                                            .stringSegment(StringSegmentSyntax(content: .stringSegment(element.name.trimmed.text)))
                                        ],
                                        closingQuote: .stringQuoteToken()
                                    ))
                                )
                            })) {
                                InfixOperatorExprSyntax(
                                    leftOperand: MemberAccessExprSyntax(
                                        base: DeclReferenceExprSyntax(baseName: .identifier("self")),
                                        name: .identifier("value")
                                    ),
                                    operator: AssignmentExprSyntax(),
                                    rightOperand: MemberAccessExprSyntax(name: element.name)
                                )
                                ReturnStmtSyntax()
                            }
                        }
                    }
                    SwitchCaseSyntax(label: .default(SwitchDefaultLabelSyntax())) {
                        // throw errors
                        ThrowStmtSyntax(
                            expression: FunctionCallExprSyntax(
                                callee: TypeExprSyntax(type: TypeSyntax("JSONStylesheet.MultipleFailures"))
                            ) {
                                LabeledExprSyntax(expression: errorsReference)
                                LabeledExprSyntax(label: "annotations", expression: annotationsReference)
                            }
                        )
                    }
                }
            }
        }
    }
}
