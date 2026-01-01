import SwiftUI
import SwiftSyntax

extension AnyShape: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let shape = Self._parse(syntax: syntax) else { return nil }
        self = shape
    }
    
    private static func _parse(syntax: some SyntaxProtocol) -> AnyShape? {
        // Handle simple member access (e.g., .circle, .rect)
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self),
           memberAccess.base == nil {
            switch memberAccess.declName.baseName.text {
            case "buttonBorder":
                return AnyShape(.buttonBorder)
            case "capsule":
                return AnyShape(.capsule)
            case "circle":
                return AnyShape(.circle)
            case "containerRelative":
                return AnyShape(.containerRelative)
            case "ellipse":
                return AnyShape(.ellipse)
            case "rect":
                return AnyShape(.rect)
            default:
                return nil
            }
        }
        
        // Handle function calls (e.g., .rect(cornerRadius: 10), .capsule(style: .continuous))
        if let functionCall = syntax.as(FunctionCallExprSyntax.self),
           let memberAccess = functionCall.calledExpression.as(MemberAccessExprSyntax.self),
           memberAccess.base == nil {
            let functionName = memberAccess.declName.baseName.text
            
            switch functionName {
            case "capsule":
                // .capsule(style: RoundedCornerStyle)
                let style: RoundedCornerStyle = functionCall.argument(named: "style", default: .circular)
                return AnyShape(Capsule(style: style))
                
            case "rect":
                // Try different rect overloads
                return parseRect(from: functionCall)
                
            default:
                return nil
            }
        }
        
        return nil
    }
    
    private static func parseRect(from functionCall: FunctionCallExprSyntax) -> AnyShape? {
        let args = functionCall.arguments
        
        // Check which arguments are present to determine the overload
        let hasCornerRadius = args.contains { $0.label?.text == "cornerRadius" }
        let hasCornerSize = args.contains { $0.label?.text == "cornerSize" }
        let hasCornerRadii = args.contains { $0.label?.text == "cornerRadii" }
        let hasTopLeadingRadius = args.contains { $0.label?.text == "topLeadingRadius" }
        
        let style: RoundedCornerStyle = functionCall.argument(named: "style", default: .circular)
        
        if hasCornerRadius {
            // .rect(cornerRadius: CGFloat, style: RoundedCornerStyle)
            guard let cornerRadius: CGFloat = functionCall.argument(named: "cornerRadius") else {
                return nil
            }
            return AnyShape(RoundedRectangle(cornerRadius: cornerRadius, style: style))
        }
        
        if hasCornerSize {
            // .rect(cornerSize: CGSize, style: RoundedCornerStyle)
            guard let cornerSize: CGSize = functionCall.argument(named: "cornerSize") else {
                return nil
            }
            return AnyShape(RoundedRectangle(cornerSize: cornerSize, style: style))
        }
        
        if hasCornerRadii {
            // .rect(cornerRadii: RectangleCornerRadii, style: RoundedCornerStyle)
            guard let cornerRadii: RectangleCornerRadii = functionCall.argument(named: "cornerRadii") else {
                return nil
            }
            return AnyShape(UnevenRoundedRectangle(cornerRadii: cornerRadii, style: style))
        }
        
        if hasTopLeadingRadius {
            // .rect(topLeadingRadius:, bottomLeadingRadius:, bottomTrailingRadius:, topTrailingRadius:, style:)
            let topLeading: CGFloat = functionCall.argument(named: "topLeadingRadius") ?? 0
            let bottomLeading: CGFloat = functionCall.argument(named: "bottomLeadingRadius") ?? 0
            let bottomTrailing: CGFloat = functionCall.argument(named: "bottomTrailingRadius") ?? 0
            let topTrailing: CGFloat = functionCall.argument(named: "topTrailingRadius") ?? 0
            
            let cornerRadii = RectangleCornerRadii(
                topLeading: topLeading,
                bottomLeading: bottomLeading,
                bottomTrailing: bottomTrailing,
                topTrailing: topTrailing
            )
            return AnyShape(UnevenRoundedRectangle(cornerRadii: cornerRadii, style: style))
        }
        
        // No recognized arguments, return plain rect
        return AnyShape(.rect)
    }
}
