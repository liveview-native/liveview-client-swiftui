import SwiftUI
import SwiftSyntax
import LightpandaClient

#if os(visionOS)
/// Ornament modifier for visionOS.
///
/// ## Usage
/// ```html
/// <vstack modifiers='ornament(attachmentAnchor: .scene(.bottom), ornament: bottomControls)'>
///     <text>Main Content</text>
///     <hstack template="bottomControls">
///         <button><text template="label">Play</text></button>
///         <button><text template="label">Pause</text></button>
///     </hstack>
/// </vstack>
/// ```
@MainActor
public enum OrnamentModifier<Library: ElementLibrary>: @unchecked Sendable {
    case ornament(
        visibility: Visibility,
        attachmentAnchor: OrnamentAttachmentAnchor,
        contentAlignment: Alignment,
        ornament: ViewReference<Library>
    )
}

extension OrnamentModifier: RuntimeViewModifier {
    public static var baseName: String { "ornament" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let visibility: Visibility = syntax.argument(named: "visibility").flatMap({ Visibility(syntax: $0.expression) }) ?? .automatic

        guard let attachmentAnchor = syntax.argument(named: "attachmentAnchor").flatMap({ OrnamentAttachmentAnchor(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "OrnamentModifier", argument: "attachmentAnchor")
        }

        let contentAlignment: Alignment = syntax.argument(named: "contentAlignment").flatMap({ Alignment(syntax: $0.expression) }) ?? .center

        guard let ornament = syntax.argument(named: "ornament").flatMap({ ViewReference<Library>(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "OrnamentModifier", argument: "ornament")
        }

        self = .ornament(visibility: visibility, attachmentAnchor: attachmentAnchor, contentAlignment: contentAlignment, ornament: ornament)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        OrnamentModifierBody<Library>(modifier: self, content: _content)
    }
}

private struct OrnamentModifierBody<Library: ElementLibrary>: View {
    let modifier: OrnamentModifier<Library>
    let content: OrnamentModifier<Library>.Content

    var body: some View {
        switch modifier {
        case .ornament(let visibility, let attachmentAnchor, let contentAlignment, let ornamentContent):
            content.ornament(visibility: visibility, attachmentAnchor: attachmentAnchor, contentAlignment: contentAlignment) {
                ornamentContent
            }
        }
    }
}
#endif
