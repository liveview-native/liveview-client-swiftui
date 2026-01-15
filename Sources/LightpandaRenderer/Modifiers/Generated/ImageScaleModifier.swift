import SwiftUI
import SwiftSyntax

/// Modifier for setting image scale.
///
/// Usage:
/// ```html
/// <image systemname="star.fill" modifiers="imageScale(.large)">
/// <image systemname="star.fill" modifiers="imageScale(.small)">
/// ```
public enum ImageScaleModifier<Library: ElementLibrary>: @unchecked Sendable {
    case imageScale(Image.Scale)
}

extension ImageScaleModifier: RuntimeViewModifier {
    public static var baseName: String { "imageScale" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let scale = syntax.arguments.first.flatMap({ Image.Scale(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "ImageScaleModifier", argument: "scale")
        }
        self = .imageScale(scale)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .imageScale(let scale):
            _content.imageScale(scale)
        }
    }
}
