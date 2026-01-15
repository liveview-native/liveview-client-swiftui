import SwiftUI
import SwiftSyntax

/// Modifier for setting the default scroll anchor.
///
/// Usage:
/// ```html
/// <scrollview modifiers="defaultScrollAnchor(.top)">...</scrollview>
/// <scrollview modifiers="defaultScrollAnchor(.center)">...</scrollview>
/// <scrollview modifiers="defaultScrollAnchor(.bottom)">...</scrollview>
/// ```
#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public enum DefaultScrollAnchorModifier<Library: ElementLibrary>: @unchecked Sendable {
    case defaultScrollAnchor(UnitPoint?)
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DefaultScrollAnchorModifier: RuntimeViewModifier {
    public static var baseName: String { "defaultScrollAnchor" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let anchor = syntax.arguments.first.flatMap({ UnitPoint(syntax: $0.expression) })
        self = .defaultScrollAnchor(anchor)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .defaultScrollAnchor(let anchor):
            _content.defaultScrollAnchor(anchor)
        }
    }
}
#endif
