import SwiftUI
import SwiftSyntax
import Foundation

extension LocalizedStringKey: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let value = String(syntax: syntax) else { return nil }
        self.init(value)
    }
}

extension LocalizedStringResource: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let value = String(syntax: syntax) else { return nil }
        self.init(stringLiteral: value)
    }
}
