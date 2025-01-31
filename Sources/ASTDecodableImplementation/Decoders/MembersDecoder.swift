//
//  MembersDecoder.swift
//  JSONStylesheet
//
//  Created by Carson Katri on 11/13/24.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftDiagnostics
import SwiftSyntaxMacros

struct MembersDecoder<TypeSyntaxType: TypeSyntaxProtocol> {
    let name: TokenSyntax
    let type: TypeSyntaxType
    let identifierEnumReference: DeclReferenceExprSyntax
    let members: [PatternBindingSyntax]
    
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
                
                // members use `.` (a member access operator) for the identifier
                // and use an instance of the type as the first argument
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
                    for member in members {
                        if let name = member
                            .pattern
                            .as(IdentifierPatternSyntax.self)?
                            .identifier
                        {
                            SwitchCaseSyntax(label: .case(SwitchCaseLabelSyntax {
                                SwitchCaseItemSyntax(
                                    pattern: ExpressionPatternSyntax(expression: StringLiteralExprSyntax(
                                        openingQuote: .stringQuoteToken(),
                                        segments: [
                                            .stringSegment(StringSegmentSyntax(content: .stringSegment(name.trimmed.text)))
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
                                    rightOperand: MemberAccessExprSyntax(base: baseInstanceReference, name: name)
                                )
                                ReturnStmtSyntax()
                            }
                        }
                    }
                    SwitchCaseSyntax(label: .default(SwitchDefaultLabelSyntax())) {
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
    }
}
