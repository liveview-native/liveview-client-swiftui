import SwiftUI
import SwiftSyntax

/// NOTE: The SwiftUI `.searchSelection(_:)` modifier takes a `Binding<TextSelection?>`
/// as its argument. `TextSelection` is an opaque SwiftUI type that represents text
/// selection state (ranges, insertion points, etc.) and cannot be serialized to/from
/// DOM attributes.
///
/// The modifier signature is:
/// ```swift
/// func searchSelection(_ selection: Binding<TextSelection?>) -> some View
/// ```
///
/// This cannot be supported at runtime because:
/// 1. `TextSelection` is an opaque type with no public initializers
/// 2. Text selection state cannot be meaningfully represented as a DOM attribute
/// 3. The complex internal state of text selections cannot be serialized to JSON
///
/// For text selection in LightpandaRenderer, consider using:
/// - The native browser/webview text selection APIs from JavaScript
/// - Custom event handlers to track selection changes
///
/// This modifier is intentionally disabled and will throw a parse error.
#if os(iOS) || os(macOS) || os(visionOS)
@available(iOS 26.0, macOS 26.0, visionOS 26.0, *)
public enum SearchSelectionModifier<Library: ElementLibrary>: @unchecked Sendable {
    case unsupported
}

@available(iOS 26.0, macOS 26.0, visionOS 26.0, *)
extension SearchSelectionModifier: RuntimeViewModifier {
    public static var baseName: String { "searchSelection" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // The searchSelection modifier requires a Binding<TextSelection?> argument.
        // TextSelection is an opaque SwiftUI type that represents text selection state
        // and cannot be created from syntax because:
        //
        // 1. TextSelection has no public initializers - it's created internally by SwiftUI
        // 2. Text selection state (ranges, insertion points) cannot be serialized
        // 3. The binding pattern requires runtime state that cannot be parsed from syntax
        //
        // Use JavaScript text selection APIs for working with text selections.
        throw ModifierParseError.noMatchingVariant(
            modifier: "SearchSelectionModifier",
            errors: [ModifierParseError.invalidArgumentValue(
                modifier: "searchSelection",
                argument: "selection",
                reason: "Binding<TextSelection?> cannot be created from syntax. TextSelection is an opaque SwiftUI type that cannot be serialized to DOM attributes."
            )]
        )
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        // This will never be called since init always throws
        _content
    }
}
#endif
