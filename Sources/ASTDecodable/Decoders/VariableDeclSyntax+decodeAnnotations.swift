//
//  VariableDeclSyntax+decodeAnnotations.swift
//  JSONStylesheet
//
//  Created by Carson.Katri on 10/1/24.
//

import SwiftSyntax
import SwiftSyntaxBuilder

extension VariableDeclSyntax {
    static func decodeAnnotations(
        to annotationsName: TokenSyntax,
        in containerReference: DeclReferenceExprSyntax
    ) -> Self {
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
    }
}
