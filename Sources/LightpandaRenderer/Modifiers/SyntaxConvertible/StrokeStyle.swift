import SwiftUI
import SwiftSyntax

extension StrokeStyle: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let functionCall = syntax.as(FunctionCallExprSyntax.self) else {
            return nil
        }
        
        // Parse StrokeStyle(lineWidth:lineCap:lineJoin:miterLimit:dash:dashPhase:)
        let lineWidth: CGFloat = functionCall.argument(named: "lineWidth").flatMap({ CGFloat(syntax: $0.expression) }) ?? 1
        let lineCap: CGLineCap = functionCall.argument(named: "lineCap").flatMap({ CGLineCap(syntax: $0.expression) }) ?? .butt
        let lineJoin: CGLineJoin = functionCall.argument(named: "lineJoin").flatMap({ CGLineJoin(syntax: $0.expression) }) ?? .miter
        let miterLimit: CGFloat = functionCall.argument(named: "miterLimit").flatMap({ CGFloat(syntax: $0.expression) }) ?? 10
        let dashPhase: CGFloat = functionCall.argument(named: "dashPhase").flatMap({ CGFloat(syntax: $0.expression) }) ?? 0
        
        // Parse dash array
        var dash: [CGFloat] = []
        if let dashArg = functionCall.argument(named: "dash"),
           let arrayExpr = dashArg.expression.as(ArrayExprSyntax.self) {
            dash = arrayExpr.elements.compactMap { CGFloat(syntax: $0.expression) }
        }
        
        self.init(lineWidth: lineWidth, lineCap: lineCap, lineJoin: lineJoin, miterLimit: miterLimit, dash: dash, dashPhase: dashPhase)
    }
}

extension CGLineCap: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self) {
            switch memberAccess.declName.baseName.text {
            case "butt":
                self = .butt
            case "round":
                self = .round
            case "square":
                self = .square
            default:
                return nil
            }
        } else {
            return nil
        }
    }
}

extension CGLineJoin: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self) {
            switch memberAccess.declName.baseName.text {
            case "miter":
                self = .miter
            case "round":
                self = .round
            case "bevel":
                self = .bevel
            default:
                return nil
            }
        } else {
            return nil
        }
    }
}
