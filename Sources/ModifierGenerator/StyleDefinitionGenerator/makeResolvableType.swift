//
//  resolvableType.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/29/25.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxExtensions

extension StyleDefinitionGenerator {
    /// Creates a `.Resolvable` type and an extension for its `resolve(on:in:)` method.
    func makeResolvableType(for node: some ResolvableDeclSyntaxProtocol) -> (EnumDeclSyntax, ExtensionDeclSyntax)? {
        let typeNameWithModule = node.fullyResolvedType.trimmedDescription.starts(with: moduleName)
        ? node.fullyResolvedType.trimmedDescription
        : "\(moduleName).\(node.fullyResolvedType.trimmedDescription)"
        
        let extensionMembers: [MemberBlockItemSyntax] = self.extensions[typeNameWithModule, default: []].flatMap({ (extensionDecl: ExtensionDeclSyntax) -> [MemberBlockItemSyntax] in
            let extensionAttributes = extensionDecl.attributes.filter(\.isAvailability)
            return extensionDecl.memberBlock.members.map { (member: MemberBlockItemSyntax) -> MemberBlockItemSyntax in
                if var initDecl = member.decl.as(InitializerDeclSyntax.self) {
                    initDecl.attributes.append(contentsOf: extensionAttributes)
                    return member.with(\.decl, DeclSyntax(initDecl))
                } else if var functionDecl = member.decl.as(FunctionDeclSyntax.self) {
                    functionDecl.attributes.append(contentsOf: extensionAttributes)
                    return member.with(\.decl, DeclSyntax(functionDecl))
                } else {
                    return member
                }
            }
        })
        let members = node.memberBlock.members + extensionMembers
        let enumCases = members
            .compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
            .filter(\.modifiers.isAccessible)
            .map {
                $0.with(\.elements, EnumCaseElementListSyntax($0.elements.map {
                    $0.with(\.parameterClause, $0.parameterClause.flatMap({ parameterClause in
                        /// Create an init decl that has the same parameters, and normalize on the decl
                        let initDecl = InitializerDeclSyntax(signature: FunctionSignatureSyntax(parameterClause: FunctionParameterClauseSyntax(parameters: FunctionParameterListSyntax(
                            parameterClause.parameters.map({
                                FunctionParameterSyntax(firstName: $0.firstName ?? .identifier("__wildcard"), secondName: $0.secondName, type: $0.type)
                            })
                        ))))
                            .normalizedParameterTypes()
                        return EnumCaseParameterClauseSyntax(parameters: EnumCaseParameterListSyntax {
                            for parameter in initDecl.signature.parameterClause.parameters {
                                if parameter.firstName.tokenKind == .identifier("__wildcard") {
                                    EnumCaseParameterSyntax(
                                        firstName: nil,
                                        secondName: parameter.secondName,
                                        colon: parameter.secondName == nil ? nil : .colonToken(),
                                        type: parameter.type
                                    )
                                } else {
                                    EnumCaseParameterSyntax(
                                        firstName: parameter.firstName,
                                        secondName: parameter.secondName,
                                        colon: .colonToken(),
                                        type: parameter.type
                                    )
                                }
                            }
                        })
                    }))
                }))
            }
        let initializers = members
            .compactMap { $0.decl.as(InitializerDeclSyntax.self) }
            .filter(\.modifiers.isAccessible)
            .filter {
                $0.isValidModifier
                && $0.genericParameterClause == nil && $0.genericWhereClause == nil
                && !$0.attributes.isDeprecated
                && $0.optionalMark == nil
            }
            .map { $0.normalizedParameterTypes() }
        let memberFunctions = members
            .compactMap { $0.decl.as(FunctionDeclSyntax.self) }
            .filter(\.modifiers.isAccessible)
            .filter {
                $0.isValidModifier
                && !$0.attributes.isDeprecated
                && !$0.modifiers.contains(where: { $0.name.tokenKind == .keyword(.static) })
                && (
                    $0.signature.returnClause?.type.as(IdentifierTypeSyntax.self)?.name.tokenKind == .keyword(.Self)
                    || $0.signature.returnClause?.type.as(IdentifierTypeSyntax.self)?.name.text == node.name.text
                    || $0.signature.returnClause?.type.as(MemberTypeSyntax.self)?.name.text == node.name.text
                )
            }
            .map { $0.normalizedParameterTypes() }
        let staticFunctions = members
            .compactMap { $0.decl.as(FunctionDeclSyntax.self) }
            .filter(\.modifiers.isAccessible)
            .filter {
                $0.isValidModifier
                && $0.genericParameterClause == nil && $0.genericWhereClause == nil
                && !$0.attributes.isDeprecated
                && !$0.name.isOperatorToken
                && $0.modifiers.contains(where: { $0.name.tokenKind == .keyword(.static) })
                && (
                    $0.signature.returnClause?.type.as(IdentifierTypeSyntax.self)?.name.tokenKind == .keyword(.Self)
                    || $0.signature.returnClause?.type.as(IdentifierTypeSyntax.self)?.name.text == node.name.text
                    || $0.signature.returnClause?.type.as(MemberTypeSyntax.self)?.name.text == node.name.text
                )
            }
            .map { $0.normalizedParameterTypes() }
        let staticMembers = members
            .compactMap({ $0.decl.as(VariableDeclSyntax.self) })
            .filter({
                !$0.attributes.isDeprecated
                && !$0.bindings.contains(where: { $0.pattern.as(IdentifierPatternSyntax.self)?.identifier.text.starts(with: "_") ?? false })
                && $0.modifiers.contains(where: { $0.name.tokenKind == .keyword(.static) })
                && $0.modifiers.isAccessible
            })
        
        guard !enumCases.isEmpty || !initializers.isEmpty || !memberFunctions.isEmpty || !staticFunctions.isEmpty || !staticMembers.isEmpty
        else { return nil }
        
        let resolvableEnum = EnumDeclSyntax(
            attributes: node.fullyResolvedAvailabilityAttributes,
            modifiers: [DeclModifierSyntax(name: .keyword(.indirect))],
            name: .identifier("Resolvable"),
            inheritanceClause: InheritanceClauseSyntax {
                InheritedTypeSyntax(type: IdentifierTypeSyntax(name: .identifier("StylesheetResolvable")))
            }
        ) {
            // add a constant case for default values
            // case __constant(ParentType)
            EnumCaseDeclSyntax {
                EnumCaseElementSyntax(
                    name: .identifier("__constant"),
                    parameterClause: EnumCaseParameterClauseSyntax(parameters: EnumCaseParameterListSyntax {
                        EnumCaseParameterSyntax(type: node.fullyResolvedType)
                    })
                )
            }
            
            for (index, caseDecl) in enumCases.enumerated() {
                caseDecl.attributes.makeOSCheck {
                    caseDecl
                }
            }
            for (index, member) in staticMembers.enumerated() {
                let bindings = member.bindings.filter({
                    $0.typeAnnotation?.type.as(IdentifierTypeSyntax.self)?.name.text == "Self"
                    || $0.typeAnnotation?.type.trimmedDescription == typeNameWithModule
                })
                for binding in bindings {
                    if let name = binding
                        .pattern
                        .as(IdentifierPatternSyntax.self)?
                        .identifier
                    {
                        member.attributes.makeOSCheck {
                            EnumCaseDeclSyntax {
                                EnumCaseElementSyntax(name: .identifier("__\(index)_staticMember"))
                            }
                            VariableDeclSyntax(
                                attributes: member.attributes.filter(\.isAvailability),
                                modifiers: [DeclModifierSyntax(name: .keyword(.static))],
                                bindingSpecifier: .keyword(.var)
                            ) {
                                PatternBindingSyntax(
                                    pattern: IdentifierPatternSyntax.init(identifier: name),
                                    typeAnnotation: TypeAnnotationSyntax(type: IdentifierTypeSyntax(name: .keyword(.Self))),
                                    accessorBlock: AccessorBlockSyntax(leftBrace: .leftBraceToken(), accessors: .getter(CodeBlockItemListSyntax {
                                        MemberAccessExprSyntax(name: .identifier("__\(index)_staticMember"))
                                    }), rightBrace: .rightBraceToken())
                                )
                            }
                        }
                    }
                    
                }
            }
            for (index, initDecl) in initializers.enumerated() {
                initDecl.attributes.makeOSCheck {
                    EnumCaseDeclSyntax {
                        EnumCaseElementSyntax(
                            name: .identifier("__\(index)_initializer"),
                            parameterClause: initDecl.signature.parameterClause.parameters.isEmpty ? nil : EnumCaseParameterClauseSyntax(parameters: EnumCaseParameterListSyntax {
                                for parameter in initDecl.signature.parameterClause.parameters {
                                    EnumCaseParameterSyntax(type: IdentifierTypeSyntax(name: .keyword(.Any)))
                                }
                            })
                        )
                    }
                    InitializerDeclSyntax(
                        attributes: initDecl.attributes.filter(\.isAvailability),
                        signature: initDecl.signature
                    ) {
                        // self = .__0_initializer(param1, param2, ...)
                        if initDecl.signature.parameterClause.parameters.isEmpty {
                            InfixOperatorExprSyntax(
                                leftOperand: DeclReferenceExprSyntax(baseName: .identifier("self")),
                                operator: AssignmentExprSyntax(),
                                rightOperand: MemberAccessExprSyntax(name: .identifier("__\(index)_initializer"))
                            )
                        } else {
                            InfixOperatorExprSyntax(
                                leftOperand: DeclReferenceExprSyntax(baseName: .identifier("self")),
                                operator: AssignmentExprSyntax(),
                                rightOperand: FunctionCallExprSyntax(calledExpression: MemberAccessExprSyntax(name: .identifier("__\(index)_initializer")), leftParen: .leftParenToken(), rightParen: .rightParenToken()) {
                                    for parameter in initDecl.signature.parameterClause.parameters {
                                        LabeledExprSyntax(expression: DeclReferenceExprSyntax(baseName: parameter.resolvedName))
                                    }
                                }
                            )
                        }
                    }
                }
            }
            for (index, functionDecl) in memberFunctions.enumerated() {
                functionDecl.attributes.makeOSCheck {
                    EnumCaseDeclSyntax {
                        EnumCaseElementSyntax(
                            name: .identifier("__\(index)_function"),
                            parameterClause: EnumCaseParameterClauseSyntax(parameters: EnumCaseParameterListSyntax {
                                EnumCaseParameterSyntax(type: IdentifierTypeSyntax(name: .keyword(.Self)))
                                for parameter in functionDecl.signature.parameterClause.parameters {
                                    EnumCaseParameterSyntax(type: IdentifierTypeSyntax(name: .keyword(.Any)))
                                }
                            })
                        )
                    }
                    
                    FunctionDeclSyntax(
                        attributes: functionDecl.attributes.filter(\.isAvailability),
                        name: functionDecl.name,
                        signature: functionDecl.signature
                            .with(\.parameterClause.parameters, FunctionParameterListSyntax(functionDecl.signature.parameterClause.parameters.map({ $0.with(\.secondName, $0.resolvedName) })))
                            .with(\.returnClause, ReturnClauseSyntax(type: IdentifierTypeSyntax(name: .keyword(.Self))))
                    ) {
                        // .__0_function(self, param1, param2, ...)
                        FunctionCallExprSyntax(calledExpression: MemberAccessExprSyntax(name: .identifier("__\(index)_function")), leftParen: .leftParenToken(), rightParen: .rightParenToken()) {
                            LabeledExprSyntax(expression: DeclReferenceExprSyntax(baseName: .identifier("self")))
                            for parameter in functionDecl.signature.parameterClause.parameters {
                                LabeledExprSyntax(expression: DeclReferenceExprSyntax(baseName: parameter.resolvedName))
                            }
                        }
                    }
                }
            }
            for (index, functionDecl) in staticFunctions.enumerated() {
                functionDecl.attributes.makeOSCheck {
                    EnumCaseDeclSyntax {
                        EnumCaseElementSyntax(
                            name: .identifier("__\(index)_staticFunction"),
                            parameterClause: EnumCaseParameterClauseSyntax(parameters: EnumCaseParameterListSyntax {
                                for parameter in functionDecl.signature.parameterClause.parameters {
                                    EnumCaseParameterSyntax(type: IdentifierTypeSyntax(name: .keyword(.Any)))
                                }
                            })
                        )
                    }
                    
                    FunctionDeclSyntax(
                        attributes: functionDecl.attributes.filter(\.isAvailability),
                        modifiers: [DeclModifierSyntax(name: .keyword(.static))],
                        name: functionDecl.name,
                        signature: functionDecl.signature
                            .with(\.parameterClause.parameters, FunctionParameterListSyntax(functionDecl.signature.parameterClause.parameters.map({ $0.with(\.secondName, $0.resolvedName) })))
                            .with(\.returnClause, ReturnClauseSyntax(type: IdentifierTypeSyntax(name: .keyword(.Self))))
                    ) {
                        // .__0_staticFunction(param1, param2, ...)
                        FunctionCallExprSyntax(calledExpression: MemberAccessExprSyntax(name: .identifier("__\(index)_staticFunction")), leftParen: .leftParenToken(), rightParen: .rightParenToken()) {
                            for parameter in functionDecl.signature.parameterClause.parameters {
                                LabeledExprSyntax(expression: DeclReferenceExprSyntax(baseName: parameter.resolvedName))
                            }
                        }
                    }
                }
            }
        }
        
        let resolveMethodExtension = ExtensionDeclSyntax(
            attributes: node.fullyResolvedAvailabilityAttributes,
            extendedType: MemberTypeSyntax(baseType: node.fullyResolvedType, name: .identifier("Resolvable"))
        ) {
            // func resolve(on element: Element, in context: Context)
            FunctionDeclSyntax(
                name: .identifier("resolve"),
                signature: FunctionSignatureSyntax(
                    parameterClause: FunctionParameterClauseSyntax(parameters: FunctionParameterListSyntax {
                        FunctionParameterSyntax(firstName: .identifier("on"), secondName: .identifier("__element"), colon: .colonToken(), type: IdentifierTypeSyntax(name: .identifier("Element")))
                        FunctionParameterSyntax(firstName: .identifier("in"), secondName: .identifier("__context"), colon: .colonToken(), type: IdentifierTypeSyntax(name: .identifier("Context")))
                    }),
                    returnClause: ReturnClauseSyntax(type: node.fullyResolvedType)
                )
            ) {
                CodeBlockItemSyntax(item: .expr(ExprSyntax(SwitchExprSyntax(subject: DeclReferenceExprSyntax(baseName: .identifier("self"))) {
                    // case let .__constant(__value)
                    SwitchCaseSyntax(label: .case(SwitchCaseLabelSyntax {
                        SwitchCaseItemSyntax(
                            pattern: ValueBindingPatternSyntax(
                                bindingSpecifier: .keyword(.let),
                                pattern: ExpressionPatternSyntax(expression: FunctionCallExprSyntax(
                                    calledExpression: MemberAccessExprSyntax(name: .identifier("__constant")),
                                    leftParen: .leftParenToken(),
                                    rightParen: .rightParenToken()
                                ) {
                                    LabeledExprSyntax(expression: PatternExprSyntax(pattern: IdentifierPatternSyntax(identifier: .identifier("__value"))))
                                })
                            )
                        )
                    })) {
                        CodeBlockItemSyntax(item: .stmt(StmtSyntax(ReturnStmtSyntax(expression: DeclReferenceExprSyntax(baseName: .identifier("__value"))))))
                    }
                    
                    for caseDecl in enumCases {
                        caseDecl.attributes.makeOSCheck {
                            for element in caseDecl.elements {
                                if let parameterClause = element.parameterClause {
                                    SwitchCaseSyntax(label: .case(SwitchCaseLabelSyntax {
                                        SwitchCaseItemSyntax(pattern: ValueBindingPatternSyntax(
                                            bindingSpecifier: .keyword(.let),
                                            pattern: ExpressionPatternSyntax(expression: FunctionCallExprSyntax(
                                                calledExpression: MemberAccessExprSyntax(name: element.name),
                                                leftParen: .leftParenToken(),
                                                rightParen: .rightParenToken()
                                            ) {
                                                for parameter in parameterClause.parameters {
                                                    LabeledExprSyntax(expression: PatternExprSyntax(pattern: IdentifierPatternSyntax(identifier: parameter.resolvedName.escaped)))
                                                }
                                            })
                                        ))
                                    })) {
                                        caseDecl.attributes.makeRuntimeOSCheck {
                                            ReturnStmtSyntax(expression: FunctionCallExprSyntax(
                                                calledExpression: MemberAccessExprSyntax(name: element.name),
                                                leftParen: .leftParenToken(),
                                                rightParen: .rightParenToken()
                                            ) {
                                                for parameter in parameterClause.parameters {
                                                    let parameterReference = TupleExprSyntax {
                                                        LabeledExprSyntax(expression: AsExprSyntax(
                                                            expression: DeclReferenceExprSyntax(baseName: parameter.resolvedName.escaped),
                                                            questionOrExclamationMark: .exclamationMarkToken(),
                                                            type: parameter.type
                                                        ))
                                                    }
                                                    let expression = FunctionCallExprSyntax.resolveAttributeReference(parameterReference)
                                                    if let firstName = parameter.firstName,
                                                       firstName.tokenKind != .wildcard {
                                                        LabeledExprSyntax(label: firstName, colon: .colonToken(), expression: expression)
                                                    } else {
                                                        LabeledExprSyntax(expression: expression)
                                                    }
                                                }
                                            })
                                        } elseBody: {
                                            FunctionCallExprSyntax(callee: DeclReferenceExprSyntax(baseName: .identifier("fatalError")))
                                        }
                                    }
                                } else {
                                    SwitchCaseSyntax(label: .case(SwitchCaseLabelSyntax {
                                        SwitchCaseItemSyntax(pattern: ExpressionPatternSyntax(expression: MemberAccessExprSyntax(name: element.name)))
                                    })) {
                                        caseDecl.attributes.makeRuntimeOSCheck {
                                            ReturnStmtSyntax(expression: MemberAccessExprSyntax(name: element.name))
                                        } elseBody: {
                                            FunctionCallExprSyntax(callee: DeclReferenceExprSyntax(baseName: .identifier("fatalError")))
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    for (index, member) in staticMembers.enumerated() {
                        let bindings = member.bindings.filter({
                            $0.typeAnnotation?.type.as(IdentifierTypeSyntax.self)?.name.text == "Self"
                            || $0.typeAnnotation?.type.trimmedDescription == typeNameWithModule
                        })
                        for binding in bindings {
                            if let name = binding
                                .pattern
                                .as(IdentifierPatternSyntax.self)?
                                .identifier
                            {
                                member.attributes.makeOSCheck {
                                    SwitchCaseSyntax(label: .case(SwitchCaseLabelSyntax {
                                        SwitchCaseItemSyntax(pattern: ExpressionPatternSyntax(expression: MemberAccessExprSyntax(name: .identifier("__\(index)_staticMember"))))
                                    })) {
                                        member.attributes.makeRuntimeOSCheck {
                                            ReturnStmtSyntax(expression: MemberAccessExprSyntax(name: name))
                                        } elseBody: {
                                            FunctionCallExprSyntax(callee: DeclReferenceExprSyntax(baseName: .identifier("fatalError")))
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    for (index, initDecl) in initializers.enumerated() {
                        initDecl.attributes.makeOSCheck {
                            SwitchCaseSyntax(label: .case(SwitchCaseLabelSyntax {
                                if initDecl.signature.parameterClause.parameters.isEmpty {
                                    SwitchCaseItemSyntax(pattern: ExpressionPatternSyntax(expression: MemberAccessExprSyntax(name: .identifier("__\(index)_initializer"))))
                                } else {
                                    SwitchCaseItemSyntax(
                                        pattern: ValueBindingPatternSyntax(
                                            bindingSpecifier: .keyword(.let),
                                            pattern: ExpressionPatternSyntax(expression: FunctionCallExprSyntax(
                                                calledExpression: MemberAccessExprSyntax(name: .identifier("__\(index)_initializer")),
                                                leftParen: .leftParenToken(),
                                                rightParen: .rightParenToken()
                                            ) {
                                                for parameter in initDecl.signature.parameterClause.parameters {
                                                    LabeledExprSyntax(expression: PatternExprSyntax(pattern: IdentifierPatternSyntax(identifier: parameter.resolvedName)))
                                                }
                                            })
                                        )
                                    )
                                }
                            })) {
                                initDecl.attributes.makeRuntimeOSCheck {
                                    ReturnStmtSyntax(expression: FunctionCallExprSyntax(calledExpression: MemberAccessExprSyntax(name: .keyword(.`init`)), leftParen: .leftParenToken(), rightParen: .rightParenToken()) {
                                        for parameter in initDecl.signature.parameterClause.parameters {
                                            let expression = parameter.resolvedExpr()
                                            if parameter.firstName.tokenKind == .wildcard {
                                                LabeledExprSyntax(expression: expression)
                                            } else {
                                                LabeledExprSyntax(label: parameter.firstName, colon: .colonToken(), expression: expression)
                                            }
                                        }
                                    })
                                } elseBody: {
                                    FunctionCallExprSyntax(callee: DeclReferenceExprSyntax(baseName: .identifier("fatalError")))
                                }
                            }
                        }
                    }
                    
                    for (index, functionDecl) in memberFunctions.enumerated() {
                        functionDecl.attributes.makeOSCheck {
                            // case let .__0_function(__root, ...):
                            //     return __root.resolve(on: element, in: context).callFunction0(...)
                            SwitchCaseSyntax(label: .case(SwitchCaseLabelSyntax {
                                SwitchCaseItemSyntax(
                                    pattern: ValueBindingPatternSyntax(
                                        bindingSpecifier: .keyword(.let),
                                        pattern: ExpressionPatternSyntax(expression: FunctionCallExprSyntax(
                                            calledExpression: MemberAccessExprSyntax(name: .identifier("__\(index)_function")),
                                            leftParen: .leftParenToken(),
                                            rightParen: .rightParenToken()
                                        ) {
                                            LabeledExprSyntax(expression: PatternExprSyntax(pattern: IdentifierPatternSyntax(identifier: .identifier("__root"))))
                                            for parameter in functionDecl.signature.parameterClause.parameters {
                                                LabeledExprSyntax(expression: PatternExprSyntax(pattern: IdentifierPatternSyntax(identifier: parameter.resolvedName)))
                                            }
                                        })
                                    )
                                )
                            })) {
                                functionDecl.attributes.makeRuntimeOSCheck {
                                    ReturnStmtSyntax(
                                        expression: FunctionCallExprSyntax(
                                            calledExpression: MemberAccessExprSyntax(
                                                base: FunctionCallExprSyntax.resolveAttributeReference(DeclReferenceExprSyntax(baseName: .identifier("__root"))),
                                                name: functionDecl.name
                                            ),
                                            leftParen: .leftParenToken(),
                                            rightParen: .rightParenToken()
                                        ) {
                                            for parameter in functionDecl.signature.parameterClause.parameters {
                                                let expression = parameter.resolvedExpr()
                                                if parameter.firstName.tokenKind == .wildcard {
                                                    LabeledExprSyntax(expression: expression)
                                                } else {
                                                    LabeledExprSyntax(label: parameter.firstName, colon: .colonToken(), expression: expression)
                                                }
                                            }
                                        }
                                    )
                                } elseBody: {
                                    FunctionCallExprSyntax(callee: DeclReferenceExprSyntax(baseName: .identifier("fatalError")))
                                }
                            }
                        }
                    }
                    
                    for (index, functionDecl) in staticFunctions.enumerated() {
                        functionDecl.attributes.makeOSCheck {
                            // case let .__0_staticFunction(...):
                            //     return .callStaticFunction0(...)
                            SwitchCaseSyntax(label: .case(SwitchCaseLabelSyntax {
                                SwitchCaseItemSyntax(
                                    pattern: ValueBindingPatternSyntax(
                                        bindingSpecifier: .keyword(.let),
                                        pattern: ExpressionPatternSyntax(expression: FunctionCallExprSyntax(
                                            calledExpression: MemberAccessExprSyntax(name: .identifier("__\(index)_staticFunction")),
                                            leftParen: .leftParenToken(),
                                            rightParen: .rightParenToken()
                                        ) {
                                            for parameter in functionDecl.signature.parameterClause.parameters {
                                                LabeledExprSyntax(expression: PatternExprSyntax(pattern: IdentifierPatternSyntax(identifier: parameter.resolvedName)))
                                            }
                                        })
                                    )
                                )
                            })) {
                                functionDecl.attributes.makeRuntimeOSCheck {
                                    ReturnStmtSyntax(
                                        expression: FunctionCallExprSyntax(
                                            calledExpression: MemberAccessExprSyntax(
                                                name: functionDecl.name
                                            ),
                                            leftParen: .leftParenToken(),
                                            rightParen: .rightParenToken()
                                        ) {
                                            for parameter in functionDecl.signature.parameterClause.parameters {
                                                let expression = parameter.resolvedExpr()
                                                if parameter.firstName.tokenKind == .wildcard {
                                                    LabeledExprSyntax(expression: expression)
                                                } else {
                                                    LabeledExprSyntax(label: parameter.firstName, colon: .colonToken(), expression: expression)
                                                }
                                            }
                                        }
                                    )
                                } elseBody: {
                                    FunctionCallExprSyntax(callee: DeclReferenceExprSyntax(baseName: .identifier("fatalError")))
                                }
                            }
                        }
                    }
                    
                    // @unknown default: fatalError()
                    SwitchCaseSyntax(
                        attribute: AttributeSyntax(IdentifierTypeSyntax(name: .identifier("unknown"))),
                        label: .default(SwitchDefaultLabelSyntax())
                    ) {
                        FunctionCallExprSyntax(callee: DeclReferenceExprSyntax(baseName: .identifier("fatalError")))
                    }
                })))
            }
        }
        
        return (resolvableEnum, resolveMethodExtension)
    }
}
