//
//  MemberFunctionsDecoder.swift
//  JSONStylesheet
//
//  Created by Carson Katri on 11/19/24.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftDiagnostics
import SwiftSyntaxMacros

struct MemberFunctionsDecoder<TypeSyntaxType: TypeSyntaxProtocol> {
    let name: TokenSyntax
    let type: TypeSyntaxType
    let identifierEnumReference: DeclReferenceExprSyntax
    let clauses: [MemberFunctionClause]
    
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
        
        let memberFunctionContainerName = context.makeUniqueName("memberFunctionContainer")
        let memberFunctionContainerReference = DeclReferenceExprSyntax(baseName: memberFunctionContainerName)
        
        let argumentsName = context.makeUniqueName("arguments")
        let argumentsReference = DeclReferenceExprSyntax(baseName: argumentsName)
        
        let baseInstanceName = context.makeUniqueName("base")
        let baseInstanceReference = DeclReferenceExprSyntax(baseName: baseInstanceName)
        
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
                
                // type instance
                VariableDeclSyntax(bindingSpecifier: .keyword(.let)) {
                    PatternBindingSyntax(
                        pattern: IdentifierPatternSyntax(identifier: baseInstanceName),
                        initializer: InitializerClauseSyntax(
                            value: TryExprSyntax(
                                expression: FunctionCallExprSyntax(
                                    callee: MemberAccessExprSyntax(
                                        base: argumentsContainerReference,
                                        name: .identifier("decode")
                                    )
                                ) {
                                    LabeledExprSyntax(
                                        expression: MemberAccessExprSyntax(
                                            base: TypeExprSyntax(type: type),
                                            name: .identifier("self")
                                        )
                                    )
                                }
                            )
                        )
                    )
                }
                
                // member function container
                VariableDeclSyntax(bindingSpecifier: .keyword(.var)) {
                    PatternBindingSyntax(
                        pattern: IdentifierPatternSyntax(identifier: memberFunctionContainerName),
                        initializer: InitializerClauseSyntax(
                            value: TryExprSyntax(
                                expression: FunctionCallExprSyntax(
                                    callee: MemberAccessExprSyntax(
                                        base: argumentsContainerReference,
                                        name: .identifier("nestedUnkeyedContainer")
                                    )
                                )
                            )
                        )
                    )
                }
                
