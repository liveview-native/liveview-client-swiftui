import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for adding search functionality to views.
/// Supports:
/// - `.searchable(text: $searchText)` - basic searchable
/// - `.searchable(text: $searchText, prompt: "Search...")` - with prompt
/// - `.searchable(text: $searchText, placement: .sidebar)` - with placement
/// - `.searchable(text: $searchText, tokens: $searchTokens, token: tokenTemplate)` - with tokens
/// - `.searchable(text: $searchText, tokens: $searchTokens, suggestedTokens: $suggestions, token: tokenTemplate)` - with suggested tokens
public enum SearchableModifier<Library: ElementLibrary>: @unchecked Sendable {
    case searchable(text: NodeBinding<String>, placement: SearchFieldPlacement, prompt: String?)
    case searchableWithTokens(text: NodeBinding<String>, tokens: NodeBinding<String>, placement: SearchFieldPlacement, prompt: String?, token: ViewReference<Library>)
    case searchableWithSuggestedTokens(text: NodeBinding<String>, tokens: NodeBinding<String>, suggestedTokens: NodeBinding<String>, placement: SearchFieldPlacement, prompt: String?, token: ViewReference<Library>)
}

extension SearchableModifier: RuntimeViewModifier {
    public static var baseName: String { "searchable" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // Parse text binding (required)
        guard let textArg = syntax.argument(named: "text"),
              let text = NodeBinding<String>(syntax: textArg.expression) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "SearchableModifier", argument: "text")
        }
        
        // Parse placement (optional, defaults to .automatic)
        let placement: SearchFieldPlacement
        if let placementArg = syntax.argument(named: "placement"),
           let parsedPlacement = SearchFieldPlacement(syntax: placementArg.expression) {
            placement = parsedPlacement
        } else {
            placement = .automatic
        }
        
        // Parse prompt (optional)
        let prompt = syntax.argument(named: "prompt").flatMap { String(syntax: $0.expression) }
        
        // Check for tokens with suggested tokens variant
        if let tokensArg = syntax.argument(named: "tokens"),
           let tokens = NodeBinding<String>(syntax: tokensArg.expression),
           let suggestedTokensArg = syntax.argument(named: "suggestedTokens"),
           let suggestedTokens = NodeBinding<String>(syntax: suggestedTokensArg.expression),
           let tokenArg = syntax.argument(named: "token"),
           let token = ViewReference<Library>(syntax: tokenArg.expression) {
            self = .searchableWithSuggestedTokens(text: text, tokens: tokens, suggestedTokens: suggestedTokens, placement: placement, prompt: prompt, token: token)
            return
        }
        
        // Check for tokens variant (without suggested)
        if let tokensArg = syntax.argument(named: "tokens"),
           let tokens = NodeBinding<String>(syntax: tokensArg.expression),
           let tokenArg = syntax.argument(named: "token"),
           let token = ViewReference<Library>(syntax: tokenArg.expression) {
            self = .searchableWithTokens(text: text, tokens: tokens, placement: placement, prompt: prompt, token: token)
            return
        }
        
        self = .searchable(text: text, placement: placement, prompt: prompt)
    }
    
    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .searchable(let text, let placement, let prompt):
            SearchableModifierBody(text: text, placement: placement, prompt: prompt, content: _content)
        case .searchableWithTokens(let text, let tokens, let placement, let prompt, let token):
            SearchableWithTokensModifierBody<Library, Content>(text: text, tokens: tokens, suggestedTokens: nil, placement: placement, prompt: prompt, tokenTemplate: token, content: _content)
        case .searchableWithSuggestedTokens(let text, let tokens, let suggestedTokens, let placement, let prompt, let token):
            SearchableWithTokensModifierBody<Library, Content>(text: text, tokens: tokens, suggestedTokens: suggestedTokens, placement: placement, prompt: prompt, tokenTemplate: token, content: _content)
        }
    }
}

/// Helper view that resolves the NodeBinding to a real Binding
private struct SearchableModifierBody<Content: View>: View {
    let text: NodeBinding<String>
    let placement: SearchFieldPlacement
    let prompt: String?
    let content: Content
    
    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime
    
    var body: some View {
        if let prompt = prompt {
            content.searchable(text: text.binding(node: node, runtime: runtime), placement: placement, prompt: prompt)
        } else {
            content.searchable(text: text.binding(node: node, runtime: runtime), placement: placement)
        }
    }
}

/// A token parsed from JSON for search tokens
struct SearchToken: Identifiable, Hashable, Codable {
    let id: String
    let label: String
}

