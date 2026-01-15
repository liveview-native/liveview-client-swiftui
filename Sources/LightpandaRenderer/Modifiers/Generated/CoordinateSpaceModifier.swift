import SwiftUI
import SwiftSyntax

/// Modifier for setting the coordinate space name.
///
/// Usage:
/// ```html
/// <scrollview modifiers="coordinateSpace(.scrollView)">...</scrollview>
/// ```
#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public enum CoordinateSpaceModifier<Library: ElementLibrary>: @unchecked Sendable {
    case coordinateSpace(NamedCoordinateSpace)
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension CoordinateSpaceModifier: RuntimeViewModifier {
    public static var baseName: String { "coordinateSpace" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let space = syntax.arguments.first.flatMap({ NamedCoordinateSpace(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "CoordinateSpaceModifier", argument: "name")
        }
        self = .coordinateSpace(space)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .coordinateSpace(let space):
            _content.coordinateSpace(space)
        }
    }
}
#endif
