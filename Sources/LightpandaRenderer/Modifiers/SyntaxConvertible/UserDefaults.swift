import Foundation
import SwiftSyntax

/// Helper function to parse UserDefaults from syntax.
/// UserDefaults cannot conform to SyntaxConvertible because it's a non-final class.
public func parseUserDefaults(from syntax: some SyntaxProtocol) -> UserDefaults? {
    // Handle UserDefaults.standard
    if let memberAccess = syntax.as(MemberAccessExprSyntax.self) {
        // Check for .standard on UserDefaults
        let memberName = memberAccess.declName.baseName.text

        // If there's a base, check it's UserDefaults
        if let base = memberAccess.base {
            if let baseRef = base.as(DeclReferenceExprSyntax.self),
               baseRef.baseName.text == "UserDefaults" {
                switch memberName {
                case "standard":
                    return .standard
                default:
                    return nil
                }
            }
        } else {
            // No base, just .standard
            switch memberName {
            case "standard":
                return .standard
            default:
                return nil
            }
        }
    }

    // Handle UserDefaults(suiteName: "...")
    if let functionCall = syntax.as(FunctionCallExprSyntax.self) {
        // Check if this is a UserDefaults initializer
        let calledName: String?
        if let declRef = functionCall.calledExpression.as(DeclReferenceExprSyntax.self) {
            calledName = declRef.baseName.text
        } else if let memberAccess = functionCall.calledExpression.as(MemberAccessExprSyntax.self) {
            calledName = memberAccess.declName.baseName.text
        } else {
            calledName = nil
        }

        guard calledName == "UserDefaults" else { return nil }

        // Try UserDefaults(suiteName:)
        if let suiteNameArg = functionCall.arguments.first(where: { $0.label?.text == "suiteName" }),
           let suiteName = String(syntax: suiteNameArg.expression) {
            return UserDefaults(suiteName: suiteName)
        }

        // Try UserDefaults() - no arguments means standard
        if functionCall.arguments.isEmpty {
            return .standard
        }
    }

    return nil
}
