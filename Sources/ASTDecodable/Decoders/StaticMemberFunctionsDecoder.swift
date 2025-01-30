//
//  StaticMemberFunctionsDecoder.swift
//  JSONStylesheet
//
//  Created by Carson.Katri on 10/1/24.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftDiagnostics
import SwiftSyntaxMacros

struct StaticMemberFunctionsDecoder<TypeSyntaxType: TypeSyntaxProtocol> {
    let name: TokenSyntax
    let type: TypeSyntaxType
    let identifierEnumReference: DeclReferenceExprSyntax
    let clauses: [StaticMemberFunctionClause]
    
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
            
            // clauses
            for clause in clauses {
                clause.attributes.makeOSCheck {
                    clause.argumentsDecl
                }
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
                
                // static members use `.` (a member access operator) for the identifier
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
                
                // type name or `nil`
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
                
                // arguments
                for clause in clauses {
                    clause.attributes.makeOSCheck {
                        clauses.first!.attributes.makeRuntimeOSCheck {
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
                                // set `value` to the decoded arguments `value`
                                InfixOperatorExprSyntax(
                                    leftOperand: MemberAccessExprSyntax(
                                        base: DeclReferenceExprSyntax(baseName: .identifier("self")),
                                        name: .identifier("value")
                                    ),
                                    operator: AssignmentExprSyntax(),
                                    rightOperand: TryExprSyntax(
                                        expression: MemberAccessExprSyntax(
                                            base: FunctionCallExprSyntax(
                                                callee: MemberAccessExprSyntax(
                                                    base: argumentsContainerReference,
                                                    name: .identifier("decode")
                                                )
                                            ) {
                                                LabeledExprSyntax(
                                                    expression: MemberAccessExprSyntax(
                                                        base: DeclReferenceExprSyntax(baseName: clause.argumentsDecl.name),
                                                        name: .identifier("self")
                                                    )
                                                )
                                            },
                                            name: .identifier("value")
                                        )
                                    )
                                )
                                ReturnStmtSyntax()
                            }
                        } elseBody: {
                            
                        }
                    }
                }
                
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

/// A single `static func` clause for a decodable type.
struct StaticMemberFunctionClause {
    let signature: FunctionSignatureSyntax
    let argumentsDecl: StructDeclSyntax
    let attributes: AttributeListSyntax
    
