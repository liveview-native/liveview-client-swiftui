import SwiftUI
import SwiftSyntax

/// FileExporter modifier - NOT IMPLEMENTED
///
/// This modifier cannot be reasonably implemented in the LightpandaRenderer runtime template system because:
///
/// 1. **Document type requirement**: SwiftUI's `fileExporter` requires a `document` or `item` parameter that must be:
///    - A concrete type conforming to `FileDocument` or `ReferenceFileDocument` (for document variants)
///    - A concrete type conforming to `Transferable` (for item variants)
///
/// 2. **Data source problem**: The document/item provides the actual data to export through protocol methods
///    like `fileWrapper(configuration:)`. This data must come from the Swift app, not from HTML attributes.
///
/// 3. **Generic type constraints**: The generic parameters `D`, `C`, `T` in the SwiftUI API refer to document
///    types that cannot be resolved at parse time since they require compile-time protocol conformance.
///
/// **Alternative approaches for file export functionality:**
/// - Use JavaScript's File API or download APIs directly
/// - Implement a custom native bridge that handles file export with specific document types
/// - Use `ShareLink` modifier for sharing content (simpler and more feasible)
///
/// See also: FileImporterModifier (similar issues, but theoretically more feasible since it just returns URLs)
@MainActor
public enum FileExporterModifier<Library: ElementLibrary>: @unchecked Sendable {
    // No cases - modifier is not implemented
    case notImplemented
}

extension FileExporterModifier: RuntimeViewModifier {
    public static var baseName: String { "fileExporter" }

    public init(syntax: FunctionCallExprSyntax) throws {
        throw ModifierParseError.noMatchingVariant(
            modifier: "FileExporterModifier",
            errors: [FileExporterError.notImplemented]
        )
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        // This should never be called since init always throws
        _content
    }
}

private enum FileExporterError: Error, LocalizedError {
    case notImplemented

    var errorDescription: String? {
        """
        fileExporter is not implemented. This modifier requires a concrete document type \
        conforming to FileDocument, ReferenceFileDocument, or Transferable, which cannot \
        be provided through HTML attributes. Consider using ShareLink or JavaScript file APIs instead.
        """
    }
}
