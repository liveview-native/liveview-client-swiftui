import Foundation

/// Errors that can occur when parsing modifiers from syntax.
public enum ModifierParseError: Error, CustomStringConvertible {
    case unexpectedArgumentCount(modifier: String, expected: [Int], found: Int)
    case invalidArguments(modifier: String, variant: String, expectedTypes: String)
    case ambiguousVariant(modifier: String, expectedLabels: [String])
    case noMatchingVariant(modifier: String, errors: [Error])
    case missingRequiredArgument(modifier: String, argument: String)

    public var description: String {
        switch self {
        case .unexpectedArgumentCount(let modifier, let expected, let found):
            return "\(modifier): unexpected argument count \(found), expected one of \(expected)"
        case .invalidArguments(let modifier, let variant, let expectedTypes):
            return "\(modifier): invalid arguments for '\(variant)', expected types: \(expectedTypes)"
        case .ambiguousVariant(let modifier, let expectedLabels):
            return "\(modifier): ambiguous variant, expected first argument label to be one of \(expectedLabels)"
        case .noMatchingVariant(let modifier, let errors):
            return "\(modifier): no matching variant found. Errors: \(errors)"
        case .missingRequiredArgument(let modifier, let argument):
            return "\(modifier): missing required argument '\(argument)'"
        }
    }
}