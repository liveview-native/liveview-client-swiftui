import SwiftUI
import SwiftSyntax

/// Modifier for applying 3D rotation effects to views.
///
/// Usage:
/// ```html
/// <vstack modifiers="rotation3DEffect(.degrees(45), axis: (x: 1, y: 0, z: 0))">
/// <vstack modifiers="rotation3DEffect(.radians(0.5), axis: (x: 0, y: 1, z: 0), anchor: .center)">
/// <vstack modifiers="rotation3DEffect(.degrees(30), axis: (x: 1, y: 1, z: 0), perspective: 0.5)">
/// ```
public enum Rotation3DEffectModifier<Library: ElementLibrary>: @unchecked Sendable {
    case rotation3DEffect(SwiftUICore.Angle, axis: (x: CoreFoundation.CGFloat, y: CoreFoundation.CGFloat, z: CoreFoundation.CGFloat), anchor: SwiftUICore.UnitPoint, anchorZ: CoreFoundation.CGFloat, perspective: CoreFoundation.CGFloat)
}

extension Rotation3DEffectModifier: RuntimeViewModifier {
    public static var baseName: String { "rotation3DEffect" }

    public init(syntax: FunctionCallExprSyntax) throws {
        var errors: [Error] = []
        do {
            guard let value0 = (syntax.arguments.count > 0 ? syntax.arguments[0] : nil).flatMap({ SwiftUICore.Angle(syntax: $0.expression) }) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "Rotation3DEffectModifier", argument: "angle")
            }
            guard let axis = syntax.argument(named: "axis").flatMap({ Self.parseAxisTuple(syntax: $0.expression) }) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "Rotation3DEffectModifier", argument: "axis")
            }
            let anchor: SwiftUICore.UnitPoint = syntax.argument(named: "anchor").flatMap({ SwiftUICore.UnitPoint(syntax: $0.expression) }) ?? .center
            let anchorZ: CoreFoundation.CGFloat = syntax.argument(named: "anchorZ").flatMap({ CoreFoundation.CGFloat(syntax: $0.expression) }) ?? 0
            let perspective: CoreFoundation.CGFloat = syntax.argument(named: "perspective").flatMap({ CoreFoundation.CGFloat(syntax: $0.expression) }) ?? 1
            self = .rotation3DEffect(value0, axis: axis, anchor: anchor, anchorZ: anchorZ, perspective: perspective)
            return
        } catch {
            errors.append(error)
        }
        throw ModifierParseError.noMatchingVariant(modifier: "Rotation3DEffectModifier", errors: errors)
    }

    /// Parse a tuple expression like (x: 1, y: 0, z: 0)
    private static func parseAxisTuple(syntax: some SyntaxProtocol) -> (x: CGFloat, y: CGFloat, z: CGFloat)? {
        // Handle tuple expression syntax: (x: 1, y: 0, z: 0)
        if let tuple = syntax.as(TupleExprSyntax.self) {
            var x: CGFloat?
            var y: CGFloat?
            var z: CGFloat?

            for element in tuple.elements {
                guard let label = element.label?.text else { continue }
                switch label {
                case "x":
                    x = CGFloat(syntax: element.expression)
                case "y":
                    y = CGFloat(syntax: element.expression)
                case "z":
                    z = CGFloat(syntax: element.expression)
                default:
                    break
                }
            }

            if let x = x, let y = y, let z = z {
                return (x: x, y: y, z: z)
            }
        }
        return nil
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .rotation3DEffect(let value0, axis: let axis, anchor: let anchor, anchorZ: let anchorZ, perspective: let perspective):
            _content.rotation3DEffect(value0, axis: axis, anchor: anchor, anchorZ: anchorZ, perspective: perspective)
        }
    }
}