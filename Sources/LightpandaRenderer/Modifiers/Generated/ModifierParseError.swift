import Foundation

/// Errors that can occur when parsing modifiers from syntax.
public enum ModifierParseError: Error, CustomStringConvertible {
    case unexpectedArgumentCount(modifier: String, expected: [Int], found: Int)
    case invalidArguments(modifier: String, variant: String, expectedTypes: String)
    case ambiguousVariant(modifier: String, expectedLabels: [String])
    case noMatchingVariant(modifier: String, errors: [Error])
    case missingRequiredArgument(modifier: String, argument: String)
    case closureNotSupported(modifier: String, suggestion: String)
    case publisherNotSupported(modifier: String, suggestion: String)
    case protocolTypeNotSupported(modifier: String, protocolName: String, suggestion: String)
    case invalidArgumentValue(modifier: String, argument: String, reason: String)
    case unsupportedEnvironmentKey(modifier: String, key: String)
    case keyPathNotSupported(modifier: String, suggestion: String)

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
        case .closureNotSupported(let modifier, let suggestion):
            return "\(modifier): closures cannot be parsed from syntax at runtime. \(suggestion)"
        case .publisherNotSupported(let modifier, let suggestion):
            return "\(modifier): Combine Publisher types cannot be instantiated from syntax at runtime. \(suggestion)"
        case .protocolTypeNotSupported(let modifier, let protocolName, let suggestion):
            return "\(modifier): Types conforming to '\(protocolName)' cannot be instantiated from syntax at runtime. \(suggestion)"
        case .invalidArgumentValue(let modifier, let argument, let reason):
            return "\(modifier): invalid value for argument '\(argument)'. \(reason)"
        case .unsupportedEnvironmentKey(let modifier, let key):
            return "\(modifier): unsupported environment key '\(key)'. Supported keys: colorScheme, layoutDirection, isEnabled"
        case .keyPathNotSupported(let modifier, let suggestion):
            return "\(modifier): key paths to FocusedValues properties cannot be created at runtime because they require compile-time protocol conformances and type extensions. \(suggestion)"
        }
    }
}