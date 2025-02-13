//
//  InitializerClausesDecoder.swift
//  JSONStylesheet
//
//  Created by Carson.Katri on 10/1/24.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftDiagnostics
import SwiftSyntaxMacros

struct InitializerClausesDecoder<TypeSyntaxType: TypeSyntaxProtocol> {
    let name: TokenSyntax
    let type: TypeSyntaxType
    let identifierEnumReference: DeclReferenceExprSyntax
    let clauses: [InitializerClause]
    
    func makeSyntax(in context: MacroExpansionContext) -> StructDeclSyntax {
        // Names for decoding that won't collide with user-provided names.
        let decoderName = context.makeUniqueName("decoder")
        let decoderReference = DeclReferenceExprSyntax(baseName: decoderName)
        
        let containerName = context.makeUniqueName("container")
        let containerReference = DeclReferenceExprSyntax(baseName: containerName)
        
        let annotationsName = context.makeUniqueName("annotations")
        let annotationsReference = DeclReferenceExprSyntax(baseName: annotationsName)
        
        let errorsName = context.makeUniqueName("errors")
        let errorsReference = DeclReferenceExprSyntax(baseName: errorsName)
        
        let errorName = context.makeUniqueName("error")
        let errorReference = DeclReferenceExprSyntax(baseName: errorName)
        
        return StructDeclSyntax(
            name: name,
            inheritanceClause: InheritanceClauseSyntax(inheritedTypes: [
                // @preconcurrency Swift.Decodable
                InheritedTypeSyntax(
                    type: AttributedTypeSyntax(
                        specifiers: TypeSpecifierListSyntax([]),
                        attributes: AttributeListSyntax([.attribute(AttributeSyntax(attributeName: IdentifierTypeSyntax(name: .identifier("preconcurrency"))))]),
                        baseType: MemberTypeSyntax(baseType: IdentifierTypeSyntax(name: .identifier("Swift")), name: .identifier("Decodable"))
                    )
                )
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
                        throwsClause: ThrowsClauseSyntax(throwsSpecifier: .keyword(.throws))
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
                
                // arguments
                for clause in clauses {
                    clause.attributes.makeOSCheck {
                        clause.attributes.makeRuntimeOSCheck {
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
                                                    base: containerReference,
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
                        callee: TypeExprSyntax(type: TypeSyntax("LiveViewNativeStylesheet.MultipleFailures"))
                    ) {
                        LabeledExprSyntax(expression: errorsReference)
                        LabeledExprSyntax(label: "annotations", expression: annotationsReference)
                    }
                )
            }
        }
    }
}

/// A single `init` clause for a decodable type.
struct InitializerClause {
    let signature: FunctionSignatureSyntax
    let argumentsDecl: StructDeclSyntax
    let attributes: AttributeListSyntax
    
    init(
        _ name: TokenSyntax,
        for initializer: InitializerDeclSyntax,
        type: some TypeSyntaxProtocol,
        in context: MacroExpansionContext
    ) throws {
        self.signature = initializer.signature
        self.attributes = initializer.attributes
        
        let decoderName = context.makeUniqueName("decoder")
        let decoderReference = DeclReferenceExprSyntax(baseName: decoderName)
        
        let containerName = context.makeUniqueName("container")
        let containerReference = DeclReferenceExprSyntax(baseName: containerName)
        
        let labeledArgumentsContainerName = context.makeUniqueName("labeledArgumentsContainer")
        let labeledArgumentsContainerReference = DeclReferenceExprSyntax(baseName: labeledArgumentsContainerName)
        
        let codingKeysName = context.makeUniqueName("CodingKeys")
        let codingKeysReference = DeclReferenceExprSyntax(baseName: codingKeysName)
        
        let errorName = context.makeUniqueName("error")
        let errorReference = DeclReferenceExprSyntax(baseName: errorName)
        
        let labeledArguments = initializer.signature.parameterClause.parameters
            .filter({ $0.firstName.tokenKind != .wildcard })
        
        let argumentTypeNames = initializer.signature.parameterClause.parameters
            .map { context.makeUniqueName($0.secondName?.text ?? $0.firstName.text) }
        
        self.argumentsDecl = StructDeclSyntax(
            attributes: initializer.attributes.filter(\.isAvailability) + [.attribute(AttributeSyntax(attributeName: IdentifierTypeSyntax(name: .identifier("MainActor"))))],
            name: name,
            inheritanceClause: InheritanceClauseSyntax {
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
            
            // create an enum for coding keys for each labeled argument with a default value
            // this type is used with the `LabeledArgument` type to decode optional labeled arguments
            for (index, parameter) in initializer.signature.parameterClause.parameters.enumerated()
                where parameter.firstName.tokenKind != .wildcard
                    && parameter.defaultValue != nil
            {
                let parameterTypeName = argumentTypeNames[index]
                EnumDeclSyntax(
                    name: parameterTypeName,
                    inheritanceClause: InheritanceClauseSyntax {
                        InheritedTypeSyntax(type: IdentifierTypeSyntax(name: .identifier("String")))
                        InheritedTypeSyntax(type: IdentifierTypeSyntax(name: .identifier("CodingKey")))
                        InheritedTypeSyntax(type: IdentifierTypeSyntax(name: .identifier("CaseIterable")))
                    }
                ) {
                    EnumCaseDeclSyntax {
                        EnumCaseElementSyntax(name: parameter.secondName ?? parameter.firstName)
                    }
                }
            }
            
            // decoder
            InitializerDeclSyntax(
                attributes: AttributeListSyntax([.attribute(AttributeSyntax(attributeName: IdentifierTypeSyntax(name: .identifier("MainActor"))))]),
                signature: FunctionSignatureSyntax(
                    parameterClause: FunctionParameterClauseSyntax {
                        FunctionParameterSyntax(
                            firstName: .identifier("from"),
                            secondName: decoderName,
                            type: TypeSyntax("any Swift.Decoder")
                        )
                    },
                    effectSpecifiers: FunctionEffectSpecifiersSyntax(
                        throwsClause: ThrowsClauseSyntax(throwsSpecifier: .keyword(.throws))
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
                
                for (index, parameter) in initializer.signature.parameterClause.parameters.enumerated() {
                    if parameter.firstName.tokenKind == .wildcard {
                        VariableDeclSyntax(
                            bindingSpecifier: .keyword(.let)
                        ) {
                            let decodeExpr: ExprSyntax = if let defaultValue = parameter.defaultValue?.value {
                                ExprSyntax(
                                    InfixOperatorExprSyntax(
                                        leftOperand: TupleExprSyntax {
                                            LabeledExprSyntax(expression: TryExprSyntax(questionOrExclamationMark: .postfixQuestionMarkToken(), expression: FunctionCallExprSyntax(
                                                callee: MemberAccessExprSyntax(
                                                    base: containerReference,
                                                    name: .identifier("decodeIfPresent")
                                                )
                                            ) {
                                                LabeledExprSyntax(
                                                    expression: MemberAccessExprSyntax(
                                                        base: TypeExprSyntax(type: parameter.type),
                                                        name: .identifier("self")
                                                    )
                                                )
                                            }))
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
                                                base: containerReference,
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
                                )
                            }
                            PatternBindingSyntax(
                                pattern: IdentifierPatternSyntax(identifier: parameter.secondName ?? parameter.firstName),
                                initializer: InitializerClauseSyntax(
                                    value: decodeExpr
                                )
                            )
                        }
                    } else {
                        if let defaultValue = parameter.defaultValue?.value {
                            // use the `LabeledArgument` type to decode labeled arguments with default values
                            // reference the enum for the coding key
                            let parameterTypeName = argumentTypeNames[index]
                            // decode the type if present
                            VariableDeclSyntax(
                                bindingSpecifier: .keyword(.let)
                            ) {
                                PatternBindingSyntax(
                                    pattern: IdentifierPatternSyntax(identifier: parameter.secondName ?? parameter.firstName),
                                    initializer: InitializerClauseSyntax(
                                        value: InfixOperatorExprSyntax(
                                            leftOperand: TupleExprSyntax {
                                                LabeledExprSyntax(
                                                    expression: TryExprSyntax(
                                                        questionOrExclamationMark: .postfixQuestionMarkToken(),
                                                        expression: MemberAccessExprSyntax(
                                                            base: OptionalChainingExprSyntax(expression: FunctionCallExprSyntax(
                                                                callee: MemberAccessExprSyntax(
                                                                    base: containerReference,
                                                                    name: .identifier("decodeIfPresent")
                                                                )
                                                            ) {
                                                                LabeledExprSyntax(
                                                                    expression: MemberAccessExprSyntax(
                                                                        base: TypeExprSyntax(type: IdentifierTypeSyntax(
                                                                            name: .identifier("LabeledArgument"),
                                                                            genericArgumentClause: GenericArgumentClauseSyntax {
                                                                                GenericArgumentSyntax(argument: IdentifierTypeSyntax(name: parameterTypeName))
                                                                                GenericArgumentSyntax(argument: parameter.type)
                                                                            }
                                                                        )),
                                                                        name: .identifier("self")
                                                                    )
                                                                )
                                                            }),
                                                            period: .periodToken(),
                                                            name: .identifier("value")
                                                        )
                                                    )
                                                )
                                            },
                                            operator: BinaryOperatorExprSyntax(operator: .binaryOperator("??")),
                                            rightOperand: defaultValue
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
                                PatternBindingSyntax(
                                    pattern: IdentifierPatternSyntax(identifier: parameter.secondName ?? parameter.firstName),
                                    initializer: InitializerClauseSyntax(
                                        value: TryExprSyntax(
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
                                )
                            }
                        }
                    }
                }
                
                // unkeyed container should be empty if all arguments were used
                // otherwise this clause does not match
                GuardStmtSyntax(conditions: ConditionElementListSyntax {
                    ConditionElementSyntax(condition: .expression(ExprSyntax(MemberAccessExprSyntax(
                        base: containerReference,
                        period: .periodToken(),
                        name: .identifier("isAtEnd")
                    ))))
                }) {
                    ThrowStmtSyntax(expression: MemberAccessExprSyntax(
                        base: TypeExprSyntax(type: IdentifierTypeSyntax(name: .identifier("ASTDecodableError"))),
                        period: .periodToken(),
                        name: .identifier("tooManyArguments")
                    ))
                }
                
                // set `value`
                InfixOperatorExprSyntax(
                    leftOperand: MemberAccessExprSyntax(
                        base: DeclReferenceExprSyntax(baseName: .identifier("self")),
                        name: .identifier("value")
                    ),
                    operator: AssignmentExprSyntax(),
                    rightOperand: FunctionCallExprSyntax(
                        calledExpression: TypeExprSyntax(type: type),
                        leftParen: .leftParenToken(),
                        rightParen: .rightParenToken()
                    ) {
                        for argument in initializer.signature.parameterClause.parameters {
                            if argument.firstName.tokenKind == .wildcard {
                                LabeledExprSyntax(
                                    expression: DeclReferenceExprSyntax(baseName: argument.secondName ?? argument.firstName)
                                )
                            } else {
                                LabeledExprSyntax(
                                    label: argument.firstName.trimmed,
                                    colon: .colonToken(),
                                    expression: DeclReferenceExprSyntax(baseName: argument.secondName ?? argument.firstName)
                                )
                            }
                        }
                    }
                )
            }
        }
    }
}
