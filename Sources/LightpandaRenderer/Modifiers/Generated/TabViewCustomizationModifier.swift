import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for enabling tab view customization on iOS 18+.
///
/// The `tabViewCustomization` modifier allows users to customize an adaptable sidebar tab view.
/// Users can reorder, hide, or show tabs when the tab bar supports customization.
///
/// ## Usage
/// ```html
/// <tabview modifiers='tabViewCustomization($customization)'>
///     <text template="tab-home" customizationid="home">Home</text>
///     <text template="tab-settings" customizationid="settings">Settings</text>
/// </tabview>
/// ```
///
/// The `$customization` binding creates a local `TabViewCustomization` instance that tracks
/// the customization state. Changes are dispatched as `customizationchanged` events.
///
/// ## Event Handling
/// ```javascript
/// element.addEventListener("customizationchanged", (event) => {
///     console.log("Tab customization changed");
/// });
/// ```
@available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
@MainActor
public enum TabViewCustomizationModifier<Library: ElementLibrary>: @unchecked Sendable {
    /// tabViewCustomization($binding) - with a binding to track customization state
    case customizationBinding(NodeBinding<TabViewCustomizationState>)

    /// tabViewCustomization() - without any binding (customization enabled but not persisted)
    case customizationNone
}

/// A simple state wrapper for TabViewCustomization that can be stored in node attributes.
/// Since TabViewCustomization itself cannot be easily serialized to/from DOM attributes,
/// we use this to trigger change events when customization occurs.
public struct TabViewCustomizationState: @unchecked Sendable {
    // Empty state - the actual TabViewCustomization is managed internally
}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
extension TabViewCustomizationModifier: RuntimeViewModifier {
    public static var baseName: String { "tabViewCustomization" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // Try to parse: tabViewCustomization($binding)
        if let firstArg = syntax.arguments.first,
           let nodeBinding = NodeBinding<TabViewCustomizationState>(syntax: firstArg.expression) {
            self = .customizationBinding(nodeBinding)
            return
        }

        // tabViewCustomization() - no arguments
        if syntax.arguments.isEmpty {
            self = .customizationNone
            return
        }

        throw ModifierParseError.noMatchingVariant(modifier: "TabViewCustomizationModifier", errors: [])
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        TabViewCustomizationModifierBody<Library>(modifier: self, content: _content)
    }
}

/// Internal view that manages TabViewCustomization state at runtime.
@available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
private struct TabViewCustomizationModifierBody<Library: ElementLibrary>: View {
    let modifier: TabViewCustomizationModifier<Library>
    let content: TabViewCustomizationModifier<Library>.Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    @State private var customization = TabViewCustomization()

    var body: some View {
        switch modifier {
        case .customizationBinding(let nodeBinding):
            content
                .tabViewCustomization($customization)
                .onChange(of: customization) { _, _ in
                    // Dispatch change event when customization changes
                    Task {
                        try? await node.callFunction(
                            runtime: runtime,
                            function: #"""
                            function() {
                                this.dispatchEvent(new CustomEvent("\#(nodeBinding.eventName)", {
                                    bubbles: true,
                                    detail: { }
                                }));
                            }
                            """#
                        )
                    }
                }
        case .customizationNone:
            content
                .tabViewCustomization($customization)
        }
    }
}

// MARK: - NodeBinding extension for TabViewCustomizationState

extension NodeBinding where Value == TabViewCustomizationState {
    /// Creates a placeholder binding for TabViewCustomizationState.
    /// The actual state is managed internally by the modifier body.
    @MainActor
    public func binding(node: Node, runtime: LightpandaRuntime) -> Binding<TabViewCustomizationState> {
        // Read the attribute to establish @Observable tracking
        let _ = node.attributes[self.attributeName]

        return Binding(
            get: { TabViewCustomizationState() },
            set: { _ in }
        )
    }
}
