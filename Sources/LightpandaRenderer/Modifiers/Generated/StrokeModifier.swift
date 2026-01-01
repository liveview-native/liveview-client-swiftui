import SwiftUI
import SwiftSyntax

/// Shape-specific modifier for stroke().
/// This modifier only works on Shape types, not generic Views.
public enum StrokeModifier: @unchecked Sendable {
    case strokeWithStyle(AnyShapeStyle, style: SwiftUICore.StrokeStyle, antialiased: Swift.Bool)
    case strokeWithLineWidth(AnyShapeStyle, lineWidth: CoreFoundation.CGFloat, antialiased: Swift.Bool)
}

extension StrokeModifier: RuntimeShapeModifier {
    public static var baseName: String { "stroke" }

    public init(syntax: FunctionCallExprSyntax) throws {
        var errors: [Error] = []
        
        // Try style variant first
        do {
            guard let value0 = (syntax.arguments.count > 0 ? syntax.arguments[0] : nil).flatMap({ AnyShapeStyle(syntax: $0.expression) }) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "StrokeModifier", argument: "content")
            }
            guard let style = syntax.argument(named: "style").flatMap({ SwiftUICore.StrokeStyle(syntax: $0.expression) }) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "StrokeModifier", argument: "style")
            }
            let antialiased: Swift.Bool = syntax.argument(named: "antialiased").flatMap({ Swift.Bool(syntax: $0.expression) }) ?? true
            self = .strokeWithStyle(value0, style: style, antialiased: antialiased)
            return
        } catch {
            errors.append(error)
        }
        
        // Try lineWidth variant
        do {
            guard let value0 = (syntax.arguments.count > 0 ? syntax.arguments[0] : nil).flatMap({ AnyShapeStyle(syntax: $0.expression) }) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "StrokeModifier", argument: "content")
            }
            let lineWidth: CoreFoundation.CGFloat = syntax.argument(named: "lineWidth").flatMap({ CoreFoundation.CGFloat(syntax: $0.expression) }) ?? 1
            let antialiased: Swift.Bool = syntax.argument(named: "antialiased").flatMap({ Swift.Bool(syntax: $0.expression) }) ?? true
            self = .strokeWithLineWidth(value0, lineWidth: lineWidth, antialiased: antialiased)
            return
        } catch {
            errors.append(error)
        }
        
        throw ModifierParseError.noMatchingVariant(modifier: "StrokeModifier", errors: errors)
    }

    public func shapeBody<S: SwiftUI.Shape>(content: S) -> ShapeModifierResult {
        switch self {
        case .strokeWithStyle(let shapeStyle, style: let style, antialiased: let antialiased):
            return .view(AnyView(content.stroke(shapeStyle, style: style, antialiased: antialiased)))
        case .strokeWithLineWidth(let shapeStyle, lineWidth: let lineWidth, antialiased: let antialiased):
            return .view(AnyView(content.stroke(shapeStyle, lineWidth: lineWidth, antialiased: antialiased)))
        }
    }
}