import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for associating destination views with navigation values.
///
/// ## Usage with String values
/// ```html
/// <list modifiers="navigationDestination(for: item, destination: itemDetail)">
///     <navigationlink value="item1">
///         <text template="label">Item 1</text>
///     </navigationlink>
///     <group template="itemDetail">
///         <!-- Receives "navigationValue" attribute with the value -->
///         <text>Detail view</text>
///     </group>
/// </list>
/// ```
///
/// ## Usage with isPresented binding
/// ```html
/// <vstack 
///     showDetail="false"
///     modifiers="navigationDestination(isPresented: $showDetail, destination: detailView)"
///     onShowDetailChanged={(e) => setShowDetail(e.detail.value)}
/// >
///     <button onClick={() => setShowDetail(true)}>
///         <text template="label">Show Detail</text>
///     </button>
///     <group template="detailView">
///         <text>Detail Content</text>
///     </group>
/// </vstack>
/// ```
public enum NavigationDestinationModifier<Library: ElementLibrary>: @unchecked Sendable {
    /// Value-based navigation destination (for use with NavigationLink value="...")
    case forValue(identifier: String, destination: ViewReference<Library>)
    /// Boolean binding-based navigation destination
    case isPresented(NodeBinding<Bool>, destination: ViewReference<Library>)
}

extension NavigationDestinationModifier: RuntimeViewModifier {
    public static var baseName: String { "navigationDestination" }

    public init(syntax: FunctionCallExprSyntax) throws {
        var errors: [Error] = []
        
        // Try parsing .navigationDestination(isPresented: $showDetail, destination: detailView)
        if let isPresentedArg = syntax.argument(named: "isPresented"),
           let isPresented = NodeBinding<Bool>(syntax: isPresentedArg.expression),
           let destinationArg = syntax.argument(named: "destination"),
           let destination = ViewReference<Library>(syntax: destinationArg.expression) {
            self = .isPresented(isPresented, destination: destination)
            return
        }
        
        // Try parsing .navigationDestination(for: item, destination: itemDetail)
        if let forArg = syntax.argument(named: "for"),
           let destinationArg = syntax.argument(named: "destination"),
           let destination = ViewReference<Library>(syntax: destinationArg.expression) {
            // Extract the identifier name from the "for" argument
            if let declRef = forArg.expression.as(DeclReferenceExprSyntax.self) {
                let identifier = declRef.baseName.text
                self = .forValue(identifier: identifier, destination: destination)
                return
            }
        }
        
        throw ModifierParseError.noMatchingVariant(modifier: "NavigationDestinationModifier", errors: errors)
    }
    
    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .forValue(let identifier, let destination):
            NavigationDestinationForValueBody<Library, Content>(
                identifier: identifier,
                destination: destination,
                content: _content
            )
        case .isPresented(let isPresented, let destination):
            NavigationDestinationIsPresentedBody<Library, Content>(
                isPresented: isPresented,
                destination: destination,
                content: _content
            )
        }
    }
}

/// Helper view for value-based navigation destination
private struct NavigationDestinationForValueBody<Library: ElementLibrary, Content: View>: View {
    let identifier: String
    let destination: ViewReference<Library>
    let content: Content
    
    @Environment(Node.self) private var node
    
    var body: some View {
        // Use String as the navigation value type
        content.navigationDestination(for: String.self) { value in
            // Set the navigation value on the destination's environment
            destination
                .environment(\.navigationValue, value)
        }
    }
}

/// Helper view for isPresented-based navigation destination
private struct NavigationDestinationIsPresentedBody<Library: ElementLibrary, Content: View>: View {
    let isPresented: NodeBinding<Bool>
    let destination: ViewReference<Library>
    let content: Content
    
    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime
    
    var body: some View {
        content.navigationDestination(isPresented: isPresented.binding(node: node, runtime: runtime)) {
            destination
        }
    }
}

// MARK: - Navigation Value Environment Key

private struct NavigationValueKey: EnvironmentKey {
    static let defaultValue: String? = nil
}

extension EnvironmentValues {
    /// The current navigation value passed from a NavigationLink
    var navigationValue: String? {
        get { self[NavigationValueKey.self] }
        set { self[NavigationValueKey.self] = newValue }
    }
}
