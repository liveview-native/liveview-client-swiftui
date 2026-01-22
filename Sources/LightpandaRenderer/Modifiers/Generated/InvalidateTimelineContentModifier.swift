import SwiftUI
import SwiftSyntax

/// Note: invalidateTimelineContent() is a method on TimelineView.Context,
/// not a View modifier. Use invalidatableContent(_:) instead.
/// This modifier type exists to provide a clear error message.
public enum InvalidateTimelineContentModifier<Library: ElementLibrary>: @unchecked Sendable {
    case invalidateTimelineContent
}

extension InvalidateTimelineContentModifier: RuntimeViewModifier {
    public static var baseName: String { "invalidateTimelineContent" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // invalidateTimelineContent() is a method on TimelineView.Context, not a View modifier.
        // Users should use invalidatableContent(_:) instead for marking content as invalidatable.
        throw ModifierParseError.protocolTypeNotSupported(
            modifier: "InvalidateTimelineContentModifier",
            protocolName: "TimelineView.Context",
            suggestion: "invalidateTimelineContent() is a method on TimelineView.Context, not a View modifier. Use invalidatableContent(true) instead."
        )
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        // This will never be called since init always throws
        _content
    }
}