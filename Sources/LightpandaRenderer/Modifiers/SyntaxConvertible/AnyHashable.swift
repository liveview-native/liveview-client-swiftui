import SwiftUI
import SwiftSyntax

extension AnyHashable: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Try parsing as String first
        if let string = String(syntax: syntax) {
            self = AnyHashable(string)
            return
        }

        // Try parsing as Int
        if let int = Int(syntax: syntax) {
            self = AnyHashable(int)
            return
        }

        // Try parsing as Double
        if let double = Double(syntax: syntax) {
            self = AnyHashable(double)
            return
        }

        return nil
    }
}
