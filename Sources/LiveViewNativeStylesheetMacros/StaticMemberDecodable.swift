//
//  StaticMemberDecodable.swift
//  JSONStylesheet
//
//  Created by Carson Katri on 9/24/24.
//

import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics

struct StaticMemberDecodable: MemberMacro {
    static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard case let .argumentList(arguments) = node.arguments
        else { throw StaticMemberDecodableError.missingArguments }
        
        let type = (
            declaration.as(ExtensionDeclSyntax.self)?.extendedType.flattenedType
            ?? declaration.as(StructDeclSyntax.self).flatMap({ TypeSyntax($0.name) })
            ?? declaration.as(EnumDeclSyntax.self).flatMap({ TypeSyntax($0.name) })
        )?.trimmed
        
        // Store the type name in a Decodable enum.
        let typeNameEnumName = context.makeUniqueName("TypeName")
        let typeNameEnumReference = DeclReferenceExprSyntax(baseName: typeNameEnumName)
        /// An enum used to check the identifier matches when decoding.
        let typeNameEnum = EnumDeclSyntax(
            name: typeNameEnumName,
            inheritanceClause: InheritanceClauseSyntax {
                InheritedTypeSyntax(type: TypeSyntax("Swift.String"))
                InheritedTypeSyntax(type: TypeSyntax("Swift.Decodable"))
            }
        ) {
            MemberBlockItemSyntax(decl: EnumCaseDeclSyntax {
                EnumCaseElementSyntax(name: .identifier("name"), rawValue: InitializerClauseSyntax(
                        value: StringLiteralExprSyntax(
                            openingQuote: .stringQuoteToken(),
                            segments: [
                                .stringSegment(StringSegmentSyntax(content: .stringSegment(type?.firstToken(viewMode: .sourceAccurate)?.trimmed.text ?? "")))
                            ],
                            closingQuote: .stringQuoteToken()
                        )
                    )
                )
            })
        }
        
        let members = arguments.compactMap({ (argument: LabeledExprSyntax) -> DeclReferenceExprSyntax? in
            guard let memberAccess = argument.expression.as(MemberAccessExprSyntax.self)
            else {
                context.diagnose(Diagnostic(
                    node: argument,
                    message: StaticMemberDecodableDiagnostic.invalidArgument(argument)
                ))
                return nil
            }
            
            // ensure all members have the correct type.
            let memberType = memberAccess.base?
                .as(DeclReferenceExprSyntax.self)?
                .baseName
                .text
            guard memberType == nil
                || memberType == type?.firstToken(viewMode: .sourceAccurate)?.text
            else {
                context.diagnose(.init(
                    node: argument,
                    message: StaticMemberDecodableDiagnostic.invalidArgumentType(
                        argument.trimmed,
                        expected: type
                    )
                ))
                return nil
            }
            return memberAccess.declName
        })
        
        let decoderReference = DeclReferenceExprSyntax(baseName: .identifier("decoder"))
        let containerReference = DeclReferenceExprSyntax(baseName: .identifier("container"))
        let argumentsReference = DeclReferenceExprSyntax(baseName: .identifier("arguments"))
        
