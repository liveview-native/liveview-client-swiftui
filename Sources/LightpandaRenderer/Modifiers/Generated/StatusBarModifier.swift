import SwiftUI
import SwiftSyntax

/// Modifier for controlling the status bar visibility using statusBar(hidden:).
///
/// Usage:
/// ```html
/// <vstack modifiers="statusBar(hidden: true)">
/// <vstack modifiers="statusBar(hidden: false)">
/// ```
#if os(iOS) || os(visionOS)
public enum StatusBarModifier<Library: ElementLibrary>: @unchecked Sendable {
    case statusBar(hidden: Bool)
}

extension StatusBarModifier: RuntimeViewModifier {
    public static var baseName: String { "statusBar" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let hidden = syntax.argument(named: "hidden").flatMap({ Bool(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "StatusBarModifier", argument: "hidden")
        }
        self = .statusBar(hidden: hidden)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .statusBar(hidden: let hidden):
            _content.statusBar(hidden: hidden)
        }
    }
}
#endif
