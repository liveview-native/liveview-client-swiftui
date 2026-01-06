import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Full screen cover presentation modifier using NodeBinding for `$identifier` syntax.
///
/// ## Usage
/// ```html
/// <vstack modifiers='fullScreenCover(isPresented: $showCover, content: coverContent)'>
///     <text template="coverContent">Full Screen Content</text>
///     <button>
///         <text template="label">Show Cover</text>
///     </button>
/// </vstack>
/// ```
///
/// - Note: Only available on iOS/tvOS/watchOS. On macOS, this modifier has no effect.
@MainActor
public enum FullScreenCoverModifier<Library: ElementLibrary>: @unchecked Sendable {
    case isPresented(isPresented: NodeBinding<Bool>, content: ViewReference<Library>)
}

extension FullScreenCoverModifier: RuntimeViewModifier {
    public static var baseName: String { "fullScreenCover" }

    public init(syntax: FunctionCallExprSyntax) throws {
        if let isPresented = syntax.argument(named: "isPresented").flatMap({ NodeBinding<Bool>(syntax: $0.expression) }),
           let content = syntax.argument(named: "content").flatMap({ ViewReference<Library>(syntax: $0.expression) }) {
            self = .isPresented(isPresented: isPresented, content: content)
            return
        }
        
        throw ModifierParseError.noMatchingVariant(modifier: "FullScreenCoverModifier", errors: [])
    }
    
    @ViewBuilder
    public func body(content _content: Content) -> some View {
        FullScreenCoverModifierBody<Library>(modifier: self, content: _content)
    }
}

private struct FullScreenCoverModifierBody<Library: ElementLibrary>: View {
    let modifier: FullScreenCoverModifier<Library>
    let content: FullScreenCoverModifier<Library>.Content
    
    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime
    
    var body: some View {
        switch modifier {
        case .isPresented(let isPresented, let coverContent):
            #if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
            content.fullScreenCover(isPresented: isPresented.binding(node: node, runtime: runtime)) {
                coverContent
            }
            #else
            // fullScreenCover is not available on macOS, fall back to sheet
            content.sheet(isPresented: isPresented.binding(node: node, runtime: runtime)) {
                coverContent
            }
            #endif
        }
    }
}
