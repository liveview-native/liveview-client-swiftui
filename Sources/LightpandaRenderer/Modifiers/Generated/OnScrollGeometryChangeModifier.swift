import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for observing scroll geometry changes in ScrollViews.
/// Dispatches a custom event with scroll geometry data when the scroll position changes.
///
/// Usage:
/// ```html
/// <!-- Dispatches "scrollGeometryChange" event (default) -->
/// <scrollview modifiers="onScrollGeometryChange()">
///   ...
/// </scrollview>
///
/// <!-- Dispatches "scrolled" event -->
/// <scrollview modifiers="onScrollGeometryChange(action: scrolled)">
///   ...
/// </scrollview>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("scrollGeometryChange", (e) => {
///     console.log("Content offset:", e.detail.contentOffset);
///     console.log("Content size:", e.detail.contentSize);
///     console.log("Container size:", e.detail.containerSize);
///     console.log("Visible rect:", e.detail.visibleRect);
/// });
/// ```
@available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
public enum OnScrollGeometryChangeModifier<Library: ElementLibrary>: @unchecked Sendable {
    case onScrollGeometryChange(action: String)
}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
extension OnScrollGeometryChangeModifier: RuntimeViewModifier {
    public static var baseName: String { "onScrollGeometryChange" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // Parse event name from 'action:' parameter, default to "scrollGeometryChange"
        let action = syntax.argument(named: "action").flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "scrollGeometryChange"
        self = .onScrollGeometryChange(action: action)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .onScrollGeometryChange(let action):
            OnScrollGeometryChangeModifierBody(eventName: action, content: _content)
        }
    }
}

/// Helper view that dispatches a custom event when scroll geometry changes
@available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
private struct OnScrollGeometryChangeModifierBody<Content: View>: View {
    let eventName: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.onScrollGeometryChange(for: ScrollGeometryData.self) { geometry in
            ScrollGeometryData(
                contentOffsetX: geometry.contentOffset.x,
                contentOffsetY: geometry.contentOffset.y,
                contentSizeWidth: geometry.contentSize.width,
                contentSizeHeight: geometry.contentSize.height,
                containerSizeWidth: geometry.containerSize.width,
                containerSizeHeight: geometry.containerSize.height,
                visibleRectX: geometry.visibleRect.origin.x,
                visibleRectY: geometry.visibleRect.origin.y,
                visibleRectWidth: geometry.visibleRect.size.width,
                visibleRectHeight: geometry.visibleRect.size.height,
                contentInsetsTop: geometry.contentInsets.top,
                contentInsetsLeading: geometry.contentInsets.leading,
                contentInsetsBottom: geometry.contentInsets.bottom,
                contentInsetsTrailing: geometry.contentInsets.trailing
            )
        } action: { oldValue, newValue in
            Task {
                try? await node.callFunction(
                    runtime: runtime,
                    function: #"""
                    function() {
                        this.dispatchEvent(new CustomEvent("\#(eventName)", {
                            bubbles: true,
                            detail: {
                                contentOffset: { x: \#(newValue.contentOffsetX), y: \#(newValue.contentOffsetY) },
                                contentSize: { width: \#(newValue.contentSizeWidth), height: \#(newValue.contentSizeHeight) },
                                containerSize: { width: \#(newValue.containerSizeWidth), height: \#(newValue.containerSizeHeight) },
                                visibleRect: { x: \#(newValue.visibleRectX), y: \#(newValue.visibleRectY), width: \#(newValue.visibleRectWidth), height: \#(newValue.visibleRectHeight) },
                                contentInsets: { top: \#(newValue.contentInsetsTop), leading: \#(newValue.contentInsetsLeading), bottom: \#(newValue.contentInsetsBottom), trailing: \#(newValue.contentInsetsTrailing) },
                                oldValue: {
                                    contentOffset: { x: \#(oldValue.contentOffsetX), y: \#(oldValue.contentOffsetY) },
                                    contentSize: { width: \#(oldValue.contentSizeWidth), height: \#(oldValue.contentSizeHeight) },
                                    containerSize: { width: \#(oldValue.containerSizeWidth), height: \#(oldValue.containerSizeHeight) },
                                    visibleRect: { x: \#(oldValue.visibleRectX), y: \#(oldValue.visibleRectY), width: \#(oldValue.visibleRectWidth), height: \#(oldValue.visibleRectHeight) },
                                    contentInsets: { top: \#(oldValue.contentInsetsTop), leading: \#(oldValue.contentInsetsLeading), bottom: \#(oldValue.contentInsetsBottom), trailing: \#(oldValue.contentInsetsTrailing) }
                                }
                            }
                        }));
                    }
                    """#
                )
            }
        }
    }
}

/// Data structure for scroll geometry that conforms to Equatable.
/// Uses individual properties instead of nested types for Equatable conformance.
@available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
private struct ScrollGeometryData: Equatable {
    let contentOffsetX: CGFloat
    let contentOffsetY: CGFloat
    let contentSizeWidth: CGFloat
    let contentSizeHeight: CGFloat
    let containerSizeWidth: CGFloat
    let containerSizeHeight: CGFloat
    let visibleRectX: CGFloat
    let visibleRectY: CGFloat
    let visibleRectWidth: CGFloat
    let visibleRectHeight: CGFloat
    let contentInsetsTop: CGFloat
    let contentInsetsLeading: CGFloat
    let contentInsetsBottom: CGFloat
    let contentInsetsTrailing: CGFloat
}
