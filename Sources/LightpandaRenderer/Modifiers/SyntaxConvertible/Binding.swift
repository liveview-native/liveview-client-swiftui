import SwiftUI
import SwiftSyntax
import LightpandaClient

extension Binding: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Bindings cannot be created at parse time since they need runtime Node access.
        // Use NodeBinding instead, which stores the attribute name and creates
        // the binding at runtime.
        return nil
    }
}

/// A binding reference parsed from `$identifier` syntax.
///
/// This type stores the attribute name extracted from the binding syntax.
/// At runtime, use `binding(node:runtime:)` to create an actual `Binding`
/// that reads from the node's attributes and dispatches change events.
///
/// ## Usage in Markup
/// ```html
/// <element modifiers=".alert(isPresented: $showAlert)" />
/// ```
///
/// The `$showAlert` syntax creates a `NodeBinding` with `attributeName = "showAlert"`.
/// The binding will:
/// - Read the value from the `showAlert` attribute on the element
/// - On set, update the attribute and dispatch a `showAlertChanged` event
///
/// ## Event Handling
/// ```javascript
/// element.addEventListener("showAlertChanged", (event) => {
///     console.log("New value:", event.detail.value);
/// });
/// ```
public struct NodeBinding<Value>: @unchecked Sendable, SyntaxConvertible {
    /// The name of the attribute to bind to, lowercased to match node attributes.
    public let attributeName: String
    
    /// The original name preserving casing, used for event names (e.g., "showAlertChanged").
    public let eventBaseName: String
    
    public init(attributeName: String) {
        self.attributeName = attributeName.lowercased()
        self.eventBaseName = attributeName
    }
    
    public init?(syntax: some SyntaxProtocol) {
        // Parse $identifier syntax (e.g., $showAlert)
        // In SwiftSyntax, $showAlert is represented as a DeclReferenceExprSyntax
        // with baseName.text = "$showAlert"
        if let declRef = syntax.as(DeclReferenceExprSyntax.self) {
            let name = declRef.baseName.text
            if name.hasPrefix("$") {
                let baseName = String(name.dropFirst())
                // Store lowercased for attribute matching, original for event names
                self.attributeName = baseName.lowercased()
                self.eventBaseName = baseName
                return
            }
        }
        return nil
    }
    
    /// Creates a SwiftUI `Binding` that reads from the node's attributes
    /// and dispatches change events when the value is set.
    ///
    /// - Parameters:
    ///   - node: The node to read/write attributes from
    ///   - runtime: The Lightpanda runtime for dispatching events
    /// - Returns: A `Binding` connected to the node's attribute
    @MainActor
    public func binding(node: Node, runtime: LightpandaRuntime) -> Binding<Value> where Value == Bool {
        Binding(
            get: {
                // For Bool, any attribute value means true except explicit "false"
                // Missing attribute = false, "false" = false, anything else = true
                if let value = node.attributes[self.attributeName] {
                    return value != "false"
                }
                return false
            },
            set: { newValue in
                // Update attribute and dispatch change event via JS
                let eventName = "\(self.eventBaseName)Changed"
                let jsonValue = String(data: try! JSONEncoder().encode(newValue), encoding: .utf8)!
                Task {
                    try? await node.callFunction(
                        runtime: runtime,
                        function: #"""
                        function() {
                            if (\#(jsonValue)) {
                                this.setAttribute("\#(self.attributeName)", "true");
                            } else {
                                this.removeAttribute("\#(self.attributeName)");
                            }
                            this.dispatchEvent(new CustomEvent("\#(eventName)", {
                                bubbles: true,
                                detail: { value: \#(jsonValue) }
                            }));
                        }
                        """#
                    )
                }
            }
        )
    }
    
    /// Creates a SwiftUI `Binding` for String values.
    @MainActor
    public func binding(node: Node, runtime: LightpandaRuntime) -> Binding<Value> where Value == String {
        Binding(
            get: {
                node.attributes[self.attributeName] ?? ""
            },
            set: { newValue in
                // Update attribute and dispatch change event via JS
                let eventName = "\(self.eventBaseName)Changed"
                let encodedValue = String(data: try! JSONEncoder().encode(newValue), encoding: .utf8)!
                Task {
                    try? await node.callFunction(
                        runtime: runtime,
                        function: #"""
                        function() {
                            this.setAttribute("\#(self.attributeName)", \#(encodedValue));
                            this.dispatchEvent(new CustomEvent("\#(eventName)", {
                                bubbles: true,
                                detail: { value: \#(encodedValue) }
                            }));
                        }
                        """#
                    )
                }
            }
        )
    }
    
    /// Creates a SwiftUI `Binding` for optional String values.
    @MainActor
    public func binding(node: Node, runtime: LightpandaRuntime) -> Binding<Value> where Value == String? {
        Binding(
            get: {
                node.attributes[self.attributeName]
            },
            set: { newValue in
                // Update attribute and dispatch change event via JS
                let eventName = "\(self.eventBaseName)Changed"
                // JSON encode: String becomes quoted, nil becomes null
                let jsonValue = String(data: try! JSONEncoder().encode(newValue), encoding: .utf8)!
                Task {
                    try? await node.callFunction(
                        runtime: runtime,
                        function: #"""
                        function() {
                            if (\#(jsonValue) !== null) {
                                this.setAttribute("\#(self.attributeName)", \#(jsonValue));
                            } else {
                                this.removeAttribute("\#(self.attributeName)");
                            }
                            this.dispatchEvent(new CustomEvent("\#(eventName)", {
                                bubbles: true,
                                detail: { value: \#(jsonValue) }
                            }));
                        }
                        """#
                    )
                }
            }
        )
    }
    
    /// Creates a SwiftUI `Binding` for Double values.
    @MainActor
    public func binding(node: Node, runtime: LightpandaRuntime) -> Binding<Value> where Value == Double {
        Binding(
            get: {
                Double(node.attributes[self.attributeName] ?? "") ?? 0
            },
            set: { newValue in
                // Update attribute and dispatch change event via JS
                let eventName = "\(self.eventBaseName)Changed"
                let jsonValue = String(data: try! JSONEncoder().encode(newValue), encoding: .utf8)!
                Task {
                    try? await node.callFunction(
                        runtime: runtime,
                        function: #"""
                        function() {
                            this.setAttribute("\#(self.attributeName)", String(\#(jsonValue)));
                            this.dispatchEvent(new CustomEvent("\#(eventName)", {
                                bubbles: true,
                                detail: { value: \#(jsonValue) }
                            }));
                        }
                        """#
                    )
                }
            }
        )
    }
    
    /// Creates a SwiftUI `Binding` for Int values.
    @MainActor
    public func binding(node: Node, runtime: LightpandaRuntime) -> Binding<Value> where Value == Int {
        Binding(
            get: {
                Int(node.attributes[self.attributeName] ?? "") ?? 0
            },
            set: { newValue in
                // Update attribute and dispatch change event via JS
                let eventName = "\(self.eventBaseName)Changed"
                let jsonValue = String(data: try! JSONEncoder().encode(newValue), encoding: .utf8)!
                Task {
                    try? await node.callFunction(
                        runtime: runtime,
                        function: #"""
                        function() {
                            this.setAttribute("\#(self.attributeName)", String(\#(jsonValue)));
                            this.dispatchEvent(new CustomEvent("\#(eventName)", {
                                bubbles: true,
                                detail: { value: \#(jsonValue) }
                            }));
                        }
                        """#
                    )
                }
            }
        )
    }
}
