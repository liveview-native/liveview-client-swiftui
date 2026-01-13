import SwiftUI
import SwiftSyntax

/// Modifier for disabling autocorrection on text fields.
///
/// Usage:
/// ```html
/// <textfield modifiers="autocorrectionDisabled()">
/// <textfield modifiers="autocorrectionDisabled(true)">
/// <textfield modifiers="autocorrectionDisabled(false)">
/// ```
public enum AutocorrectionDisabledModifier<Library: ElementLibrary>: @unchecked Sendable {
    case autocorrectionDisabled(Bool)
}

extension AutocorrectionDisabledModifier: RuntimeViewModifier {
    public static var baseName: String { "autocorrectionDisabled" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let value = (syntax.arguments.count > 0 ? syntax.arguments[syntax.arguments.startIndex] : nil)
            .flatMap({ Bool(syntax: $0.expression) }) ?? true
        self = .autocorrectionDisabled(value)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .autocorrectionDisabled(let value):
            _content.autocorrectionDisabled(value)
        }
    }
}
