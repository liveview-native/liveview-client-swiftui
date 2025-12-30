import SwiftUI

/// A reusable parse strategy for SwiftUI Alignment values.
///
/// Supports all standard alignment values:
/// - `center`, `leading`, `trailing`, `top`, `bottom`
/// - `topLeading`, `topTrailing`, `bottomLeading`, `bottomTrailing`
/// - `centerFirstTextBaseline`, `centerLastTextBaseline`
/// - `leadingFirstTextBaseline`, `leadingLastTextBaseline`
/// - `trailingFirstTextBaseline`, `trailingLastTextBaseline`
struct AlignmentParseStrategy: ParseStrategy {
    func parse(_ value: String) throws -> Alignment {
        switch value {
        case "center":
            return .center
        case "leading":
            return .leading
        case "trailing":
            return .trailing
        case "top":
            return .top
        case "bottom":
            return .bottom
        case "topLeading":
            return .topLeading
        case "topTrailing":
            return .topTrailing
        case "bottomLeading":
            return .bottomLeading
        case "bottomTrailing":
            return .bottomTrailing
        case "centerFirstTextBaseline":
            return .centerFirstTextBaseline
        case "centerLastTextBaseline":
            return .centerLastTextBaseline
        case "leadingFirstTextBaseline":
            return .leadingFirstTextBaseline
        case "leadingLastTextBaseline":
            return .leadingLastTextBaseline
        case "trailingFirstTextBaseline":
            return .trailingFirstTextBaseline
        case "trailingLastTextBaseline":
            return .trailingLastTextBaseline
        default:
            throw ParseError()
        }
    }
}
