import SwiftUI
import SwiftSyntax

public struct AnyTextEditorStyle: TextEditorStyle, @preconcurrency SyntaxConvertible {
    let style: any TextEditorStyle

    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self)
        else { return nil }

        if memberAccess.base == nil {
            switch memberAccess.declName.baseName.text {
            case "automatic":
                self.style = .automatic
            case "plain":
                self.style = .plain
            default:
                return nil
            }
        } else {
            // FIXME: Handle base name
            return nil
        }
    }

    public func makeBody(configuration: Configuration) -> some View {
        // TextEditorStyleConfiguration provides direct access to the styled TextEditor
        // We need to return the styled view properly
        switch self.style {
        case _ as AutomaticTextEditorStyle:
            AutomaticTextEditorStyle().makeBody(configuration: configuration)
        case _ as PlainTextEditorStyle:
            PlainTextEditorStyle().makeBody(configuration: configuration)
        default:
            // Fallback to automatic
            AutomaticTextEditorStyle().makeBody(configuration: configuration)
        }
    }
}
