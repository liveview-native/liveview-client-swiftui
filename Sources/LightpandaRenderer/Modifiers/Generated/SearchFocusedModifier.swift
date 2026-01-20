import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for binding search focus state to a view.
/// Uses NodeBinding to sync search focus state with DOM attributes.
///
/// Available on iOS 18+, macOS 15+, visionOS 2+.
///
/// Usage:
/// ```html
/// <!-- Boolean search focus binding -->
/// <view modifiers="searchable(text: $query).searchFocused($isSearchFocused)">
///
/// <!-- Enum-style search focus binding with equals -->
/// <view modifiers="searchable(text: $query).searchFocused($searchField, equals: .primary)">
/// ```
///
/// JavaScript:
/// ```javascript
/// // Listen for search focus changes
/// element.addEventListener("isSearchFocusedChanged", (e) => {
///     console.log("Search focus changed:", e.detail.value);
/// });
///
/// // Programmatically focus search
/// element.setAttribute("isSearchFocused", "true");
///
/// // For enum-style search focus
/// element.setAttribute("searchField", "primary");
/// ```
#if os(iOS) || os(macOS) || os(visionOS)
@available(iOS 18.0, macOS 15.0, visionOS 2.0, *)
public enum SearchFocusedModifier<Library: ElementLibrary>: @unchecked Sendable {
    case searchFocusedBool(NodeBinding<Bool>)
    case searchFocusedEquals(NodeBinding<String>, equals: String)
}

@available(iOS 18.0, macOS 15.0, visionOS 2.0, *)
extension SearchFocusedModifier: RuntimeViewModifier {
    public static var baseName: String { "searchFocused" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // Try searchFocused($binding, equals: .value)
        if let binding = syntax.arguments.first.flatMap({ NodeBinding<String>(syntax: $0.expression) }),
           let equalsArg = syntax.argument(named: "equals"),
           let equalsValue = equalsArg.expression.as(MemberAccessExprSyntax.self)?.declName.baseName.text {
            self = .searchFocusedEquals(binding, equals: equalsValue)
            return
        }

        // Try searchFocused($binding) for Bool
        if let binding = syntax.arguments.first.flatMap({ NodeBinding<Bool>(syntax: $0.expression) }) {
            self = .searchFocusedBool(binding)
            return
        }

        throw ModifierParseError.noMatchingVariant(modifier: "SearchFocusedModifier", errors: [])
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .searchFocusedBool(let binding):
            SearchFocusedBoolBody(binding: binding, content: _content)
        case .searchFocusedEquals(let binding, let equals):
            SearchFocusedEqualsBody(binding: binding, equals: equals, content: _content)
        }
    }
}

// MARK: - Boolean Search Focus

@available(iOS 18.0, macOS 15.0, visionOS 2.0, *)
private struct SearchFocusedBoolBody<Content: View>: View {
    let binding: NodeBinding<Bool>
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime
    @FocusState private var isSearchFocused: Bool

    var body: some View {
        content
            .searchFocused($isSearchFocused)
            .onChange(of: isSearchFocused) { _, newValue in
                // Update node attribute when search focus changes
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
                isSearchFocused = node.attributes[binding.attributeName] == "true"
            }
            .onChange(of: node.attributes[binding.attributeName]) { _, newValue in
                // Sync from attribute changes
                isSearchFocused = newValue == "true"
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

// MARK: - Enum-style Search Focus

@available(iOS 18.0, macOS 15.0, visionOS 2.0, *)
private struct SearchFocusedEqualsBody<Content: View>: View {
    let binding: NodeBinding<String>
    let equals: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime
    @FocusState private var focusedField: String?

    var body: some View {
        content
            .searchFocused($focusedField, equals: equals)
            .onChange(of: focusedField) { _, newValue in
                // Update node attribute when search focus changes
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
#endif
