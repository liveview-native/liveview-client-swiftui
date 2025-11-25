import Foundation

/// Errors that can occur when parsing modifiers from syntax.
public enum ModifierParseError: Error, CustomStringConvertible {
    /// The number of arguments doesn't match any known variant.
    case unexpectedArgumentCount(modifier: String, expected: [Int], found: Int)
    /// The arguments could not be parsed for the specified variant.
    case invalidArguments(modifier: String, variant: String, expectedTypes: String)
    /// Multiple variants match the argument count but labels don't match.
    case ambiguousVariant(modifier: String, expectedLabels: [String])

    public var description: String {
        switch self {
        case .unexpectedArgumentCount(let modifier, let expected, let found):
            return "\(modifier): unexpected argument count \(found), expected one of \(expected)"
        case .invalidArguments(let modifier, let variant, let expectedTypes):
            return "\(modifier): invalid arguments for '\(variant)', expected types: \(expectedTypes)"
        case .ambiguousVariant(let modifier, let expectedLabels):
            return "\(modifier): ambiguous variant, expected first argument label to be one of \(expectedLabels)"
        }
    }
}