import SwiftUI
import SwiftSyntax

/// Modifier for setting the style of labeled content.
public enum LabeledContentStyleModifier<Library: ElementLibrary>: @unchecked Sendable {
    case labeledContentStyle(AnyLabeledContentStyle)
}

extension LabeledContentStyleModifier: RuntimeViewModifier {
    public static var baseName: String { "labeledContentStyle" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let value0 = (syntax.arguments.count > 0 ? syntax.arguments[syntax.arguments.startIndex] : nil).flatMap({ AnyLabeledContentStyle(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "LabeledContentStyleModifier", argument: "style")
        }
        self = .labeledContentStyle(value0)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .labeledContentStyle(let value0):
            _content.labeledContentStyle(value0)
        }
    }
}