    init(
        _ name: TokenSyntax,
        for function: FunctionDeclSyntax,
        type: some TypeSyntaxProtocol,
        in context: MacroExpansionContext
    ) throws {
        self.signature = function.signature
        self.attributes = function.attributes
        
        // Store the `identifier` argument in a Decodable enum.
        let identifierEnumName = context.makeUniqueName("Identifier")
        let identifierEnumReference = DeclReferenceExprSyntax(baseName: identifierEnumName)
        /// An enum used to check the identifier matches when decoding.
        let identifierEnum = EnumDeclSyntax(
            name: identifierEnumName,
            inheritanceClause: InheritanceClauseSyntax {
                InheritedTypeSyntax(type: TypeSyntax("Swift.String"))
                InheritedTypeSyntax(type: TypeSyntax("Swift.Decodable"))
            }
        ) {
            MemberBlockItemSyntax(decl: EnumCaseDeclSyntax {
                EnumCaseElementSyntax(
                    name: .identifier("name"),
                    rawValue: InitializerClauseSyntax(
                        value: StringLiteralExprSyntax(content: function.name.text)
                    )
                )
            })
        }
        
        let decoderName = context.makeUniqueName("decoder")
        let decoderReference = DeclReferenceExprSyntax(baseName: decoderName)
        
        let containerName = context.makeUniqueName("container")
        let containerReference = DeclReferenceExprSyntax(baseName: containerName)
        
        let annotationsName = context.makeUniqueName("annotations")
        let annotationsReference = DeclReferenceExprSyntax(baseName: annotationsName)
        
        let argumentsContainerName = context.makeUniqueName("argumentsContainer")
        let argumentsContainerReference = DeclReferenceExprSyntax(baseName: argumentsContainerName)
        
        let labeledArgumentsContainerName = context.makeUniqueName("labeledArgumentsContainer")
        let labeledArgumentsContainerReference = DeclReferenceExprSyntax(baseName: labeledArgumentsContainerName)
        
        let codingKeysName = context.makeUniqueName("CodingKeys")
        let codingKeysReference = DeclReferenceExprSyntax(baseName: codingKeysName)
        
        let unlabeledArguments = signature.parameterClause.parameters
            .filter { $0.firstName.tokenKind == .wildcard }
        let labeledArguments = signature.parameterClause.parameters
            .filter { $0.firstName.tokenKind != .wildcard }
        
        self.argumentsDecl = StructDeclSyntax(
            attributes: function.attributes.filter(\.isAvailability),
            name: name,
            inheritanceClause: InheritanceClauseSyntax {
                InheritedTypeSyntax(type: TypeSyntax("Swift.Decodable"))
            }
        ) {
            identifierEnum
            
            // CodingKeys
            if !labeledArguments.isEmpty {
                EnumDeclSyntax(
                    name: codingKeysName,
                    inheritanceClause: InheritanceClauseSyntax {
                        InheritedTypeSyntax(type: TypeSyntax("Swift.String"))
                        InheritedTypeSyntax(type: TypeSyntax("Swift.CodingKey"))
                    }
                ) {
                    for argument in labeledArguments {
                        MemberBlockItemSyntax(decl: EnumCaseDeclSyntax {
                            EnumCaseElementSyntax(
                                name: argument.secondName ?? argument.firstName,
                                rawValue: InitializerClauseSyntax.init(value: StringLiteralExprSyntax(content: argument.firstName.text))
                            )
                        })
                    }
                }
            }
            
            // value
            VariableDeclSyntax(bindingSpecifier: .keyword(.let)) {
                PatternBindingSyntax(
                    pattern: IdentifierPatternSyntax(identifier: .identifier("value")),
                    typeAnnotation: TypeAnnotationSyntax(type: type)
                )
            }
            
            // decoder
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
                
                // identifier
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
                                    base: identifierEnumReference,
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
                
                for parameter in function.signature.parameterClause.parameters {
                    if parameter.firstName.tokenKind == .wildcard {
                        VariableDeclSyntax(
                            bindingSpecifier: .keyword(.let)
                        ) {
                            let decodeExpr: ExprSyntax = if let defaultValue = parameter.defaultValue?.value {
                                ExprSyntax(
                                    InfixOperatorExprSyntax(
                                        leftOperand: FunctionCallExprSyntax(
                                            callee: MemberAccessExprSyntax(
                                                base: argumentsContainerReference,
                                                name: .identifier("decodeIfPresent")
                                            )
                                        ) {
                                            LabeledExprSyntax(
                                                expression: MemberAccessExprSyntax(
                                                    base: TypeExprSyntax(type: parameter.type),
                                                    name: .identifier("self")
                                                )
                                            )
                                        },
                                        operator: BinaryOperatorExprSyntax(operator: .binaryOperator("??")),
                                        rightOperand: defaultValue
                                    )
                                )
                            } else {
                                ExprSyntax(
                                    FunctionCallExprSyntax(
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
                                )
                            }
                            PatternBindingSyntax(
                                pattern: IdentifierPatternSyntax(identifier: parameter.secondName ?? parameter.firstName),
                                initializer: InitializerClauseSyntax(
                                    value: TryExprSyntax(
                                        expression: decodeExpr
                                    )
                                )
                            )
                        }
                    } else {
                        // nested container for labeled arguments
                        let nestedContainer = FunctionCallExprSyntax(
                            callee: MemberAccessExprSyntax(
                                base: containerReference,
                                name: .identifier("nestedContainer")
                            )
                        ) {
                            LabeledExprSyntax(
                                label: .identifier("keyedBy"),
                                colon: .colonToken(),
                                expression: MemberAccessExprSyntax(
                                    base: codingKeysReference,
                                    name: .identifier("self")
                                )
                            )
                        }
                        VariableDeclSyntax(
                            bindingSpecifier: .keyword(.let)
                        ) {
                            let decodeExpr: ExprSyntax = if let defaultValue = parameter.defaultValue?.value {
                                ExprSyntax(
                                    InfixOperatorExprSyntax(
                                        leftOperand: TupleExprSyntax {
                                            LabeledExprSyntax(
                                                expression: TryExprSyntax(
                                                    questionOrExclamationMark: .postfixQuestionMarkToken(),
                                                    expression: FunctionCallExprSyntax(
                                                        callee: MemberAccessExprSyntax(
                                                            base: nestedContainer,
                                                            name: .identifier("decodeIfPresent")
                                                        )
                                                    ) {
                                                        LabeledExprSyntax(
                                                            expression: MemberAccessExprSyntax(
                                                                base: TypeExprSyntax(type: parameter.type),
                                                                name: .identifier("self")
                                                            )
                                                        )
                                                        LabeledExprSyntax(
                                                            label: "forKey",
                                                            expression: MemberAccessExprSyntax(
                                                                name: parameter.secondName ?? parameter.firstName
                                                            )
                                                        )
                                                    }
                                                )
                                            )
                                        },
                                        operator: BinaryOperatorExprSyntax(operator: .binaryOperator("??")),
                                        rightOperand: defaultValue
                                    )
                                )
                            } else {
                                ExprSyntax(
                                    TryExprSyntax(
                                        expression: FunctionCallExprSyntax(
                                            callee: MemberAccessExprSyntax(
                                                base: nestedContainer,
                                                name: .identifier("decode")
                                            )
                                        ) {
                                            LabeledExprSyntax(
                                                expression: MemberAccessExprSyntax(
                                                    base: TypeExprSyntax(type: parameter.type),
                                                    name: .identifier("self")
                                                )
                                            )
                                            LabeledExprSyntax(
                                                label: "forKey",
                                                expression: MemberAccessExprSyntax(
                                                    name: parameter.secondName ?? parameter.firstName
                                                )
                                            )
                                        }
                                    )
                                )
                            }
                            PatternBindingSyntax(
                                pattern: IdentifierPatternSyntax(identifier: parameter.secondName ?? parameter.firstName),
                                initializer: InitializerClauseSyntax(
                                    value: decodeExpr
                                )
                            )
                        }
                    }
                }
                
                // set `value`
                InfixOperatorExprSyntax(
                    leftOperand: MemberAccessExprSyntax(
                        base: DeclReferenceExprSyntax(baseName: .identifier("self")),
                        name: .identifier("value")
                    ),
                    operator: AssignmentExprSyntax(),
                    rightOperand: FunctionCallExprSyntax(
                        calledExpression: MemberAccessExprSyntax(
                            name: function.name
                        ),
                        leftParen: .leftParenToken(),
                        rightParen: .rightParenToken()
                    ) {
                        for argument in unlabeledArguments {
                            LabeledExprSyntax(
                                expression: DeclReferenceExprSyntax(baseName: argument.secondName ?? argument.firstName)
                            )
                        }
                        for argument in labeledArguments {
                            LabeledExprSyntax(
                                label: argument.firstName.trimmed,
                                colon: .colonToken(),
                                expression: DeclReferenceExprSyntax(baseName: argument.secondName ?? argument.firstName)
                            )
                        }
                    }
                )
            }
        }
    }
}
