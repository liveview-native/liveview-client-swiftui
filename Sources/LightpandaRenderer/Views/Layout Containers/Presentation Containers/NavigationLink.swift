import SwiftUI
import LightpandaClient

/// A control users can tap to navigate within a NavigationStack.
///
/// ## Basic Usage with Destination View
/// ```html
/// <navigationlink>
///     <text template="label">Go to Details</text>
///     <group template="destination">
///         <text>Detail View Content</text>
///     </group>
/// </navigationlink>
/// ```
///
/// ## Usage with Value (requires navigationDestination modifier)
/// ```html
/// <navigationstack>
///     <list modifiers="navigationDestination(for: item, destination: itemDetail)">
///         <navigationlink value="item1">
///             <text template="label">Item 1</text>
///         </navigationlink>
///         <navigationlink value="item2">
///             <text template="label">Item 2</text>
///         </navigationlink>
///         <group template="itemDetail">
///             <!-- This will receive the value as a "navigationValue" attribute -->
///             <text>Showing detail for item</text>
///         </group>
///     </list>
/// </navigationstack>
/// ```
///
/// ## Attributes
/// - `value`: A string value to pass to navigationDestination (optional)
///
/// ## Templates
/// - `label`: The visible content of the link (required)
/// - `destination`: The view to navigate to when tapped (used when no value is provided)
public struct NavigationLinkView<Library: ElementLibrary>: View {
    var node: Node
    
    /// The value to pass to navigationDestination
    private var value: String? {
        node.attributeValue(for: "value")
    }
    
    public var body: some View {
        if let value = value {
            // Value-based navigation - uses navigationDestination modifier
            SwiftUI.NavigationLink(value: value) {
                node.children(in: "label", library: Library.self)
            }
        } else if node.hasTemplate("destination") {
            // Destination-based navigation
            SwiftUI.NavigationLink {
                node.children(in: "destination", library: Library.self)
            } label: {
                node.children(in: "label", library: Library.self)
            }
        } else {
            // Fallback - just show the label as non-interactive
            node.children(in: "label", library: Library.self)
        }
    }
}
