import SwiftUI
import SwiftSyntax

/// A type-erased wrapper for Equatable values.
/// Used for modifiers that need to track value changes without knowing the concrete type.
public struct AnyEquatable: Equatable, SyntaxConvertible {
    private let value: any Equatable
    private let equals: (any Equatable) -> Bool

    public init<T: Equatable>(_ value: T) {
        self.value = value
        self.equals = { other in
            guard let otherValue = other as? T else { return false }
            return value == otherValue
        }
    }

    public static func == (lhs: AnyEquatable, rhs: AnyEquatable) -> Bool {
        lhs.equals(rhs.value)
    }

    public init?(syntax: some SyntaxProtocol) {
        // Try to parse as common equatable types

        // Try Int
        if let intValue = Int(syntax: syntax) {
            self.init(intValue)
            return
        }

        // Try Double
        if let doubleValue = Double(syntax: syntax) {
            self.init(doubleValue)
            return
        }

        // Try Bool
        if let boolValue = Bool(syntax: syntax) {
            self.init(boolValue)
            return
        }

        // Try String
        if let stringValue = String(syntax: syntax) {
            self.init(stringValue)
            return
        }

        return nil
    }
}