/// Helper view for searchable with tokens
private struct SearchableWithTokensModifierBody<Library: ElementLibrary, Content: View>: View {
    let text: NodeBinding<String>
    let tokens: NodeBinding<String>
    let suggestedTokens: NodeBinding<String>?
    let placement: SearchFieldPlacement
    let prompt: String?
    let tokenTemplate: ViewReference<Library>
    let content: Content
    
    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime
    
    /// Parse tokens from JSON attribute
    private func parseTokensBinding(_ binding: NodeBinding<String>) -> Binding<[SearchToken]> {
        Binding(
            get: {
                // Read tokens from attribute as JSON array
                guard let jsonString = node.attributes[binding.attributeName],
                      let data = jsonString.data(using: .utf8),
                      let decoded = try? JSONDecoder().decode([SearchToken].self, from: data) else {
                    return []
                }
                return decoded
            },
            set: { newValue in
                // Encode tokens back to JSON and update attribute
                guard let data = try? JSONEncoder().encode(newValue),
                      let jsonString = String(data: data, encoding: .utf8) else {
                    return
                }
                
                let attributeName = binding.attributeName
                let eventName = binding.eventName
                
                Task {
                    try? await node.callFunction(
                        runtime: runtime,
                        function: #"""
                        function() {
                            this.setAttribute("\#(attributeName)", \#(jsonString));
                            this.dispatchEvent(new CustomEvent("\#(eventName)", {
                                bubbles: true,
                                detail: { value: \#(jsonString) }
                            }));
                        }
                        """#
                    )
                }
            }
        )
    }
    
    var body: some View {
        let tokensBinding = parseTokensBinding(tokens)
        
        if let suggestedTokens = suggestedTokens {
            let suggestedBinding = parseTokensBinding(suggestedTokens)
            
            if let prompt = prompt {
                content.searchable(
                    text: text.binding(node: node, runtime: runtime),
                    tokens: tokensBinding,
                    suggestedTokens: suggestedBinding,
                    placement: placement,
                    prompt: prompt
                ) { token in
                    SwiftUI.Text(token.label)
                }
            } else {
                content.searchable(
                    text: text.binding(node: node, runtime: runtime),
                    tokens: tokensBinding,
                    suggestedTokens: suggestedBinding,
                    placement: placement
                ) { token in
                    SwiftUI.Text(token.label)
                }
            }
        } else {
            if let prompt = prompt {
                content.searchable(
                    text: text.binding(node: node, runtime: runtime),
                    tokens: tokensBinding,
                    placement: placement,
                    prompt: prompt
                ) { token in
                    SwiftUI.Text(token.label)
                }
            } else {
                content.searchable(
                    text: text.binding(node: node, runtime: runtime),
                    tokens: tokensBinding,
                    placement: placement
                ) { token in
                    SwiftUI.Text(token.label)
                }
            }
        }
    }
}

extension SearchFieldPlacement: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self),
           memberAccess.base == nil {
            switch memberAccess.declName.baseName.text {
            case "automatic":
                self = .automatic
            #if os(iOS) || os(macOS)
            case "toolbar":
                self = .toolbar
            #endif
            #if os(iOS) || os(macOS)
            case "sidebar":
                self = .sidebar
            #endif
            #if os(iOS)
            case "navigationBarDrawer":
                self = .navigationBarDrawer
            #endif
            default:
                return nil
            }
            return
        }

        // Handle .navigationBarDrawer(displayMode: .always) etc
        #if os(iOS)
        if let functionCall = syntax.as(FunctionCallExprSyntax.self),
           let memberAccess = functionCall.calledExpression.as(MemberAccessExprSyntax.self),
           memberAccess.base == nil,
           memberAccess.declName.baseName.text == "navigationBarDrawer" {
            // Parse displayMode argument
            if let displayModeArg = functionCall.arguments.first(where: { $0.label?.text == "displayMode" }),
               let displayMode = SearchFieldPlacement.NavigationBarDrawerDisplayMode(syntax: displayModeArg.expression) {
                self = .navigationBarDrawer(displayMode: displayMode)
            } else {
                // Default to automatic if no displayMode specified
                self = .navigationBarDrawer(displayMode: .automatic)
            }
            return
        }
        #endif

        return nil
    }
}

#if os(iOS)
extension SearchFieldPlacement.NavigationBarDrawerDisplayMode: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self),
              memberAccess.base == nil else {
            return nil
        }

        switch memberAccess.declName.baseName.text {
        case "always":
            self = .always
        case "automatic":
            self = .automatic
        default:
            return nil
        }
    }
}
#endif