        return [
            DeclSyntax(typeNameEnum),
            DeclSyntax(
                EnumDeclSyntax(
                    name: .identifier("Resolvable"),
                    inheritanceClause: InheritanceClauseSyntax {
                        InheritedTypeSyntax(type: TypeSyntax("Swift.String"))
                        InheritedTypeSyntax(type: TypeSyntax("Swift.Decodable"))
                    }
                ) {
                    for member in members {
                        EnumCaseDeclSyntax {
                            EnumCaseElementSyntax(name: member.baseName)
                        }
                    }
                    
                    InitializerDeclSyntax(
                        signature: FunctionSignatureSyntax(
                            parameterClause: FunctionParameterClauseSyntax {
                                FunctionParameterSyntax(
                                    firstName: .identifier("from"),
                                    secondName: .identifier("decoder"),
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
                                pattern: IdentifierPatternSyntax(identifier: .identifier("container")),
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
                                            base: MemberAccessExprSyntax(
                                                base: MemberAccessExprSyntax(
                                                    base: DeclReferenceExprSyntax(baseName: .identifier("ASTNode")),
                                                    name: .identifier("Identifiers")
                                                ),
                                                name: .identifier("MemberAccess")
                                            ),
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
                                pattern: IdentifierPatternSyntax(identifier: "annotations"),
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
                        // [...]
                        VariableDeclSyntax(bindingSpecifier: .keyword(.var)) {
                            PatternBindingSyntax(
                                pattern: IdentifierPatternSyntax(identifier: .identifier("arguments")),
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
                        // nil || TypeName
                        IfExprSyntax(conditions: ConditionElementListSyntax {
                            ConditionElementSyntax(condition:  .expression(
                                ExprSyntax(
                                    TryExprSyntax(
                                        expression: PrefixOperatorExprSyntax(
                                            operator: .prefixOperator("!"),
                                            expression: FunctionCallExprSyntax(
                                                callee: MemberAccessExprSyntax(
                                                    base: argumentsReference,
                                                    name: .identifier("decodeNil")
                                                )
                                            )
                                        )
                                    )
                                )
                            ))
                        }) {
                            // <TypeName>
                            InfixOperatorExprSyntax(
                                leftOperand: DiscardAssignmentExprSyntax(),
                                operator: AssignmentExprSyntax(),
                                rightOperand: TryExprSyntax(
                                    expression: FunctionCallExprSyntax(
                                        callee: MemberAccessExprSyntax(
                                            base: argumentsReference,
                                            name: .identifier("decode")
                                        )
                                    ) {
                                        LabeledExprSyntax(
                                            expression: MemberAccessExprSyntax(
                                                base: typeNameEnumReference,
                                                name: .identifier("self")
                                            )
                                        )
                                    }
                                )
                            )
                        }
                        // init from rawValue
                        GuardStmtSyntax(conditions: ConditionElementListSyntax {
                            ConditionElementSyntax(condition: .optionalBinding(
                                OptionalBindingConditionSyntax(
                                    bindingSpecifier: .keyword(.let),
                                    pattern: IdentifierPatternSyntax(identifier: .identifier("member")),
                                    initializer: InitializerClauseSyntax(
                                        value: FunctionCallExprSyntax.init(
                                            callee: MemberAccessExprSyntax(
                                                base: DeclReferenceExprSyntax(baseName: .identifier("Self")),
                                                name: .identifier("init")
                                            )
                                        ) {
                                            LabeledExprSyntax(
                                                label: "rawValue",
                                                expression: TryExprSyntax(
                                                    expression: FunctionCallExprSyntax(
                                                        callee: MemberAccessExprSyntax(
                                                            base: containerReference,
                                                            name: .identifier("decode")
                                                        )
                                                    ) {
                                                        LabeledExprSyntax(
                                                            expression: MemberAccessExprSyntax(
                                                                base: DeclReferenceExprSyntax(baseName: .identifier("String")),
                                                                name: .identifier("self")
                                                            )
                                                        )
                                                    }
                                                )
                                            )
                                        }
                                    )
                                )
                            ))
                        }) {
                            ThrowStmtSyntax(
                                expression: FunctionCallExprSyntax(
                                    callee: MemberAccessExprSyntax(
                                        base: DeclReferenceExprSyntax(baseName: .identifier("UnknownStaticMemberError")),
                                        name: .identifier("init")
                                    )
                                ) {
                                    LabeledExprSyntax(
                                        label: "annotations",
                                        expression: DeclReferenceExprSyntax(baseName: .identifier("annotations"))
                                    )
                                }
                            )
                        }
                        InfixOperatorExprSyntax(
                            leftOperand: DeclReferenceExprSyntax(baseName: .identifier("self")),
                            operator: AssignmentExprSyntax(),
                            rightOperand: DeclReferenceExprSyntax(baseName: .identifier("member"))
                        )
                    }
                }
            )
        ]
    }
}

enum StaticMemberDecodableError: Error {
    case missingArguments
    case invalidArgument(LabeledExprSyntax)
}

enum StaticMemberDecodableDiagnostic: DiagnosticMessage {
    case invalidArgument(LabeledExprSyntax)
    case invalidArgumentType(LabeledExprSyntax, expected: TypeSyntax?)
    
    var message: String {
        switch self {
        case let .invalidArgument(argument):
            "Argument '\(argument.description)' is not a static member"
        case let .invalidArgumentType(argument, expected):
            "Type of argument '\(argument.description)' does not match parent type '\(expected?.description ?? "")'"
        }
    }
    
    var id: String {
        switch self {
        case .invalidArgument:
            "invalidArgument"
        case .invalidArgumentType:
            "invalidArgumentType"
        }
    }
    
    var diagnosticID: MessageID {
        .init(domain: "LiveViewNativeStylesheet", id: id)
    }
    
    var severity: DiagnosticSeverity {
        switch self {
        case .invalidArgument:
            .error
        case .invalidArgumentType:
            .error
        }
    }
}

extension TypeSyntax {
    var flattenedType: TypeSyntax {
        if let memberType = self.as(MemberTypeSyntax.self) {
            return TypeSyntax(IdentifierTypeSyntax(name: memberType.name))!
        } else {
            return self
        }
    }
}
