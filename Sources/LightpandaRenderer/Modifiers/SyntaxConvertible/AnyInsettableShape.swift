import SwiftUI
import SwiftSyntax

/// A type-erased InsettableShape that can be parsed from syntax.
///
/// Supports:
/// - Simple shapes: `.circle`, `.rect`, `.capsule`, `.ellipse`, `.buttonBorder`, `.containerRelative`
/// - Parameterized shapes: `.rect(cornerRadius: 10)`, `.capsule(style: .continuous)`
public struct AnyInsettableShape: InsettableShape, SyntaxConvertible {
    private let _path: @Sendable (CGRect) -> Path
    private let _inset: @Sendable (CGFloat) -> AnyInsettableShape

    public init<S: InsettableShape>(_ shape: S) {
        self._path = { rect in shape.path(in: rect) }
        self._inset = { amount in AnyInsettableShape(shape.inset(by: amount)) }
    }

    public func path(in rect: CGRect) -> Path {
        _path(rect)
    }

    public func inset(by amount: CGFloat) -> AnyInsettableShape {
        _inset(amount)
    }

    public init?(syntax: some SyntaxProtocol) {
        guard let shape = Self._parse(syntax: syntax) else { return nil }
        self = shape
    }

    private static func _parse(syntax: some SyntaxProtocol) -> AnyInsettableShape? {
        // Handle simple member access (e.g., .circle, .rect)
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self),
           memberAccess.base == nil {
            switch memberAccess.declName.baseName.text {
            case "buttonBorder":
                return AnyInsettableShape(.buttonBorder)
            case "capsule":
                return AnyInsettableShape(.capsule)
            case "circle":
                return AnyInsettableShape(.circle)
            case "containerRelative":
                return AnyInsettableShape(.containerRelative)
            case "ellipse":
                return AnyInsettableShape(.ellipse)
            case "rect":
                return AnyInsettableShape(.rect)
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
                return AnyInsettableShape(Capsule(style: style))

            case "rect":
                // Try different rect overloads
                return parseRect(from: functionCall)

            default:
                return nil
            }
        }

        return nil
    }

    private static func parseRect(from functionCall: FunctionCallExprSyntax) -> AnyInsettableShape? {
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
            return AnyInsettableShape(RoundedRectangle(cornerRadius: cornerRadius, style: style))
        }

        if hasCornerSize {
            // .rect(cornerSize: CGSize, style: RoundedCornerStyle)
            guard let cornerSize: CGSize = functionCall.argument(named: "cornerSize") else {
                return nil
            }
            return AnyInsettableShape(RoundedRectangle(cornerSize: cornerSize, style: style))
        }

        if hasCornerRadii {
            // .rect(cornerRadii: RectangleCornerRadii, style: RoundedCornerStyle)
            guard let cornerRadii: RectangleCornerRadii = functionCall.argument(named: "cornerRadii") else {
                return nil
            }
            return AnyInsettableShape(UnevenRoundedRectangle(cornerRadii: cornerRadii, style: style))
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
            return AnyInsettableShape(UnevenRoundedRectangle(cornerRadii: cornerRadii, style: style))
        }

        // No recognized arguments, return plain rect
        return AnyInsettableShape(.rect)
    }
}