                // parameter-less cases
                SwitchExprSyntax(
                    subject: TryExprSyntax(
                        expression: FunctionCallExprSyntax(
                            callee: MemberAccessExprSyntax(
                                base: memberFunctionContainerReference,
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
                    for member in clauses {
                        member.attributes.makeOSCheck {
                            SwitchCaseSyntax(label: .case(SwitchCaseLabelSyntax {
                                SwitchCaseItemSyntax(
                                    pattern: ExpressionPatternSyntax(expression: StringLiteralExprSyntax(
                                        openingQuote: .stringQuoteToken(),
                                        segments: [
                                            .stringSegment(StringSegmentSyntax(content: .stringSegment(member.functionName.trimmed.text)))
                                        ],
                                        closingQuote: .stringQuoteToken()
                                    ))
                                )
                            })) {
                                member.attributes.makeRuntimeOSCheck {
                                    // annotations
                                    VariableDeclSyntax.decodeAnnotations(to: annotationsName, in: memberFunctionContainerReference)
                                    
                                    VariableDeclSyntax(
                                        Keyword.let,
                                        name: PatternSyntax(IdentifierPatternSyntax(identifier: argumentsName)),
                                        initializer: InitializerClauseSyntax(value: TryExprSyntax(
                                            expression: FunctionCallExprSyntax(
                                                callee: MemberAccessExprSyntax(
                                                    base: memberFunctionContainerReference,
                                                    name: .identifier("decode")
                                                )
                                            ) {
                                                LabeledExprSyntax(
                                                    expression: MemberAccessExprSyntax(
                                                        base: TypeExprSyntax(type: IdentifierTypeSyntax(name: member.name)),
                                                        name: .identifier("self")
                                                    )
                                                )
                                            }
                                        ))
                                    )
                                    InfixOperatorExprSyntax(
                                        leftOperand: MemberAccessExprSyntax(
                                            base: DeclReferenceExprSyntax(baseName: .identifier("self")),
                                            name: .identifier("value")
                                        ),
                                        operator: AssignmentExprSyntax(),
                                        rightOperand: FunctionCallExprSyntax(
                                            calledExpression: MemberAccessExprSyntax(
                                                base: baseInstanceReference,
                                                name: member.functionName
                                            ),
                                            leftParen: .leftParenToken(),
                                            rightParen: .rightParenToken()
                                        ) {
                                            for argument in member.signature.parameterClause.parameters {
                                                if argument.firstName.tokenKind == .wildcard {
                                                    LabeledExprSyntax(
                                                        expression: MemberAccessExprSyntax(
                                                            base: argumentsReference,
                                                            name: argument.secondName ?? argument.firstName
                                                        )
                                                    )
                                                } else {
                                                    LabeledExprSyntax(
                                                        label: argument.firstName.trimmed,
                                                        colon: .colonToken(),
                                                        expression: MemberAccessExprSyntax(
                                                            base: argumentsReference,
                                                            name: argument.secondName ?? argument.firstName
                                                        )
                                                    )
                                                }
                                            }
                                        }
                                    )
                                    ReturnStmtSyntax()
                                } elseBody: {
                                    BreakStmtSyntax()
                                }
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

/// A single `func` clause for a decodable type.
struct MemberFunctionClause {
    let name: TokenSyntax
    let functionName: TokenSyntax
    let signature: FunctionSignatureSyntax
    let argumentsDecl: StructDeclSyntax
    let attributes: AttributeListSyntax
    
    init(
        _ name: TokenSyntax,
        for function: FunctionDeclSyntax,
        type: some TypeSyntaxProtocol,
        in context: MacroExpansionContext
    ) throws {
        self.name = name
        self.functionName = function.name
        self.signature = function.signature
        self.attributes = function.attributes
        
        let decoderName = context.makeUniqueName("decoder")
        let decoderReference = DeclReferenceExprSyntax(baseName: decoderName)
        
        let containerName = context.makeUniqueName("container")
        let containerReference = DeclReferenceExprSyntax(baseName: containerName)
        
        let codingKeysName = context.makeUniqueName("CodingKeys")
        let codingKeysReference = DeclReferenceExprSyntax(baseName: codingKeysName)
        
        let labeledArguments = signature.parameterClause.parameters
            .filter { $0.firstName.tokenKind != .wildcard }
        
        self.argumentsDecl = StructDeclSyntax(
            attributes: function.attributes.filter(\.isAvailability),
            name: name,
            inheritanceClause: InheritanceClauseSyntax {
                InheritedTypeSyntax(type: TypeSyntax("Swift.Decodable"))
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
            
            for parameter in function.signature.parameterClause.parameters {
                VariableDeclSyntax(
                    Keyword.let,
                    name: PatternSyntax(IdentifierPatternSyntax(identifier: parameter.secondName ?? parameter.firstName)),
                    type: TypeAnnotationSyntax(type: parameter.type)
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
                
                for parameter in function.signature.parameterClause.parameters {
                    if parameter.firstName.tokenKind == .wildcard {
                        let decodeExpr: ExprSyntax = if let defaultValue = parameter.defaultValue?.value {
                            ExprSyntax(
                                InfixOperatorExprSyntax(
                                    leftOperand: FunctionCallExprSyntax(
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
                                    },
                                    operator: BinaryOperatorExprSyntax(operator: .binaryOperator("??")),
                                    rightOperand: defaultValue
                                )
                            )
                        } else {
                            ExprSyntax(
                                FunctionCallExprSyntax(
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
                        }
                        InfixOperatorExprSyntax(
                            leftOperand: MemberAccessExprSyntax(
                                base: DeclReferenceExprSyntax(baseName: .identifier("self")),
                                name: parameter.secondName ?? parameter.firstName
                            ),
                            operator: AssignmentExprSyntax(),
                            rightOperand: TryExprSyntax(
                                expression: decodeExpr
                            )
                        )
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
                        InfixOperatorExprSyntax(
                            leftOperand: MemberAccessExprSyntax(
                                base: DeclReferenceExprSyntax(baseName: .identifier("self")),
                                name: parameter.secondName ?? parameter.firstName
                            ),
                            operator: AssignmentExprSyntax(),
                            rightOperand: decodeExpr
                        )
                    }
                }
            }
        }
    }
}
