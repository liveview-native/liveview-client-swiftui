import SwiftUI
import SwiftSyntax

/// Modifier for setting the button border shape.
///
/// Usage:
/// ```html
/// <button modifiers="buttonBorderShape(.capsule)">Capsule</button>
/// <button modifiers="buttonBorderShape(.roundedRectangle)">Rounded</button>
/// <button modifiers="buttonBorderShape(.automatic)">Auto</button>
/// ```
public enum ButtonBorderShapeModifier<Library: ElementLibrary>: @unchecked Sendable {
    case buttonBorderShape(ButtonBorderShape)
}

extension ButtonBorderShapeModifier: RuntimeViewModifier {
    public static var baseName: String { "buttonBorderShape" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let shape = syntax.arguments.first.flatMap({ ButtonBorderShape(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "ButtonBorderShapeModifier", argument: "shape")
        }
        self = .buttonBorderShape(shape)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .buttonBorderShape(let shape):
            _content.buttonBorderShape(shape)
        }
    }
}
