import SwiftUI
import SwiftSyntax

/// Modifier for SwiftUI's alignmentGuide(_:computeValue:).
/// Since closures cannot be parsed from syntax, this accepts a fixed CGFloat value
/// that will be returned by the closure.
public enum AlignmentGuideModifier<Library: ElementLibrary>: @unchecked Sendable {
    case horizontal(HorizontalAlignment, computeValue: CGFloat)
    case vertical(VerticalAlignment, computeValue: CGFloat)
}

extension AlignmentGuideModifier: RuntimeViewModifier {
    public static var baseName: String { "alignmentGuide" }

    public init(syntax: FunctionCallExprSyntax) throws {
        var errors: [Error] = []

        // Try parsing as HorizontalAlignment
        do {
            guard let alignment = (syntax.arguments.first).flatMap({ HorizontalAlignment(syntax: $0.expression) }) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "AlignmentGuideModifier", argument: "alignment")
            }
            guard let computeValue = syntax.argument(named: "computeValue").flatMap({ CGFloat(syntax: $0.expression) }) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "AlignmentGuideModifier", argument: "computeValue")
            }
            self = .horizontal(alignment, computeValue: computeValue)
            return
        } catch {
            errors.append(error)
        }

        // Try parsing as VerticalAlignment
        do {
            guard let alignment = (syntax.arguments.first).flatMap({ VerticalAlignment(syntax: $0.expression) }) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "AlignmentGuideModifier", argument: "alignment")
            }
            guard let computeValue = syntax.argument(named: "computeValue").flatMap({ CGFloat(syntax: $0.expression) }) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "AlignmentGuideModifier", argument: "computeValue")
            }
            self = .vertical(alignment, computeValue: computeValue)
            return
        } catch {
            errors.append(error)
        }

        throw ModifierParseError.noMatchingVariant(modifier: "AlignmentGuideModifier", errors: errors)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .horizontal(let alignment, computeValue: let value):
            _content.alignmentGuide(alignment) { _ in value }
        case .vertical(let alignment, computeValue: let value):
            _content.alignmentGuide(alignment) { _ in value }
        }
    }
}