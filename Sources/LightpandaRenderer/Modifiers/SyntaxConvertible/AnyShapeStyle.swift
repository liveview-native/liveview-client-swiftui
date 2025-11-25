import SwiftUI
import SwiftSyntax

extension AnyShapeStyle: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        if let color = Color.init(syntax: syntax) {
            self = .init(color)
        } else {
            return nil
        }
    }
}
