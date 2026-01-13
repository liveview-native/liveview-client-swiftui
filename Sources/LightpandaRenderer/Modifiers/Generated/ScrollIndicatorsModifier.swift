import SwiftUI
import SwiftSyntax

/// Modifier for controlling scroll indicator visibility.
/// Usage: .scrollIndicators(.hidden) or .scrollIndicators(.visible, axes: .vertical)
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public enum ScrollIndicatorsModifier<Library: ElementLibrary>: @unchecked Sendable {
    case scrollIndicators(ScrollIndicatorVisibility, axes: Axis.Set)
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension ScrollIndicatorsModifier: RuntimeViewModifier {
    public static var baseName: String { "scrollIndicators" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let visibilityArg = syntax.arguments.first,
              let visibility = ScrollIndicatorVisibility(syntax: visibilityArg.expression) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "ScrollIndicatorsModifier", argument: "visibility")
        }
        
        // Parse axes if provided, default to both
        var axes: Axis.Set = [.vertical, .horizontal]
        if let axesArg = syntax.argument(named: "axes") {
            if let memberAccess = axesArg.expression.as(MemberAccessExprSyntax.self),
               memberAccess.base == nil {
                switch memberAccess.declName.baseName.text {
                case "vertical":
                    axes = .vertical
                case "horizontal":
                    axes = .horizontal
                default:
                    break
                }
            }
        }
        
        self = .scrollIndicators(visibility, axes: axes)
    }
    
    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .scrollIndicators(let visibility, let axes):
            _content.scrollIndicators(visibility, axes: axes)
        }
    }
}