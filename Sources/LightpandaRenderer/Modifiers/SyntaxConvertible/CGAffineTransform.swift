//
//  CGAffineTransform.swift
//  LightpandaRenderer
//

import SwiftUI
import SwiftSyntax

extension CGAffineTransform: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Handle CGAffineTransform(...) constructor calls
        if let functionCall = syntax.as(FunctionCallExprSyntax.self) {
            let args = functionCall.arguments
            
            // CGAffineTransform(rotationAngle: CGFloat)
            if let rotationArg = args.first(where: { $0.label?.text == "rotationAngle" }),
               let angle = CGFloat(syntax: rotationArg.expression) {
                self = CGAffineTransform(rotationAngle: angle)
                return
            }
            
            // CGAffineTransform(scaleX: CGFloat, y: CGFloat)
            if let scaleXArg = args.first(where: { $0.label?.text == "scaleX" }),
               let yArg = args.first(where: { $0.label?.text == "y" }),
               let scaleX = CGFloat(syntax: scaleXArg.expression),
               let y = CGFloat(syntax: yArg.expression) {
                self = CGAffineTransform(scaleX: scaleX, y: y)
                return
            }
            
            // CGAffineTransform(translationX: CGFloat, y: CGFloat)
            if let translationXArg = args.first(where: { $0.label?.text == "translationX" }),
               let yArg = args.first(where: { $0.label?.text == "y" }),
               let translationX = CGFloat(syntax: translationXArg.expression),
               let y = CGFloat(syntax: yArg.expression) {
                self = CGAffineTransform(translationX: translationX, y: y)
                return
            }
            
            // CGAffineTransform(a: CGFloat, b: CGFloat, c: CGFloat, d: CGFloat, tx: CGFloat, ty: CGFloat)
            if let aArg = args.first(where: { $0.label?.text == "a" }),
               let bArg = args.first(where: { $0.label?.text == "b" }),
               let cArg = args.first(where: { $0.label?.text == "c" }),
               let dArg = args.first(where: { $0.label?.text == "d" }),
               let txArg = args.first(where: { $0.label?.text == "tx" }),
               let tyArg = args.first(where: { $0.label?.text == "ty" }),
               let a = CGFloat(syntax: aArg.expression),
               let b = CGFloat(syntax: bArg.expression),
               let c = CGFloat(syntax: cArg.expression),
               let d = CGFloat(syntax: dArg.expression),
               let tx = CGFloat(syntax: txArg.expression),
               let ty = CGFloat(syntax: tyArg.expression) {
                self = CGAffineTransform(a: a, b: b, c: c, d: d, tx: tx, ty: ty)
                return
            }
            
            // CGAffineTransform.identity
            if functionCall.calledExpression.description.contains("identity") {
                self = .identity
                return
            }
        }
        
        // Handle .identity
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self),
           memberAccess.declName.baseName.text == "identity" {
            self = .identity
            return
        }
        
        return nil
    }
}
