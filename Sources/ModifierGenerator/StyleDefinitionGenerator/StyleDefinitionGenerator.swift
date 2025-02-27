//
//  StyleDefinitionGenerator.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/29/25.
//

import Foundation
import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import SwiftParser
import SwiftSyntaxExtensions
import ASTDecodableImplementation

public final class StyleDefinitionGenerator: SyntaxVisitor {
    let moduleName: String
    
    /// Extensions for supporting types to add a nested `.Resolvable` type.
    public private(set) var decoderExtensions = [String:[DeclSyntax]]()
    
    /// The decodable modifier definitions.
    ///
    /// Keyed by modifier name so other function definitions can add more
    /// clauses to the struct.
    public var modifiers = [String:StructDeclSyntax]()
    
    /// Extensions declared for supporting types collected before visiting begins.
    var extensions = [String:[ExtensionDeclSyntax]]()
    
    public init(moduleName: String) {
        self.moduleName = moduleName
        super.init(viewMode: .fixedUp)
    }
    
    public override func visit(_ node: SourceFileSyntax) -> SyntaxVisitorContinueKind {
        // setup from root
        let extensionVisitor = ExtensionVisitor(viewMode: .fixedUp)
        extensionVisitor.walk(node)
        self.extensions = extensionVisitor.extensions
        
        return .visitChildren
    }
    
    public override func visit(_ node: EnumDeclSyntax) -> SyntaxVisitorContinueKind {
        guard !typeDenylist.contains(node.name.text)
        else { return .skipChildren }
        guard !typeDenylist.contains(node.fullyResolvedType.trimmedDescription)
        else { return .skipChildren }
        
        guard node.genericParameterClause == nil && node.genericWhereClause == nil
        else { return .skipChildren }
        
        guard !node.name.text.starts(with: "_")
        else { return .skipChildren }
        
        guard !node.attributes.isActorIsolated
        else { return .visitChildren }
        
        guard node.modifiers.isAccessible
        else { return .visitChildren }
        
        guard !node.attributes.isDeprecated
        else { return .visitChildren }
        
        // replicate all of the public symbols with `AttributeDecodable` wrapping
        guard let (resolvable, resolveMethodExtension) = makeResolvableType(for: node)
        else { return .visitChildren }
        
        let fullyResolvedName = node.fullyResolvedType.trimmedDescription
        
        decoderExtensions[fullyResolvedName, default: []].append(node.fullyResolvedAvailabilityAttributes.makeOSCheck {
            ExtensionDeclSyntax(
                attributes: node.fullyResolvedAvailabilityAttributes,
                extendedType: node.fullyResolvedType
            ) {
                resolvable
            }
        }.first!.decl)
        
        decoderExtensions[fullyResolvedName, default: []].append(node.fullyResolvedAvailabilityAttributes.makeOSCheck {
            resolveMethodExtension
        }.first!.decl)
        
        let extensions = try! ASTDecodable.expansion(
            of: AttributeSyntax(TypeSyntax(IdentifierTypeSyntax(name: .identifier("ASTDecodable")))) {
                LabeledExprSyntax(expression: StringLiteralExprSyntax(content: node.name.text))
            },
            attachedTo: resolvable,
            providingExtensionsOf: MemberTypeSyntax(baseType: node.fullyResolvedType, name: .identifier("Resolvable")),
            conformingTo: [],
            in: InlineExpansionContext()
        )
        
        decoderExtensions[fullyResolvedName, default: []].append(node.fullyResolvedAvailabilityAttributes.makeOSCheck {
            for `extension` in extensions {
                `extension`
            }
        }.first!.decl)
        
        return .visitChildren
    }
    
    public override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
        guard !typeDenylist.contains(node.name.text)
        else { return .skipChildren }
        guard !typeDenylist.contains(node.fullyResolvedType.trimmedDescription)
        else { return .skipChildren }
        
        guard node.genericParameterClause == nil && node.genericWhereClause == nil
        else { return .skipChildren }
        
        guard !node.name.text.starts(with: "_")
        else { return .skipChildren }
        
        guard !node.attributes.isActorIsolated
        else { return .visitChildren }
        
        guard node.modifiers.isAccessible
        else { return .visitChildren }
        
        guard !(node.inheritanceClause?.inheritedTypes.contains(where: {
            $0.type.as(MemberTypeSyntax.self)?.name.text == "View" || $0.type.as(IdentifierTypeSyntax.self)?.name.text == "View"
            || $0.type.as(MemberTypeSyntax.self)?.name.text == "Layout" || $0.type.as(IdentifierTypeSyntax.self)?.name.text == "Layout"
        }) ?? false)
        else { return .visitChildren }
        
