//
//  ValueResolution.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/29/25.
//

import SwiftSyntax

public extension FunctionParameterSyntax {
    /// Checks if this parameter is augmented with the `@ViewBuilder` result builder.
    var isViewBuilder: Bool {
        return attributes.contains(where: {
            switch $0 {
            case let .attribute(attribute):
                if let memberType = attribute.attributeName.as(MemberTypeSyntax.self) {
                    // @SwiftUICore.ViewBuilder
                    return memberType.baseType.as(IdentifierTypeSyntax.self)?.name.text == "SwiftUICore"
                        && memberType.name.text == "ViewBuilder"
                } else if let type = attribute.attributeName.as(IdentifierTypeSyntax.self) {
                    // @ViewBuilder
                    return type.name.text == "ViewBuilder"
                } else {
                    return false
                }
            default:
                return false
            }
        })
    }
    
    /// Wraps this parameter's type with `AttributeReference<_>`.
    func makeAttributeReference() -> Self {
        return with(\.type, TypeSyntax(
            IdentifierTypeSyntax(
                name: .identifier("AttributeReference"),
                genericArgumentClause: GenericArgumentClauseSyntax {
                    GenericArgumentSyntax(argument: self.type)
                }
            )
        ))
        .with(\.defaultValue, self.defaultValue.flatMap({ defaultValue in
            InitializerClauseSyntax(value: FunctionCallExprSyntax(
                calledExpression: MemberAccessExprSyntax(name: .identifier("constant")),
                leftParen: .leftParenToken(),
                rightParen: .rightParenToken()
            ) {
                LabeledExprSyntax(expression: defaultValue.value)
            })
        }))
    }
    
    /// The name used in code blocks to reference this parameter.
    /// This is typically the `secondName` if it exists.
    ///
    /// Parameters with a wildcard `secondName` are renamed to `__wildcard`.
    ///
    /// ```
    /// func a(_: A) {}
    /// ```
    ///
    /// would become:
    ///
    /// ```
    /// func a(_ __wildcard: A) {}
    /// ```
    var resolvedName: TokenSyntax {
        if let secondName {
            if secondName.tokenKind == .wildcard {
                return TokenSyntax.identifier("__wildcard")
            } else {
                return secondName
            }
        } else {
            return firstName
        }
    }
    
    /// Creates an `ExprSyntax` to resolve the value of this parameter.
    ///
    /// The values `__element` and `__context` will be used to resolve the parameter.
    ///
    /// The function `resolve(on:in:)` is called on the value several times if needed.
    func resolvedExpr() -> ExprSyntax {
        // cast the value back from `Any` now that we know the type is available
        let parameterReference = TupleExprSyntax {
            LabeledExprSyntax(expression: AsExprSyntax(
                expression: DeclReferenceExprSyntax(baseName: self.resolvedName),
                questionOrExclamationMark: .exclamationMarkToken(),
                type: self.type
            ))
        }
        // AttributeReference<_>
        if let attributeReferenceType = self.type.as(IdentifierTypeSyntax.self),
           attributeReferenceType.name.text == "AttributeReference" {
            // value.resolve(on: __element, in: __context)
            var resolvedAttribute = FunctionCallExprSyntax.resolveAttributeReference(parameterReference)
            // a resolvable value should call `resolve(...)` again
            if attributeReferenceType.genericArgumentClause!.arguments.first!.argument.as(IdentifierTypeSyntax.self)?.name.text.starts(with: "StylesheetResolvable") ?? false {
                resolvedAttribute = FunctionCallExprSyntax.resolveAttributeReference(resolvedAttribute)
            }
            // InlineViewReference should call `resolve(...)` again
            if (
                attributeReferenceType.genericArgumentClause!.arguments.first!.argument.as(IdentifierTypeSyntax.self)
                    ?? attributeReferenceType.genericArgumentClause!.arguments.first!.argument.as(OptionalTypeSyntax.self)?.wrappedType.as(IdentifierTypeSyntax.self)
               )?.name.text == "InlineViewReference"
            {
                resolvedAttribute = FunctionCallExprSyntax.resolveAttributeReference(resolvedAttribute)
            }
            if attributeReferenceType.genericArgumentClause!.arguments.first!.argument.as(IdentifierTypeSyntax.self)?.name.text == "ViewReference" {
                // `ViewReference` should be converted into a closure that resolves the `ViewReference`.
                return ExprSyntax(
                    ClosureExprSyntax {
                        CodeBlockItemSyntax(item: .expr(
                            ExprSyntax(FunctionCallExprSyntax.resolveAttributeReference(resolvedAttribute))
                        ))
                    }
                )
            } else if attributeReferenceType.genericArgumentClause!.arguments.first!.argument.as(IdentifierTypeSyntax.self)?.name.text == "Event" {
                // `Event` should be converted into a closure that calls the `Event` as a function.
                // { resolvedValue() }
                return ExprSyntax(
                    ClosureExprSyntax {
                        CodeBlockItemSyntax(item: .expr(
                            ExprSyntax(FunctionCallExprSyntax(
                                calledExpression: resolvedAttribute,
                                leftParen: .leftParenToken(),
                                rightParen: .rightParenToken()
                            ) {
                                // no arguments
                            })
                        ))
                    }
                )
            } else {
                return ExprSyntax(resolvedAttribute)
            }
        } else if self.type.isResolvableType {
            // value.resolve(on: __element, in: __context)
            return ExprSyntax(FunctionCallExprSyntax.resolveAttributeReference(parameterReference))
        } else {
            // value
            return ExprSyntax(parameterReference)
        }
    }
}

public extension EnumCaseParameterSyntax {
    /// The name used in code blocks to reference this parameter.
    /// This is typically the `secondName` if it exists.
    ///
    /// See ``FunctionParameterSyntax/resolvedName`` for more details.
    var resolvedName: TokenSyntax {
        if let secondName {
            if secondName.tokenKind == .wildcard {
                return TokenSyntax.identifier("__wildcard")
            } else {
                return secondName
            }
        } else {
            return firstName ?? .identifier("__wildcard")
        }
    }
}

public extension FunctionCallExprSyntax {
    /// Creates a `FunctionCallExprSyntax` that calls `resolve(on:in:)` with `__element` and `__context` arguments.
    static func resolveAttributeReference(_ calledExpression: some ExprSyntaxProtocol) -> Self {
        FunctionCallExprSyntax(
            calledExpression: MemberAccessExprSyntax(base: calledExpression, name: .identifier("resolve")),
            leftParen: .leftParenToken(),
            rightParen: .rightParenToken()
        ) {
            LabeledExprSyntax(label: "on", expression: DeclReferenceExprSyntax(baseName: .identifier("__element")))
            LabeledExprSyntax(label: "in", expression: DeclReferenceExprSyntax(baseName: .identifier("__context")))
        }
    }
}
