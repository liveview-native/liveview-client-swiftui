@_exported import Parsing

/// A macro that creates a parser for a custom type.
///
/// An AST node is represented as a tuple in the following format:
///
/// ```
/// {:<name>, [<meta>], [<args>]}
/// ```
///
/// This macro will create the ``ParseableExpressionProtocol`` conformance
/// and satisfy the ``ParseableExpressionProtocol/arguments`` requirement.
///
/// The parser is built from the `init` clauses on the type.
/// Provide multiple `init` clauses to support different function signatures for the same type.
///
/// ```swift
/// @ParseableExpression
/// struct MyCustomValue {
///     static let name = "my_custom_value"
///
///     init(_ argument: Int, labelledArgument: String?) {
///         ...
///     }
/// }
/// ```
///
/// ```swift
/// my_custom_value(0, labelledArgument: "hello, world!")
/// ```
///
/// ```
/// {:my_custom_value, [], [0, [labelledArgument: "hello, world!"]]}
/// ```
///
/// - Note: Labelled arguments must appear at the end of the signature.
/// The AST node is read as `[<arg1>, <arg2>, [<label>:<arg3>, ...]]`,
/// where the last element in `<args>` is a list of labelled arguments.
///
/// - Note: Labelled arguments must be optional.
/// Wildcard arguments can be ``Swift/Optional``, but will require `nil` to be passed explicitly.
@attached(extension, conformances: ParseableExpressionProtocol, names: named(arguments), named(_ParserType), named(ExpressionArgumentsBody))
public macro ParseableExpression() = #externalMacro(module: "LiveViewNativeStylesheetMacros", type: "ParseableExpressionMacro")
