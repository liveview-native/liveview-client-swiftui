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
    
    /// The event name, formed from the attribute name (`showAlert` -> `showalertchanged`)
    public let eventName: String
    
    public init(attributeName: String) {
        self.attributeName = attributeName.lowercased()
        self.eventName = "\(attributeName.lowercased())changed"
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
                self.eventName = "\(baseName.lowercased())changed"
                return
            }
        }
        return nil
    }
    
    /// Creates a SwiftUI `Binding` that reads from the node's attributes
    /// and dispatches change events when the value is set.
    ///
    /// **Important**: This method reads from `node.attributes` to establish
    /// `@Observable` tracking. Call this directly in your view's `body` property,
    /// not in `onAppear` or other callbacks.
    ///
    /// - Parameters:
    ///   - node: The node to read/write attributes from
    ///   - runtime: The Lightpanda runtime for dispatching events
    /// - Returns: A `Binding` connected to the node's attribute
    @MainActor
    public func binding(node: Node, runtime: LightpandaRuntime) -> Binding<Value> where Value == Bool {
        // Read the attribute here to establish @Observable tracking during view body evaluation.
        // This ensures SwiftUI re-evaluates the body when node.attributes changes.
        let _ = node.attributes[self.attributeName]
        
        // Capture attributeName for use in the getter/setter closures
        let attributeName = self.attributeName
        let eventName = self.eventName
        
        return Binding(
            get: {
                // Read fresh from node.attributes each time the getter is called
                let currentValue = node.attributes[attributeName]
                let result = currentValue.map { $0 != "false" } ?? false
                print("[NodeBinding] get() for '\(attributeName)': currentValue=\(String(describing: currentValue)), returning \(result)")
                return result
            },
            set: { newValue in
                // Update attribute and dispatch change event via JS
                let jsonValue = String(data: try! JSONEncoder().encode(newValue), encoding: .utf8)!
                Task {
                    try? await node.callFunction(
                        runtime: runtime,
                        function: #"""
                        function() {
                            if (\#(jsonValue)) {
                                this.setAttribute("\#(attributeName)", "true");
                            } else {
                                this.removeAttribute("\#(attributeName)");
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
        // Read the attribute here to establish @Observable tracking
        let _ = node.attributes[self.attributeName]
        let attributeName = self.attributeName
        let eventName = self.eventName
        
        return Binding(
            get: {
                node.attributes[attributeName] ?? ""
            },
            set: { newValue in
                // Update attribute and dispatch change event via JS
                let encodedValue = String(data: try! JSONEncoder().encode(newValue), encoding: .utf8)!
                Task {
                    try? await node.callFunction(
                        runtime: runtime,
                        function: #"""
                        function() {
                            this.setAttribute("\#(attributeName)", \#(encodedValue));
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
        // Read the attribute here to establish @Observable tracking
        let _ = node.attributes[self.attributeName]
        let attributeName = self.attributeName
        let eventName = self.eventName
        
        return Binding(
            get: {
                node.attributes[attributeName]
            },
            set: { newValue in
                // Update attribute and dispatch change event via JS
                // JSON encode: String becomes quoted, nil becomes null
                let jsonValue = String(data: try! JSONEncoder().encode(newValue), encoding: .utf8)!
                Task {
                    try? await node.callFunction(
                        runtime: runtime,
                        function: #"""
                        function() {
                            if (\#(jsonValue) !== null) {
                                this.setAttribute("\#(attributeName)", \#(jsonValue));
                            } else {
                                this.removeAttribute("\#(attributeName)");
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
        // Read the attribute here to establish @Observable tracking
        let _ = node.attributes[self.attributeName]
        let attributeName = self.attributeName
        let eventName = self.eventName
        
        return Binding(
            get: {
                Double(node.attributes[attributeName] ?? "") ?? 0
            },
            set: { newValue in
                // Update attribute and dispatch change event via JS
                let jsonValue = String(data: try! JSONEncoder().encode(newValue), encoding: .utf8)!
                Task {
                    try? await node.callFunction(
                        runtime: runtime,
                        function: #"""
                        function() {
                            this.setAttribute("\#(attributeName)", String(\#(jsonValue)));
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
        // Read the attribute here to establish @Observable tracking
        let _ = node.attributes[self.attributeName]
        let attributeName = self.attributeName
        let eventName = self.eventName

        return Binding(
            get: {
                Int(node.attributes[attributeName] ?? "") ?? 0
            },
            set: { newValue in
                // Update attribute and dispatch change event via JS
                let jsonValue = String(data: try! JSONEncoder().encode(newValue), encoding: .utf8)!
                Task {
                    try? await node.callFunction(
                        runtime: runtime,
                        function: #"""
                        function() {
                            this.setAttribute("\#(attributeName)", String(\#(jsonValue)));
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

    /// Creates a SwiftUI `Binding` for Set<String> values.
    /// The attribute stores a JSON array of strings, e.g., `["item1", "item2"]`.
    @MainActor
    public func binding(node: Node, runtime: LightpandaRuntime) -> Binding<Value> where Value == Set<String> {
        // Read the attribute here to establish @Observable tracking
        let _ = node.attributes[self.attributeName]
        let attributeName = self.attributeName
        let eventName = self.eventName

        return Binding(
            get: {
                // Parse JSON array from attribute, or return empty set
                guard let jsonString = node.attributes[attributeName],
                      let data = jsonString.data(using: .utf8),
                      let array = try? JSONDecoder().decode([String].self, from: data) else {
                    return Set()
                }
                return Set(array)
            },
            set: { newValue in
                // Encode as JSON array and dispatch change event via JS
                let sortedArray = Array(newValue).sorted()
                let jsonValue = String(data: try! JSONEncoder().encode(sortedArray), encoding: .utf8)!
                Task {
                    try? await node.callFunction(
                        runtime: runtime,
                        function: #"""
                        function() {
                            this.setAttribute("\#(attributeName)", JSON.stringify(\#(jsonValue)));
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