        guard !node.attributes.isDeprecated
        else { return .visitChildren }
        
        // replicate all of the public symbols with `AttributeDecodable` wrapping
        guard let (resolvable, resolveMethodExtension) = makeResolvableType(for: node)
        else { return .visitChildren }
        
        let fullyResolvedName = node.fullyResolvedType.trimmedDescription
        
        decoderExtensions[fullyResolvedName, default: []].append(node.fullyResolvedAvailabilityAttributes.makeOSCheck {
            ExtensionDeclSyntax(
                attributes: node.fullyResolvedAvailabilityAttributes,
                extendedType: node.fullyResolvedType
            ) {
                resolvable
            }
        }.first!.decl)
        
        decoderExtensions[fullyResolvedName, default: []].append(node.fullyResolvedAvailabilityAttributes.makeOSCheck {
            resolveMethodExtension
        }.first!.decl)
        
        let extensions = try! ASTDecodable.expansion(
            of: AttributeSyntax(TypeSyntax(IdentifierTypeSyntax(name: .identifier("ASTDecodable")))) {
                LabeledExprSyntax(expression: StringLiteralExprSyntax(content: node.name.text))
            },
            attachedTo: resolvable,
            providingExtensionsOf: MemberTypeSyntax(baseType: node.fullyResolvedType, name: .identifier("Resolvable")),
            conformingTo: [],
            in: InlineExpansionContext()
        )
        
        decoderExtensions[fullyResolvedName, default: []].append(node.fullyResolvedAvailabilityAttributes.makeOSCheck {
            for `extension` in extensions {
                `extension`
            }
        }.first!.decl)
        
