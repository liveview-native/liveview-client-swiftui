import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Stub modifier for dragContainer.
/// This modifier cannot be fully implemented at runtime because it requires:
/// 1. Generic type parameters (Item, ItemID) that cannot be determined from syntax
/// 2. Closures that cannot be parsed from syntax at runtime
///
/// The SwiftUI dragContainer modifier creates a container with draggable views where the drag
/// payload is based on multiple identifiers of dragged items. It's designed to work with
/// the draggable modifier for multi-item drag operations.
///
/// Usage (not currently supported):
/// ```html
/// <!-- Cannot be used from markup - requires generic types and closures -->
/// <list modifiers="dragContainer(for: Item.self, in: namespace)">
///   ...
/// </list>
/// ```
///
/// Note: If you need drag and drop functionality, use the simpler `draggable(_:)` modifier
/// which supports string payloads and custom previews.
#if os(iOS) || os(macOS)
@available(iOS 26.0, macOS 26.0, *)
public enum DragContainerModifier<Library: ElementLibrary>: @unchecked Sendable {
    case dragContainer
}

@available(iOS 26.0, macOS 26.0, *)
extension DragContainerModifier: RuntimeViewModifier {
    public static var baseName: String { "dragContainer" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // This modifier cannot be parsed from syntax because it requires:
        // 1. Generic type parameters (Item, ItemID) that cannot be inferred
        // 2. Closures like `(_ draggedItemID: ItemID) -> Data` that cannot be parsed
        throw ModifierParseError.noMatchingVariant(
            modifier: "DragContainerModifier",
            errors: [DragContainerModifierError.notSupportedAtRuntime]
        )
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        // This should never be called since init always throws
        _content
    }
}

private enum DragContainerModifierError: Error, LocalizedError {
    case notSupportedAtRuntime

    var errorDescription: String? {
        switch self {
        case .notSupportedAtRuntime:
            return "dragContainer modifier requires generic type parameters and closures that cannot be parsed from syntax at runtime. Use the simpler draggable(_:) modifier instead."
        }
    }
}
#endif
