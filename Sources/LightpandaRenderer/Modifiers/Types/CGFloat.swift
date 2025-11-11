import SwiftUI
import SwiftSyntax

extension CGFloat {
    init?(_ expr: ExprSyntax) {
        let trimmed = expr.trimmedDescription
        
        // Handle integer literals
        if let intValue = Int(trimmed) {
            self = CGFloat(intValue)
        }
        
        // Handle float literals
        if let doubleValue = Double(trimmed) {
            self = CGFloat(doubleValue)
        }
        
        // Handle .infinity
        if trimmed == ".infinity" || trimmed == "CGFloat.infinity" {
            self = .infinity
        }
        
        return nil
    }
}
