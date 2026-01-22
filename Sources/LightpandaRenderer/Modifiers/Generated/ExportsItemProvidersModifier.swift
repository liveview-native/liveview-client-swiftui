import SwiftUI
import SwiftSyntax

/// NOTE: The SwiftUI `.exportsItemProviders(_:onExport:)` and `.exportsItemProviders(_:onExport:onEdit:)`
/// modifiers take closures that return `[NSItemProvider]` arrays. These closures require runtime
/// creation of NSItemProvider objects, which cannot be instantiated from syntax at parse time.
///
/// The modifier signatures are:
/// ```swift
/// func exportsItemProviders(_ contentTypes: [UTType], onExport: @escaping () -> [NSItemProvider]) -> some View
/// func exportsItemProviders(_ contentTypes: [UTType], onExport: @escaping () -> [NSItemProvider], onEdit: @escaping ([NSItemProvider]) -> Bool) -> some View
/// ```
///
/// These require:
/// 1. A closure that returns NSItemProvider array (onExport)
/// 2. Optionally a closure that receives NSItemProvider array and returns Bool (onEdit)
///
/// Neither of these can be parsed from syntax strings at runtime because:
/// - NSItemProvider objects must be created programmatically with actual data
/// - The closures need to execute arbitrary Swift code to create/process item providers
///
/// For sharing data in LightpandaRenderer, consider:
/// - Using ShareLink for simple sharing scenarios
/// - Using JavaScript's navigator.share API for web-compatible sharing
/// - Implementing custom native bridges for complex item provider scenarios
///
/// This modifier is intentionally disabled and will throw a parse error.
@available(iOS 15.0, macOS 12.0, *)
public enum ExportsItemProvidersModifier<Library: ElementLibrary>: @unchecked Sendable {
    case unsupported
}

@available(iOS 15.0, macOS 12.0, *)
extension ExportsItemProvidersModifier: RuntimeViewModifier {
    public static var baseName: String { "exportsItemProviders" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // The exportsItemProviders modifier requires closures that return [NSItemProvider] arrays.
        // NSItemProvider objects represent data that can be shared between apps and cannot be
        // instantiated from a syntax string because:
        //
        // 1. NSItemProvider requires actual data (strings, URLs, images, etc.) to be created
        // 2. The onExport closure must return created NSItemProvider instances
        // 3. The optional onEdit closure receives provider instances and returns a Bool
        //
        // Use ShareLink for simple sharing, or implement native bridges for complex scenarios.
        throw ModifierParseError.noMatchingVariant(
            modifier: "ExportsItemProvidersModifier",
            errors: [ModifierParseError.closureNotSupported(
                modifier: "exportsItemProviders",
                suggestion: "Use ShareLink for simple sharing, or implement native bridges for NSItemProvider-based sharing"
            )]
        )
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        // This will never be called since init always throws
        _content
    }
}
