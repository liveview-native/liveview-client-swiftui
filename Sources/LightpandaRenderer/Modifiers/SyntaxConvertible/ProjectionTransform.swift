//
//  ProjectionTransform.swift
//  LightpandaRenderer
//

import SwiftUI
import SwiftSyntax

extension ProjectionTransform: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Handle ProjectionTransform(...) constructor calls
        if let functionCall = syntax.as(FunctionCallExprSyntax.self) {
            let calledExpr = functionCall.calledExpression

            // Check if this is a ProjectionTransform constructor
            let isProjectionTransform: Bool
            if let identRef = calledExpr.as(DeclReferenceExprSyntax.self) {
                isProjectionTransform = identRef.baseName.text == "ProjectionTransform"
            } else if let memberAccess = calledExpr.as(MemberAccessExprSyntax.self) {
                isProjectionTransform = memberAccess.declName.baseName.text == "ProjectionTransform"
            } else {
                isProjectionTransform = false
            }

            if isProjectionTransform {
                let args = functionCall.arguments

                // ProjectionTransform() - identity
                if args.isEmpty {
                    self = ProjectionTransform()
                    return
                }

                // ProjectionTransform(_ m: CGAffineTransform)
                if args.count == 1, args.first?.label == nil,
                   let transform = CGAffineTransform(syntax: args.first!.expression) {
                    self = ProjectionTransform(transform)
                    return
                }

                // ProjectionTransform(_ m: CATransform3D)
                // Note: CATransform3D parsing would be complex, but CGAffineTransform covers most use cases
            }
        }

        // Handle .identity member access
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self),
           memberAccess.declName.baseName.text == "identity" {
            self = ProjectionTransform()
            return
        }

        return nil
    }
}
