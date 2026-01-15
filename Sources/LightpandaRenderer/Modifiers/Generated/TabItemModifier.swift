import SwiftUI
import SwiftSyntax

/// Modifier for setting tab item label.
///
/// Usage:
/// ```html
/// <text modifiers="tabItem(tabLabel)">
///     Content
///     <label template="tabLabel">
///         <text template="title">Tab</text>
///         <image template="icon" systemname="star"/>
///     </label>
/// </text>
/// ```
public enum TabItemModifier<Library: ElementLibrary>: @unchecked Sendable {
    case tabItem(ViewReference<Library>)
}

extension TabItemModifier: RuntimeViewModifier {
    public static var baseName: String { "tabItem" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let label = syntax.arguments.first.flatMap({ ViewReference<Library>(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "TabItemModifier", argument: "label")
        }
        self = .tabItem(label)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .tabItem(let label):
            _content.tabItem { label }
        }
    }
}
