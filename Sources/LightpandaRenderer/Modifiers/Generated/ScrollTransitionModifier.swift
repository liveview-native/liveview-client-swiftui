import SwiftUI
import SwiftSyntax

/// Modifier for applying scroll transition effects.
///
/// Since the SwiftUI scrollTransition modifier requires a closure that cannot be parsed
/// at runtime, this modifier provides a simplified API with preset effects.
///
/// Usage:
/// ```html
/// <!-- Basic fade effect (default) -->
/// <vstack modifiers="scrollTransition()">
///   ...
/// </vstack>
///
/// <!-- Scale effect -->
/// <vstack modifiers="scrollTransition(.scale)">
///   ...
/// </vstack>
///
/// <!-- Combined opacity and scale -->
/// <vstack modifiers="scrollTransition(.opacity, .scale)">
///   ...
/// </vstack>
///
/// <!-- With configuration -->
/// <vstack modifiers="scrollTransition(.interactive)">
///   ...
/// </vstack>
///
/// <!-- With axis -->
/// <vstack modifiers="scrollTransition(.interactive, axis: .vertical)">
///   ...
/// </vstack>
/// ```
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public enum ScrollTransitionModifier<Library: ElementLibrary>: @unchecked Sendable {
    case scrollTransition(configuration: ScrollTransitionConfiguration, axis: Axis?)
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension ScrollTransitionModifier: RuntimeViewModifier {
    public static var baseName: String { "scrollTransition" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // Parse configuration (first positional argument or default to .interactive)
        let configuration: ScrollTransitionConfiguration
        if let firstArg = syntax.arguments.first,
           firstArg.label == nil,
           let config = ScrollTransitionConfiguration(syntax: firstArg.expression) {
            configuration = config
        } else {
            configuration = .interactive
        }

        // Parse axis (optional named argument)
        let axis: Axis? = syntax.argument(named: "axis").flatMap({ Axis(syntax: $0.expression) })

        self = .scrollTransition(configuration: configuration, axis: axis)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .scrollTransition(let configuration, let axis):
            _content.scrollTransition(configuration, axis: axis) { content, phase in
                content
                    .opacity(phase.isIdentity ? 1 : 0)
                    .scaleEffect(phase.isIdentity ? 1 : 0.75)
                    .blur(radius: phase.isIdentity ? 0 : 10)
            }
        }
    }
}

// MARK: - ScrollTransitionConfiguration SyntaxConvertible

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension ScrollTransitionConfiguration: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self),
              memberAccess.base == nil else {
            return nil
        }

        switch memberAccess.declName.baseName.text {
        case "interactive":
            self = .interactive
        case "animated":
            self = .animated
        case "identity":
            self = .identity
        default:
            return nil
        }
    }
}