        return .visitChildren
    }
    
    public override func visit(_ node: ExtensionDeclSyntax) -> SyntaxVisitorContinueKind {
        // don't visit children of excluded types
        guard !typeDenylist.contains(node.extendedType.trimmedDescription)
        else { return .skipChildren }
        
        // View modifiers
        guard node.isViewExtension
        else { return .visitChildren }
        
        guard !node.attributes.isDeprecated
        else { return .visitChildren }
        
        let extensionAvailability = node.attributes.filter(\.isAvailability)
        
        for modifier in node.memberBlock.members
            .compactMap({ $0.decl.as(FunctionDeclSyntax.self) })
            .filter(\.isValidModifier)
            .map({ $0.normalizedParameterTypes() })
            .filter(\.isPublic)
            .filter({ !denylist.contains($0.name.text) })
        {
            // special case for `toolbar` to exclude `ViewReference` clauses.
            if modifier.name.text == "toolbar" {
                guard !modifier.signature.parameterClause.parameters.contains(where: {
                    return $0.type.as(IdentifierTypeSyntax.self)?.genericArgumentClause?.arguments.first?.argument.as(IdentifierTypeSyntax.self)?.name.text == "ViewReference"
                })
                else { continue }
            }
            
            // the 2nd member is always the enum decl
            // 1st member is the body(content:) block
            let offset = modifiers[modifier.name.text]?.memberBlock.members
                .dropFirst()
                .first!
                .decl.as(EnumDeclSyntax.self)!
                .memberBlock.members
                .filter({ $0.decl.is(EnumCaseDeclSyntax.self) })
                .count ?? 0
            
            var availability = modifier.attributes.filter(\.isAvailability)
            availability.insert(contentsOf: extensionAvailability, at: availability.startIndex)
            
            let usesGestureState = modifier.signature.parameterClause.parameters.contains(where: {
                $0.type.as(IdentifierTypeSyntax.self)?.genericArgumentClause?.arguments.first?.argument.as(IdentifierTypeSyntax.self)?.name.text == "StylesheetResolvableGesture"
            })
            
            /// The enum case added to the declaration for this signature
            let enumCase = EnumCaseDeclSyntax {
                EnumCaseElementSyntax(
                    name: .identifier("_\(offset)"),
                    parameterClause: modifier.signature.parameterClause.parameters.isEmpty ? nil : EnumCaseParameterClauseSyntax(parameters: EnumCaseParameterListSyntax {
                        for parameter in modifier.signature.parameterClause.parameters {
                            if parameter.type.as(MemberTypeSyntax.self)?.baseType.as(IdentifierTypeSyntax.self)?.name.text == "ChangeTracked" {
                                // this is a dynamic property, so we need to have the type explicitly provided for SwiftUI to install
                                // but the generic argument must be erased. we use `AnyEquatableEncodable` to meet the required conformances.
                                EnumCaseParameterSyntax(
                                    firstName: parameter.resolvedName,
                                    colon: .colonToken(),
                                    type: IdentifierTypeSyntax(name: .identifier("ChangeTracked"), genericArgumentClause: GenericArgumentClauseSyntax {
                                        GenericArgumentSyntax(argument: IdentifierTypeSyntax(name: .identifier("AnyEquatableEncodable")))
                                    })
                                )
                            } else if parameter.type.as(IdentifierTypeSyntax.self)?.name.text == "Event" {
                                // this is a dynamic property, so we need to have the type explicitly provided for SwiftUI to install
                                EnumCaseParameterSyntax(
                                    firstName: parameter.resolvedName,
                                    colon: .colonToken(),
                                    type: parameter.type
                                )
                            } else {
                                // other types are stored as `Any` in the enum to avoid #availability issues
                                EnumCaseParameterSyntax(
                                    firstName: parameter.resolvedName,
                                    colon: .colonToken(),
                                    type: IdentifierTypeSyntax(name: .identifier("Any"))
                                )
                            }
                        }
                    })
                )
            }
            
            /// The initializer built from the modifier function signature.
            /// A decoder will be created based on this by the `ASTDecodable` macro.
            let initializer = InitializerDeclSyntax(
                attributes: availability,
                signature: modifier.signature.with(\.returnClause, nil)
            ) {
                InfixOperatorExprSyntax(
                    leftOperand: MemberAccessExprSyntax(base: DeclReferenceExprSyntax(baseName: .identifier("self")), name: .identifier("__clause")),
                    operator: AssignmentExprSyntax(),
                    rightOperand: modifier.signature.parameterClause.parameters.isEmpty
                        ? ExprSyntax(MemberAccessExprSyntax(name: .identifier("_\(offset)")))
                        : ExprSyntax(
                            FunctionCallExprSyntax(
                                calledExpression: MemberAccessExprSyntax(name: .identifier("_\(offset)")),
                                leftParen: .leftParenToken(),
                                rightParen: .rightParenToken()
                            ) {
                                for parameter in modifier.signature.parameterClause.parameters {
                                    if parameter.type.as(MemberTypeSyntax.self)?.baseType.as(IdentifierTypeSyntax.self)?.name.text == "ChangeTracked" {
                                        // ChangeTracked<_>.Resolved should erase its generic value before storing with `.erasedToAnyEquatableEncodable()`
                                        LabeledExprSyntax(
                                            label: parameter.secondName?.text ?? parameter.firstName.text,
                                            expression: FunctionCallExprSyntax(
                                                callee: MemberAccessExprSyntax(
                                                    base: DeclReferenceExprSyntax(baseName: parameter.resolvedName),
                                                    name: .identifier("erasedToAnyEquatableEncodable")
                                                )
                                            )
                                        )
                                    } else {
                                        LabeledExprSyntax(
                                            label: parameter.secondName?.text ?? parameter.firstName.text,
                                            expression: DeclReferenceExprSyntax(baseName: parameter.resolvedName)
                                        )
                                    }
                                }
                            }
                        )
                )
            }
            
            /// The case that handles this signature's enum case in the `body(content:)` function.
            let bodyBlock = SwitchCaseSyntax(label: .case(SwitchCaseLabelSyntax {
                SwitchCaseItemSyntax(
                    pattern: modifier.signature.parameterClause.parameters.isEmpty
                        ? PatternSyntax(ExpressionPatternSyntax(expression: MemberAccessExprSyntax(name: .identifier("_\(offset)"))))
                        : PatternSyntax(ValueBindingPatternSyntax(
                            bindingSpecifier: .keyword(.let),
                            pattern: ExpressionPatternSyntax(
                                expression: FunctionCallExprSyntax(
                                    calledExpression: MemberAccessExprSyntax(name: .identifier("_\(offset)")),
                                    leftParen: .leftParenToken(),
                                    rightParen: .rightParenToken()
                                ) {
                                    for parameter in modifier.signature.parameterClause.parameters {
                                        LabeledExprSyntax(
                                            label: parameter.secondName?.text ?? parameter.firstName.text,
                                            expression: PatternExprSyntax(pattern: IdentifierPatternSyntax(identifier: parameter.resolvedName))
                                        )
                                    }
                                }
                            )
                        ))
                )
            })) {
                if usesGestureState {
                    // shadow the context to inject the gesture state
                    // let __context = self.__context.withGestureState(___gestureState)
                    VariableDeclSyntax(
                        .let,
                        name: PatternSyntax(IdentifierPatternSyntax(identifier: .identifier("__context"))),
                        initializer: InitializerClauseSyntax(value: FunctionCallExprSyntax(
                            callee: MemberAccessExprSyntax(
                                base: MemberAccessExprSyntax(
                                    base: DeclReferenceExprSyntax(baseName: .identifier("self")),
                                    name: .identifier("__context")
                                ),
                                name: .identifier("withGestureState")
                            )
                        ) {
                            LabeledExprSyntax(expression: DeclReferenceExprSyntax(baseName: .identifier("___gestureState")))
                        })
                    )
                }
                // apply the modifier to `content`.
                let modifiedContent = FunctionCallExprSyntax(
                    calledExpression: MemberAccessExprSyntax(
                        base: DeclReferenceExprSyntax(baseName: .identifier("__content")),
                        declName: DeclReferenceExprSyntax(baseName: modifier.name)
                    ),
                    leftParen: .leftParenToken(),
                    rightParen: .rightParenToken()
                ) {
                    for parameter in modifier.signature.parameterClause.parameters {
                        let expression: ExprSyntax = parameter.resolvedExpr()
                        switch parameter.firstName.tokenKind {
                        case .wildcard:
                            LabeledExprSyntax(expression: expression)
                        default:
                            LabeledExprSyntax(
                                label: parameter.firstName.text,
                                expression: expression
                            )
                        }
                    }
                }
                
                availability.makeOSCheck {
                    // check availability at runtime
                    availability.makeRuntimeOSCheck {
                        if usesGestureState {
                            FunctionCallExprSyntax(
                                callee: MemberAccessExprSyntax(
                                    base: modifiedContent,
                                    declName: DeclReferenceExprSyntax(baseName: .identifier("environment"))
                                )
                            ) {
                                LabeledExprSyntax(expression: KeyPathExprSyntax(components: KeyPathComponentListSyntax {
                                    KeyPathComponentSyntax(period: .periodToken(), component: .property(KeyPathPropertyComponentSyntax(declName: DeclReferenceExprSyntax(baseName: .identifier("gestureState")))))
                                }))
                                LabeledExprSyntax(expression: DeclReferenceExprSyntax(baseName: .identifier("___gestureState")))
                            }
                        } else {
                            modifiedContent
                        }
                    } elseBody: {
                        ExprSyntax(DeclReferenceExprSyntax(baseName: .identifier("__content")))
                    }
                }
            }
            
            if var existing = modifiers[modifier.name.text] {
                // add a case to the switch in `body(content:)`
                var bodyFunctionDecl = existing.memberBlock.members.first!.decl.as(FunctionDeclSyntax.self)!
                guard case let .expr(expr) = bodyFunctionDecl.body!.statements.first!.item,
                      var switchExpr = expr.as(SwitchExprSyntax.self)
                else { continue }
                switchExpr.cases.append(.switchCase(bodyBlock))
                bodyFunctionDecl.body!.statements[bodyFunctionDecl.body!.statements.startIndex] = CodeBlockItemSyntax(item: .expr(ExprSyntax(switchExpr)))
                
                existing.memberBlock.members[existing.memberBlock.members.startIndex] = MemberBlockItemSyntax(decl: bodyFunctionDecl)
                
                let enumDeclIndex = existing.memberBlock.members.firstIndex(where: { $0.decl.is(EnumDeclSyntax.self) })!
                var enumDecl = existing.memberBlock.members[enumDeclIndex].decl.as(EnumDeclSyntax.self)!
                enumDecl.memberBlock.members.append(MemberBlockItemSyntax(decl: enumCase))
                existing.memberBlock.members[enumDeclIndex] = MemberBlockItemSyntax(decl: enumDecl)
                
                existing.memberBlock.members.append(contentsOf: availability.makeOSCheck {
                    initializer
                })
                
                modifiers[modifier.name.text] = existing
            } else {
                modifiers[modifier.name.text] = StructDeclSyntax(
                    attributes: AttributeListSyntax {
                        AttributeSyntax(TypeSyntax(IdentifierTypeSyntax(name: .identifier("ASTDecodable")))) {
                            LabeledExprSyntax(expression: StringLiteralExprSyntax(content: modifier.name.text))
                        }
                    },
                    name: TokenSyntax.identifier("_ViewModifier__\(modifier.name.text)"),
                    genericParameterClause: GenericParameterClauseSyntax {
                        GenericParameterSyntax(
                            name: .identifier("Root"),
                            colon: .colonToken(),
                            inheritedType: IdentifierTypeSyntax(name: .identifier("RootRegistry"))
                        )
                    },
                    inheritanceClause: InheritanceClauseSyntax(inheritedTypes: InheritedTypeListSyntax {
                        // SwiftUICore.ViewModifier
                        InheritedTypeSyntax(
                            type: MemberTypeSyntax(baseType: IdentifierTypeSyntax(name: .identifier("SwiftUICore")), name: .identifier("ViewModifier"))
                        )
                        // @preconcurrency Swift.Decodable
                        InheritedTypeSyntax(
                            type: AttributedTypeSyntax(
                                specifiers: TypeSpecifierListSyntax([]),
                                attributes: AttributeListSyntax([.attribute(AttributeSyntax(attributeName: IdentifierTypeSyntax(name: .identifier("preconcurrency"))))]),
                                baseType: MemberTypeSyntax(baseType: IdentifierTypeSyntax(name: .identifier("Swift")), name: .identifier("Decodable"))
                            )
                        )
                    })
                ) {
                    FunctionDeclSyntax(
                        name: .identifier("body"),
                        signature: FunctionSignatureSyntax(
                            parameterClause: FunctionParameterClauseSyntax {
                                FunctionParameterSyntax(firstName: .identifier("content"), secondName: .identifier("__content"), type: IdentifierTypeSyntax(name: "Content"))
                            },
                            returnClause: ReturnClauseSyntax(
                                type: SomeOrAnyTypeSyntax(
                                    someOrAnySpecifier: .keyword(.some),
                                    constraint: MemberTypeSyntax(baseType: IdentifierTypeSyntax(name: .identifier("SwiftUICore")), name: .identifier("View"))
                                )
                            )
                        )
                    ) {
                        CodeBlockItemSyntax(item: .expr(ExprSyntax(
                            SwitchExprSyntax(subject: MemberAccessExprSyntax(base: DeclReferenceExprSyntax(baseName: .identifier("self")), name: .identifier("__clause"))) {
                                bodyBlock
                            }
                        )))
                    }
                    
                    EnumDeclSyntax(
                        name: TokenSyntax.identifier("__Clause"),
                        inheritanceClause: InheritanceClauseSyntax {
                            InheritedTypeSyntax(type: IdentifierTypeSyntax(name: .identifier("DynamicProperty")))
                        }
                    ) {
                        enumCase
                    }
                    
                    // element
                    VariableDeclSyntax(
                        attributes: AttributeListSyntax {
                            AttributeSyntax(attributeName: IdentifierTypeSyntax(name: .identifier("ObservedElement")))
                        },
                        modifiers: DeclModifierListSyntax([DeclModifierSyntax(name: .keyword(.private))]),
                        .var,
                        name: PatternSyntax(IdentifierPatternSyntax(identifier: .identifier("__element")))
                    )
                    // context
                    VariableDeclSyntax(
                        attributes: AttributeListSyntax {
                            AttributeSyntax(
                                attributeName: IdentifierTypeSyntax(
                                    name: .identifier("LiveContext"),
                                    genericArgumentClause: GenericArgumentClauseSyntax {
                                        GenericArgumentSyntax(argument: IdentifierTypeSyntax(name: .identifier("Root")))
                                    }
                                )
                            )
                        },
                        modifiers: DeclModifierListSyntax([DeclModifierSyntax(name: .keyword(.private))]),
                        .var,
                        name: PatternSyntax(IdentifierPatternSyntax(identifier: .identifier("__context")))
                    )
                    // gesture state
                    if usesGestureState {
                        VariableDeclSyntax(
                            attributes: AttributeListSyntax {
                                AttributeSyntax(
                                    attributeName: IdentifierTypeSyntax(name: .identifier("GestureState"))
                                )
                            },
                            modifiers: DeclModifierListSyntax([DeclModifierSyntax(name: .keyword(.private))]),
                            .var,
                            name: PatternSyntax(IdentifierPatternSyntax(identifier: .identifier("__gestureState"))),
                            initializer: InitializerClauseSyntax(
                                value: FunctionCallExprSyntax(callee: TypeExprSyntax(type: DictionaryTypeSyntax(
                                    key: IdentifierTypeSyntax(name: .identifier("String")),
                                    value: IdentifierTypeSyntax(name: .identifier("Any"))
                                )))
                            )
                        )
                    }
                    
                    VariableDeclSyntax(
                        modifiers: DeclModifierListSyntax([DeclModifierSyntax(name: .keyword(.private))]),
                        .let,
                        name: PatternSyntax(IdentifierPatternSyntax(identifier: .identifier("__clause"))),
                        type: TypeAnnotationSyntax(type: IdentifierTypeSyntax(name: .identifier("__Clause")))
                    )
                    
                    availability.makeOSCheck {
                        initializer
                    }
                }
            }
        }
        
        return .visitChildren
    }
}
