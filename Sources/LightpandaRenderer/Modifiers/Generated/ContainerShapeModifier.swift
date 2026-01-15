import SwiftUI
import SwiftSyntax

/// Modifier for setting the container shape.
///
/// Usage:
/// ```html
/// <vstack modifiers="containerShape(.rect(cornerRadius: 10))">...</vstack>
/// <vstack modifiers="containerShape(.capsule)">...</vstack>
/// ```
public enum ContainerShapeModifier<Library: ElementLibrary>: @unchecked Sendable {
    case containerShape(AnyInsettableShape)
}

extension ContainerShapeModifier: RuntimeViewModifier {
    public static var baseName: String { "containerShape" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let shape = syntax.arguments.first.flatMap({ AnyInsettableShape(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "ContainerShapeModifier", argument: "shape")
        }
        self = .containerShape(shape)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .containerShape(let shape):
            _content.containerShape(shape)
        }
    }
}
