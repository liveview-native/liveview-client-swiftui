import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import SwiftDiagnostics
import SwiftSyntaxExtensions

package enum ASTDecodableOptions: String {
    case none
}

package struct ASTDecodable: ExtensionMacro {
    package static func expansion(
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
        else {
            context.diagnose(Diagnostic(
                node: node,
                message: SimpleDiagnosticMessage(
                    message: "Expected an `ASTDecodableStyle` and static string literal as the arguments to `@ASTDecodable`",
                    diagnosticID: MessageID(domain: "LiveViewNativeStylesheet", id: "ASTDecodable"),
                    severity: .error
                )
            ))
            return []
        }
        
        let options = arguments.dropFirst()
            .compactMap({ (argument) -> ASTDecodableOptions? in
                argument.expression
                    .as(MemberAccessExprSyntax.self)?.declName
                    .as(DeclReferenceExprSyntax.self)
                    .flatMap({ ASTDecodableOptions(rawValue: $0.baseName.text) })
            })
        
        // Store the `identifier` argument in a Decodable enum.
        let identifierEnumName = context.makeUniqueName("Identifier")
        let identifierEnumReference = DeclReferenceExprSyntax(baseName: identifierEnumName)
        /// An enum used to check the identifier matches when decoding.
        let identifierEnum = EnumDeclSyntax(
            name: identifierEnumName,
            inheritanceClause: InheritanceClauseSyntax {
                InheritedTypeSyntax(type: TypeSyntax("Swift.String"))
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
            MemberBlockItemSyntax(decl: EnumCaseDeclSyntax {
                EnumCaseElementSyntax(name: .identifier("name"), rawValue: InitializerClauseSyntax(value: identifierExpr))
            })
        }
        
        let initializerClausesName = context.makeUniqueName("InitializerClauses")
        let enumCasesName = context.makeUniqueName("EnumCases")
        let staticMemberFunctionsName = context.makeUniqueName("StaticMemberFunctions")
        let staticMembersName = context.makeUniqueName("StaticMembers")
        let membersName = context.makeUniqueName("Members")
        let memberFunctionsName = context.makeUniqueName("MemberFunctions")
        
        // Decoders for each clause of arguments.
        let ifConfigDecls = declaration.memberBlock.members
            .compactMap({ $0.decl.as(IfConfigDeclSyntax.self) })
            .flatMap({
                $0.clauses.flatMap({ clause -> MemberBlockItemListSyntax in
                    guard case .decls(let decls) = clause.as(IfConfigClauseSyntax.self)?.elements
                    else { return [] }
                    return decls
                })
            })
        
        
        /// All members of the type including those nested in an `IfConfigDecl`.
        let combinedMembers = declaration.memberBlock.members + ifConfigDecls
        
        let clauses: [InitializerClause] = try combinedMembers
            .compactMap({ $0.decl.as(InitializerDeclSyntax.self) })
            .filter({
                $0.modifiers.isAccessible
            })
            .filter({ $0.optionalMark == nil }) // fail-able initializers are not supported
            .sorted(by: { $0.signature.parameterClause.parameters.count > $1.signature.parameterClause.parameters.count })
            .enumerated()
            .map({ (offset, initializer: InitializerDeclSyntax) in
                let clauseName = context.makeUniqueName("Clause\(offset)")
                return try InitializerClause(
                    clauseName,
                    for: initializer,
                    type: type,
                    in: context
                )
            })
        
        let enumCases: [EnumCaseDeclSyntax] = combinedMembers
            .compactMap({ $0.decl.as(EnumCaseDeclSyntax.self) })
            .filter { !$0.elements.contains(where: { $0.name.text.starts(with: "_") }) }
        
        let staticMemberFunctions: [StaticMemberFunctionClause] = try combinedMembers
            .compactMap({ $0.decl.as(FunctionDeclSyntax.self) })
            .filter({
                !$0.name.text.starts(with: "_")
                && $0.modifiers.isStatic
                && $0.modifiers.isAccessible
                && ($0.signature.returnClause?.type.as(IdentifierTypeSyntax.self)?.name.text == "Self"
                    || $0.signature.returnClause?.type.as(IdentifierTypeSyntax.self)?.name.text == type.as(IdentifierTypeSyntax.self)?.name.text)
            })
            .sorted(by: { $0.signature.parameterClause.parameters.count > $1.signature.parameterClause.parameters.count })
            .enumerated()
            .map({ (offset, function: FunctionDeclSyntax) in
                let clauseName = context.makeUniqueName("Clause\(offset)")
                return try StaticMemberFunctionClause(
                    clauseName,
                    for: function,
                    type: type,
                    in: context
                )
            })
        
        let staticMembers: [StaticMemberClause] = combinedMembers
            .compactMap({ $0.decl.as(VariableDeclSyntax.self) })
            .filter({
                !$0.bindings.contains(where: { $0.pattern.as(IdentifierPatternSyntax.self)?.identifier.text.starts(with: "_") ?? false })
                && $0.modifiers.isStatic
                && $0.modifiers.isAccessible
            })
            .flatMap({ decl in
                decl.bindings.map({ binding in
                    StaticMemberClause(member: binding, attributes: decl.attributes)
                })
            })
            .filter({
                $0.member.typeAnnotation?.type.as(IdentifierTypeSyntax.self)?.name.text == "Self"
                || $0.member.typeAnnotation?.type.as(IdentifierTypeSyntax.self)?.name.text == type.as(IdentifierTypeSyntax.self)?.name.text
            })
        
        let members: [PatternBindingSyntax] = combinedMembers
            .compactMap({ $0.decl.as(VariableDeclSyntax.self) })
            .filter({
                !$0.bindings.contains(where: { $0.pattern.as(IdentifierPatternSyntax.self)?.identifier.text.starts(with: "_") ?? false })
                && !$0.modifiers.isStatic
                && $0.modifiers.isAccessible
            })
            .flatMap(\.bindings)
            .filter({
                $0.accessorBlock != nil
                && ($0.typeAnnotation?.type.as(IdentifierTypeSyntax.self)?.name.text == "Self"
                    || $0.typeAnnotation?.type.as(IdentifierTypeSyntax.self)?.name.text == type.as(IdentifierTypeSyntax.self)?.name.text)
            })
        
        let memberFunctions: [MemberFunctionClause] = try combinedMembers
            .compactMap({ $0.decl.as(FunctionDeclSyntax.self) })
            .filter({
                !$0.name.text.starts(with: "_")
                && !$0.modifiers.isStatic
                && $0.modifiers.isAccessible
                && ($0.signature.returnClause?.type.as(IdentifierTypeSyntax.self)?.name.text == "Self"
                    || $0.signature.returnClause?.type.as(IdentifierTypeSyntax.self)?.name.text == type.as(IdentifierTypeSyntax.self)?.name.text)
            })
            .sorted(by: { $0.signature.parameterClause.parameters.count > $1.signature.parameterClause.parameters.count })
            .enumerated()
            .map({ (offset, function: FunctionDeclSyntax) in
                let clauseName = context.makeUniqueName("Clause\(offset)")
                return try MemberFunctionClause(
                    clauseName,
                    for: function,
                    type: type,
                    in: context
                )
            })
        
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
        
        let argumentsContainerName = context.makeUniqueName("argumentsContainer")
        let argumentsContainerReference = DeclReferenceExprSyntax(baseName: argumentsContainerName)
        
        /// The `init(decoder:)` implementation.
        let decoder = InitializerDeclSyntax(
            attributes: AttributeListSyntax([.attribute(AttributeSyntax(attributeName: IdentifierTypeSyntax(name: .identifier("MainActor"))))]),
            modifiers: declaration.modifiers.filter({ $0.name.tokenKind != .keyword(.indirect) }),
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
            // single value container
            VariableDeclSyntax(bindingSpecifier: .keyword(.var)) {
                PatternBindingSyntax(
                    pattern: IdentifierPatternSyntax(identifier: containerName),
                    initializer: InitializerClauseSyntax(
                        value: TryExprSyntax(
                            expression: FunctionCallExprSyntax(
                                callee: MemberAccessExprSyntax(
                                    base: decoderReference,
                                    name: .identifier("singleValueContainer")
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
            
            // init clauses
            if !clauses.isEmpty {
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
                                            base: DeclReferenceExprSyntax(baseName: initializerClausesName),
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
            
            // enum cases
            if !enumCases.isEmpty {
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
                                            base: DeclReferenceExprSyntax(baseName: enumCasesName),
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
            
            if !staticMemberFunctions.isEmpty {
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
                                            base: DeclReferenceExprSyntax(baseName: staticMemberFunctionsName),
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
            
            if !staticMembers.isEmpty {
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
                                            base: DeclReferenceExprSyntax(baseName: staticMembersName),
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
            
            if !members.isEmpty {
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
                                            base: DeclReferenceExprSyntax(baseName: membersName),
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
            
            if !memberFunctions.isEmpty {
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
                                            base: DeclReferenceExprSyntax(baseName: memberFunctionsName),
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
                }
            )
        }
        
        let genericParameters = declaration.as(StructDeclSyntax.self)?.genericParameterClause?.parameters
            ?? declaration.as(EnumDeclSyntax.self)?.genericParameterClause?.parameters
            ?? []
        
        return [
            ExtensionDeclSyntax(
                attributes: declaration.attributes.filter(\.isAvailability),
                extendedType: type,
//                inheritanceClause: InheritanceClauseSyntax {
//                    InheritedTypeSyntax(type: TypeSyntax("Swift.Decodable"))
//                },
                genericWhereClause: genericParameters.isEmpty ? nil : GenericWhereClauseSyntax {
                    // require all generic types to also conform to decodable
                    for generic in genericParameters {
                        GenericRequirementSyntax(
                            requirement: .conformanceRequirement(ConformanceRequirementSyntax(
                                leftType: IdentifierTypeSyntax(name: generic.name),
                                rightType: IdentifierTypeSyntax(name: .identifier("Decodable"))
                            ))
                        )
                    }
                }
            ) {
                identifierEnum
                decoder
                
                // init clauses
                if !clauses.isEmpty {
                    InitializerClausesDecoder(
                        name: initializerClausesName,
                        type: type,
                        identifierEnumReference: identifierEnumReference,
                        clauses: clauses
                    ).makeSyntax(in: context)
                }
                
                // enum cases
                if !enumCases.isEmpty {
                    EnumCasesDecoder(
                        name: enumCasesName,
                        type: type,
                        identifierEnumReference: identifierEnumReference,
                        cases: enumCases
                    ).makeSyntax(in: context)
                }
                
                // static member functions
                if !staticMemberFunctions.isEmpty {
                    StaticMemberFunctionsDecoder(
                        name: staticMemberFunctionsName,
                        type: type,
                        identifierEnumReference: identifierEnumReference,
                        clauses: staticMemberFunctions
                    ).makeSyntax(in: context)
                }
                
                // static members
                if !staticMembers.isEmpty {
                    StaticMembersDecoder(
                        name: staticMembersName,
                        type: type,
                        identifierEnumReference: identifierEnumReference,
                        members: staticMembers
                    ).makeSyntax(in: context)
                }
                
                // members
                if !members.isEmpty {
                    MembersDecoder(
                        name: membersName,
                        type: type,
                        identifierEnumReference: identifierEnumReference,
                        members: members
                    ).makeSyntax(in: context)
                }
                
                // member functions
                if !memberFunctions.isEmpty {
                    MemberFunctionsDecoder(
                        name: memberFunctionsName,
                        type: type,
                        identifierEnumReference: identifierEnumReference,
                        clauses: memberFunctions
                    ).makeSyntax(in: context)
                }
            }
        ]
    }
}
