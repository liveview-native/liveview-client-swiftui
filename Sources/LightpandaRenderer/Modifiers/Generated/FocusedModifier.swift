import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for binding focus state to a view.
/// Uses NodeBinding to sync focus state with DOM attributes.
///
/// Usage:
/// ```html
/// <!-- Boolean focus binding -->
/// <textfield modifiers="focused($isFocused)">
///
/// <!-- Enum-style focus binding with equals -->
/// <textfield modifiers="focused($focusedField, equals: .username)">
/// <textfield modifiers="focused($focusedField, equals: .password)">
/// ```
///
/// JavaScript:
/// ```javascript
/// // Listen for focus changes
/// element.addEventListener("isFocusedChanged", (e) => {
///     console.log("Focus changed:", e.detail.value);
/// });
///
/// // Programmatically focus
/// element.setAttribute("isFocused", "true");
///
/// // For enum-style focus
/// element.setAttribute("focusedField", "username");
/// ```
public enum FocusedModifier<Library: ElementLibrary>: @unchecked Sendable {
    case focusedBool(NodeBinding<Bool>)
    case focusedEquals(NodeBinding<String>, equals: String)
}

extension FocusedModifier: RuntimeViewModifier {
    public static var baseName: String { "focused" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // Try focused($binding, equals: .value)
        if let binding = syntax.arguments.first.flatMap({ NodeBinding<String>(syntax: $0.expression) }),
           let equalsArg = syntax.argument(named: "equals"),
           let equalsValue = equalsArg.expression.as(MemberAccessExprSyntax.self)?.declName.baseName.text {
            self = .focusedEquals(binding, equals: equalsValue)
            return
        }

        // Try focused($binding) for Bool
        if let binding = syntax.arguments.first.flatMap({ NodeBinding<Bool>(syntax: $0.expression) }) {
            self = .focusedBool(binding)
            return
        }

        throw ModifierParseError.noMatchingVariant(modifier: "FocusedModifier", errors: [])
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .focusedBool(let binding):
            FocusedBoolBody(binding: binding, content: _content)
        case .focusedEquals(let binding, let equals):
            FocusedEqualsBody(binding: binding, equals: equals, content: _content)
        }
    }
}

// MARK: - Boolean Focus

private struct FocusedBoolBody<Content: View>: View {
    let binding: NodeBinding<Bool>
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime
    @FocusState private var isFocused: Bool

    var body: some View {
        content
            .focused($isFocused)
            .onChange(of: isFocused) { _, newValue in
                // Update node attribute when focus changes
                if newValue {
                    node.attributes[binding.attributeName] = "true"
                } else {
                    node.attributes.removeValue(forKey: binding.attributeName)
                }
                // Dispatch change event
                dispatchChange(newValue)
            }
            .onAppear {
                // Sync initial state from attribute
                isFocused = node.attributes[binding.attributeName] == "true"
            }
            .onChange(of: node.attributes[binding.attributeName]) { _, newValue in
                // Sync from attribute changes
                isFocused = newValue == "true"
            }
    }

    private func dispatchChange(_ value: Bool) {
        Task {
            try? await node.callFunction(
                runtime: runtime,
                function: #"""
                function() {
                    this.dispatchEvent(new CustomEvent("\#(binding.attributeName)Changed", {
                        bubbles: true,
                        detail: { value: \#(value) }
                    }));
                }
                """#
            )
        }
    }
}

// MARK: - Enum-style Focus

private struct FocusedEqualsBody<Content: View>: View {
    let binding: NodeBinding<String>
    let equals: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime
    @FocusState private var focusedField: String?

    var body: some View {
        content
            .focused($focusedField, equals: equals)
            .onChange(of: focusedField) { _, newValue in
                // Update node attribute when focus changes
                if let value = newValue {
                    node.attributes[binding.attributeName] = value
                } else {
                    node.attributes.removeValue(forKey: binding.attributeName)
                }
                // Dispatch change event
                dispatchChange(newValue)
            }
            .onAppear {
                // Sync initial state from attribute
                if let attrValue = node.attributes[binding.attributeName], attrValue == equals {
                    focusedField = equals
                }
            }
            .onChange(of: node.attributes[binding.attributeName]) { _, newValue in
                // Sync from attribute changes
                if newValue == equals {
                    focusedField = equals
                } else if focusedField == equals {
                    focusedField = nil
                }
            }
    }

    private func dispatchChange(_ value: String?) {
        let jsonValue = value.map { "\"\($0)\"" } ?? "null"
        Task {
            try? await node.callFunction(
                runtime: runtime,
                function: #"""
                function() {
                    this.dispatchEvent(new CustomEvent("\#(binding.attributeName)Changed", {
                        bubbles: true,
                        detail: { value: \#(jsonValue) }
                    }));
                }
                """#
            )
        }
    }
}
