import SwiftUI
import SwiftSyntax

/// NOTE: The SwiftUI `.accessibilityChartDescriptor(_:)` modifier takes a value
/// conforming to `AXChartDescriptorRepresentable`, which generates an `AXChartDescriptor`
/// for audio graph accessibility in charts.
///
/// Since `AXChartDescriptorRepresentable` requires a concrete implementation that
/// defines chart data structure at compile time, this modifier cannot be parsed
/// from syntax at runtime.
///
/// This modifier is primarily used with Swift Charts to make chart data accessible
/// via VoiceOver Audio Graphs. For runtime accessibility, consider using:
/// - accessibilityLabel(_:)
/// - accessibilityValue(_:)
/// - accessibilityHint(_:)
///
/// This modifier is intentionally disabled and will throw a parse error.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public enum AccessibilityChartDescriptorModifier<Library: ElementLibrary>: @unchecked Sendable {
    case unsupported
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension AccessibilityChartDescriptorModifier: RuntimeViewModifier {
    public static var baseName: String { "accessibilityChartDescriptor" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // The accessibilityChartDescriptor modifier requires a type conforming to
        // AXChartDescriptorRepresentable, which must be a concrete implementation
        // that generates AXChartDescriptor for audio graph accessibility.
        //
        // This cannot be parsed from syntax at runtime since it requires
        // compile-time defined chart data structures.
        throw ModifierParseError.noMatchingVariant(
            modifier: "AccessibilityChartDescriptorModifier",
            errors: [ModifierParseError.protocolTypeNotSupported(
                modifier: "accessibilityChartDescriptor",
                protocolName: "AXChartDescriptorRepresentable",
                suggestion: "Use accessibilityLabel(), accessibilityValue(), or accessibilityHint() for runtime accessibility"
            )]
        )
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        // This will never be called since init always throws
        _content
    }
}
