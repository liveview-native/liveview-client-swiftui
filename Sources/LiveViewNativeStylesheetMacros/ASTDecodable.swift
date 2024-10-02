//
//  ASTDecodable.swift
//  LiveViewNative
//
//  Created by Carson Katri on 9/24/24.
//

import SwiftSyntax
import SwiftSyntaxMacros

/// A macro that generates `Decodable` types for each `init` clause of a type.
///
/// For example, the following struct has 2 `init` clauses:
///
/// ```swift
/// @ASTDecodable("myModifier")
/// struct MyModifier {
///     init(_ a: String) {}
///     init(_ b: Int) {}
/// }
/// ```
///
/// This would generate a separate `Decodable` type for each `init`.
/// The `init(from:)` implementation for `MyModifier` would be synthesized to choose the first matching clause.
///
/// ```swift
/// extension MyModifier: Swift.Decodable {
///     enum Identifier: Swift.String, Swift.Decodable {
///         case name = "myModifier"
///     }
///     init(from decoder: any Swift.Decoder) throws {
///         var container = try decoder.unkeyedContainer()
///         _ = try container.decode(Identifier.self)
///         let annotations = try container.decode(JSONStylesheet.Annotations.self)
///         var errors: [any Swift.Error] = []
///         do {
///             self = try container.decode(Clause0.self).value
///             return
///         } catch let error {
///             errors.append(error)
///         }
///         do {
///             self = try container.decode(Clause1.self).value
///             return
///         } catch let error {
///             errors.append(error)
///         }
///         throw LiveViewNativeStylesheet.MultipleFailures(errors, annotations: annotations)
///     }
///     struct Clause0: Swift.Decodable {
///         let value: MyModifier
///         init(from decoder: any Swift.Decoder) throws {
///             var container = try decoder.unkeyedContainer()
///             let a = try container.decode(String.self)
///             self.value = MyModifier(a)
///         }
///     }
///     struct Clause1: Swift.Decodable {
///         let value: MyModifier
///         init(from decoder: any Swift.Decoder) throws {
///             var container = try decoder.unkeyedContainer()
///             let b = try container.decode(Int.self)
///             self.value = MyModifier(b)
///         }
///     }
/// }
/// ```
struct ASTDecodable: ExtensionMacro {
    static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        guard case let .argumentList(arguments) = node.arguments,
              let identifierExpr = arguments.first?
                .expression
                .as(StringLiteralExprSyntax.self)
        else { throw ASTDecodableError.invalidIdentifier }
        
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
                EnumCaseElementSyntax(name: .identifier("name"), rawValue: InitializerClauseSyntax(value: identifierExpr))
            })
        }
        
        /// Decoders for each clause of arguments.
        let clauses = try declaration.memberBlock.members
            .compactMap({ $0.decl.as(InitializerDeclSyntax.self) })
            .enumerated()
            .map({ (offset, initializer: InitializerDeclSyntax) in
                let clauseName = context.makeUniqueName("Clause\(offset)")
                return try Clause(
                    clauseName,
                    for: initializer,
                    type: type,
                    in: context
                )
            })
            .sorted(by: { $0.initializer.signature.parameterClause.parameters.count > $1.initializer.signature.parameterClause.parameters.count })
        
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
        
        /// The `init(decoder:)` implementation.
        let decoder = InitializerDeclSyntax(
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
            // [...]
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
            // <identifier>
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
            // <annotations>
            VariableDeclSyntax(
                bindingSpecifier: .keyword(.let)
            ) {
                PatternBindingSyntax(
                    pattern: IdentifierPatternSyntax(identifier: annotationsName),
                    initializer: InitializerClauseSyntax(
                        value: TryExprSyntax(
                            expression: FunctionCallExprSyntax(
                                callee: MemberAccessExprSyntax(
                                    base: containerReference,
                                    name: .identifier("decode")
                                )
                            ) {
                                LabeledExprSyntax(
                                    expression: MemberAccessExprSyntax(
                                        base: TypeExprSyntax(type: TypeSyntax("JSONStylesheet.Annotations")),
                                        name: .identifier("self")
                                    )
                                )
                            }
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
            
            // <arguments>
            for clause in clauses {
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
                        leftOperand: DeclReferenceExprSyntax(baseName: .identifier("self")),
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
        
        return [
            ExtensionDeclSyntax(
                extendedType: type,
                inheritanceClause: InheritanceClauseSyntax {
                    InheritedTypeSyntax(type: TypeSyntax("Swift.Decodable"))
                }
            ) {
                identifierEnum
                decoder
                for clause in clauses {
                    clause.argumentsDecl
                }
            }
        ]
    }
    
    /// A single `init` clause for a decodable type.
    struct Clause {
        let initializer: InitializerDeclSyntax
        let argumentsDecl: StructDeclSyntax
        
        init(
            _ name: TokenSyntax,
            for initializer: InitializerDeclSyntax,
            type: some TypeSyntaxProtocol,
            in context: MacroExpansionContext
        ) throws {
            self.initializer = initializer
            
            let decoderName = context.makeUniqueName("decoder")
            let decoderReference = DeclReferenceExprSyntax(baseName: decoderName)
            
            let containerName = context.makeUniqueName("container")
            let containerReference = DeclReferenceExprSyntax(baseName: containerName)
            
            let labeledArgumentsContainerName = context.makeUniqueName("labeledArgumentsContainer")
            let labeledArgumentsContainerReference = DeclReferenceExprSyntax(baseName: labeledArgumentsContainerName)
            
            let codingKeysName = context.makeUniqueName("CodingKeys")
            let codingKeysReference = DeclReferenceExprSyntax(baseName: codingKeysName)
            
            let unlabeledArguments = initializer.signature.parameterClause.parameters
                .prefix(while: { $0.firstName.tokenKind == .wildcard })
            let labeledArguments = initializer.signature.parameterClause.parameters
                .dropFirst(unlabeledArguments.count)
            
            self.argumentsDecl = StructDeclSyntax(
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
                                    rawValue: InitializerClauseSyntax.init(value: StringLiteralExprSyntax(content: argument.secondName?.text ?? argument.firstName.text))
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
                    
                    // unlabeled arguments (_ <secondName>: <Type>)
                    for parameter in unlabeledArguments {
                        VariableDeclSyntax(
                            bindingSpecifier: .keyword(.let)
                        ) {
                            PatternBindingSyntax(
                                pattern: IdentifierPatternSyntax(identifier: parameter.secondName ?? parameter.firstName),
                                initializer: InitializerClauseSyntax(
                                    value: TryExprSyntax(
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
                            )
                        }
                    }
                    
                    if !labeledArguments.isEmpty {
                        // nested container for labeledArguments
                        VariableDeclSyntax(
                            bindingSpecifier: .keyword(.let)
                        ) {
                            PatternBindingSyntax(
                                pattern: IdentifierPatternSyntax(identifier: labeledArgumentsContainerName),
                                initializer: InitializerClauseSyntax(value: TryExprSyntax(
                                    expression: FunctionCallExprSyntax(
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
                                ))
                            )
                        }
                        
                        // labeled arguments (<firstName> <secondName>: <Type>)
                        for parameter in labeledArguments {
                            VariableDeclSyntax(
                                bindingSpecifier: .keyword(.let)
                            ) {
                                PatternBindingSyntax(
                                    pattern: IdentifierPatternSyntax(identifier: parameter.secondName ?? parameter.firstName),
                                    initializer: InitializerClauseSyntax(
                                        value: TryExprSyntax(
                                            expression: FunctionCallExprSyntax(
                                                callee: MemberAccessExprSyntax(
                                                    base: labeledArgumentsContainerReference,
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
                                                    label: .identifier("forKey"),
                                                    colon: .colonToken(),
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
                            for argument in unlabeledArguments {
                                LabeledExprSyntax(
                                    expression: DeclReferenceExprSyntax(baseName: argument.secondName ?? argument.firstName)
                                )
                            }
                            for argument in labeledArguments {
                                LabeledExprSyntax(
                                    label: argument.firstName,
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
}

enum ASTDecodableError: Error {
    case invalidIdentifier
    case debug(String)
}
