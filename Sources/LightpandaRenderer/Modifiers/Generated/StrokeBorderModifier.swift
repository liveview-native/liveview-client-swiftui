import SwiftUI
import SwiftSyntax

/// Shape-specific modifier for strokeBorder().
/// This modifier only works on InsettableShape types, not generic Views.
public enum StrokeBorderModifier: @unchecked Sendable {
    case strokeBorderWithStyle(AnyShapeStyle, style: SwiftUICore.StrokeStyle, antialiased: Swift.Bool)
    case strokeBorderWithLineWidth(AnyShapeStyle, lineWidth: CoreFoundation.CGFloat, antialiased: Swift.Bool)
}

extension StrokeBorderModifier: RuntimeShapeModifier {
    public static var baseName: String { "strokeBorder" }

    public init(syntax: FunctionCallExprSyntax) throws {
        var errors: [Error] = []
        
        // Try style variant first
        do {
            let value0: AnyShapeStyle = (syntax.arguments.count > 0 ? syntax.arguments[0] : nil).flatMap({ AnyShapeStyle(syntax: $0.expression) }) ?? AnyShapeStyle(.foreground)
            guard let style = syntax.argument(named: "style").flatMap({ SwiftUICore.StrokeStyle(syntax: $0.expression) }) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "StrokeBorderModifier", argument: "style")
            }
            let antialiased: Swift.Bool = syntax.argument(named: "antialiased").flatMap({ Swift.Bool(syntax: $0.expression) }) ?? true
            self = .strokeBorderWithStyle(value0, style: style, antialiased: antialiased)
            return
        } catch {
            errors.append(error)
        }
        
        // Try lineWidth variant
        do {
            let value0: AnyShapeStyle = (syntax.arguments.count > 0 ? syntax.arguments[0] : nil).flatMap({ AnyShapeStyle(syntax: $0.expression) }) ?? AnyShapeStyle(.foreground)
            let lineWidth: CoreFoundation.CGFloat = syntax.argument(named: "lineWidth").flatMap({ CoreFoundation.CGFloat(syntax: $0.expression) }) ?? 1
            let antialiased: Swift.Bool = syntax.argument(named: "antialiased").flatMap({ Swift.Bool(syntax: $0.expression) }) ?? true
            self = .strokeBorderWithLineWidth(value0, lineWidth: lineWidth, antialiased: antialiased)
            return
        } catch {
            errors.append(error)
        }
        
        throw ModifierParseError.noMatchingVariant(modifier: "StrokeBorderModifier", errors: errors)
    }

    public func shapeBody<S: SwiftUI.Shape>(content: S) -> ShapeModifierResult {
        // strokeBorder requires InsettableShape - use stroke as fallback
        switch self {
        case .strokeBorderWithStyle(let shapeStyle, style: let style, antialiased: let antialiased):
            // strokeBorder insets the stroke, stroke does not - using stroke as it works on all shapes
            return .view(AnyView(content.stroke(shapeStyle, style: style, antialiased: antialiased)))
        case .strokeBorderWithLineWidth(let shapeStyle, lineWidth: let lineWidth, antialiased: let antialiased):
            return .view(AnyView(content.stroke(shapeStyle, lineWidth: lineWidth, antialiased: antialiased)))
        }
    }
}