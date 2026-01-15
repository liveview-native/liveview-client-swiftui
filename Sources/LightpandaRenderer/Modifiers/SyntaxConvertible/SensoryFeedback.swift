import SwiftUI
import SwiftSyntax

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SensoryFeedback: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Handle member access like .success, .warning, etc.
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self) {
            let name = memberAccess.declName.baseName.text

            switch name {
            // Standard feedback types
            case "success": self = .success
            case "warning": self = .warning
            case "error": self = .error
            case "selection": self = .selection
            case "increase": self = .increase
            case "decrease": self = .decrease
            case "start": self = .start
            case "stop": self = .stop
            case "alignment": self = .alignment
            case "levelChange": self = .levelChange
            case "impact": self = .impact
            case "pathComplete": self = .pathComplete
            default: return nil
            }
            return
        }

        // Handle function calls like .impact(flexibility:intensity:) or .impact(weight:intensity:)
        if let functionCall = syntax.as(FunctionCallExprSyntax.self),
           let memberAccess = functionCall.calledExpression.as(MemberAccessExprSyntax.self) {
            let name = memberAccess.declName.baseName.text

            switch name {
            case "impact":
                // Parse .impact(flexibility:intensity:) or .impact(weight:intensity:)
                if let flexibilityArg = functionCall.argument(named: "flexibility"),
                   let flexibility = SensoryFeedback.Flexibility(syntax: flexibilityArg.expression) {
                    let intensity = functionCall.argument(named: "intensity")
                        .flatMap({ Double(syntax: $0.expression) }) ?? 1.0
                    self = .impact(flexibility: flexibility, intensity: intensity)
                    return
                }
                if let weightArg = functionCall.argument(named: "weight"),
                   let weight = SensoryFeedback.Weight(syntax: weightArg.expression) {
                    let intensity = functionCall.argument(named: "intensity")
                        .flatMap({ Double(syntax: $0.expression) }) ?? 1.0
                    self = .impact(weight: weight, intensity: intensity)
                    return
                }
                // Plain .impact() with no args
                self = .impact
                return
            default:
                return nil
            }
        }

        return nil
    }
}

// MARK: - SensoryFeedback.Flexibility

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SensoryFeedback.Flexibility: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "rigid": self = .rigid
        case "solid": self = .solid
        case "soft": self = .soft
        default: return nil
        }
    }
}

// MARK: - SensoryFeedback.Weight

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SensoryFeedback.Weight: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "light": self = .light
        case "medium": self = .medium
        case "heavy": self = .heavy
        default: return nil
        }
    }
}
