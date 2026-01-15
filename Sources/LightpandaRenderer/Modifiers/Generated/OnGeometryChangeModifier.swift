import SwiftUI
import SwiftSyntax
import LightpandaClient

/// The geometry property to observe for onGeometryChange modifier
public enum GeometryProperty: String, Sendable {
    case size
    case frame
    case safeAreaInsets
}

/// Modifier for tracking geometry changes and dispatching events to JavaScript.
/// Since closures cannot be parsed from syntax, this modifier uses predefined
/// geometry properties (size, frame, safeAreaInsets) that can be observed.
///
/// Usage:
/// ```html
/// <!-- Track size changes, dispatch "geometryChange" event (default) -->
/// <vstack modifiers="onGeometryChange(for: size)">
///   ...
/// </vstack>
///
/// <!-- Track frame changes in global coordinate space -->
/// <vstack modifiers="onGeometryChange(for: frame, action: frameChanged)">
///   ...
/// </vstack>
///
/// <!-- Track safe area insets changes -->
/// <vstack modifiers="onGeometryChange(for: safeAreaInsets, action: insetsChanged)">
///   ...
/// </vstack>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("geometryChange", (e) => {
///     console.log("Geometry changed:", e.detail);
///     // For size: { width: 375, height: 667 }
///     // For frame: { x: 0, y: 44, width: 375, height: 667 }
///     // For safeAreaInsets: { top: 44, leading: 0, bottom: 34, trailing: 0 }
/// });
/// ```
public enum OnGeometryChangeModifier<Library: ElementLibrary>: @unchecked Sendable {
    case onGeometryChange(for: GeometryProperty, action: String)
}

extension OnGeometryChangeModifier: RuntimeViewModifier {
    public static var baseName: String { "onGeometryChange" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // Parse the geometry property from "for:" argument
        guard let propertyName = syntax.argument(named: "for").flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }),
              let property = GeometryProperty(rawValue: propertyName) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "OnGeometryChangeModifier", argument: "for")
        }

        // Parse the event name from "action:" argument, default to "geometryChange"
        let action = syntax.argument(named: "action").flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "geometryChange"

        self = .onGeometryChange(for: property, action: action)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .onGeometryChange(let property, let action):
            OnGeometryChangeModifierBody(property: property, eventName: action, content: _content)
        }
    }
}

/// Helper view that dispatches geometry change events to JavaScript
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
private struct OnGeometryChangeModifierBody<Content: View>: View {
    let property: GeometryProperty
    let eventName: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        switch property {
        case .size:
            content.onGeometryChange(for: CGSize.self) { proxy in
                proxy.size
            } action: { newValue in
                dispatchEvent(detail: """
                    { "width": \(newValue.width), "height": \(newValue.height) }
                    """)
            }
        case .frame:
            content.onGeometryChange(for: CGRect.self) { proxy in
                proxy.frame(in: .global)
            } action: { newValue in
                dispatchEvent(detail: """
                    { "x": \(newValue.origin.x), "y": \(newValue.origin.y), "width": \(newValue.width), "height": \(newValue.height) }
                    """)
            }
        case .safeAreaInsets:
            content.onGeometryChange(for: EdgeInsets.self) { proxy in
                proxy.safeAreaInsets
            } action: { newValue in
                dispatchEvent(detail: """
                    { "top": \(newValue.top), "leading": \(newValue.leading), "bottom": \(newValue.bottom), "trailing": \(newValue.trailing) }
                    """)
            }
        }
    }

    private func dispatchEvent(detail: String) {
        Task {
            try? await node.callFunction(
                runtime: runtime,
                function: #"""
                function() {
                    this.dispatchEvent(new CustomEvent("\#(eventName)", {
                        bubbles: true,
                        detail: \#(detail)
                    }));
                }
                """#
            )
        }
    }
}
