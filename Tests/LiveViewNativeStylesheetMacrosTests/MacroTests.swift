#if os(macOS)
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import LiveViewNativeStylesheetMacros

let testMacros: [String: Macro.Type] = [
    "ParseableExpression": ParseableExpressionMacro.self
]

final class MacroTests: XCTestCase {
    func testMacro() {
        assertMacroExpansion(
            """
            @ParseableExpression
            struct TestModifier {
                let width: Double?
                let height: Double?
            
                static let name = "test"
            
                #if os(iOS) || os(macOS)
                init(_ width: Double?, height: Double?) {
                    self.width = width
                    self.height = height
                }
                #endif
            }
            """,
            expandedSource: """
            struct TestModifier {
                let width: Double?
                let height: Double?

                static let name = "test"

                #if os(iOS) || os(macOS)
                init(_ width: Double?, height: Double?) {
                    self.width = width
                    self.height = height
                }
                #endif
            }

            extension TestModifier: ParseableExpressionProtocol {
             typealias _ParserType = StandardExpressionParser<Self>
             struct ExpressionArgumentsBody: Parser {
                    let context: ParseableModifierContext
                    func parse(_ input: inout Substring.UTF8View) throws -> TestModifier {
                        try "[" .utf8.parse(&input)
                        let copy = input
                        #if os(iOS) || os(macOS)
                        do {
                           return try
                        _ThrowingParse({ (wildcard: Double?, labelled: Double?) -> Output in

                            return Output.init(
                                wildcard, height: labelled
                            )
                            }) {
                            // Parse the wildcard arguments
                            Parse({ width -> Double? in
                            (width)
                                }) {
                            Whitespace()
                            Double.parser(in: context)
                            Whitespace()

                            Whitespace()
                            }

                            // Parse the labelled arguments
                            OneOf {
                            Parse {
                                Whitespace()
                                "," .utf8
                                Whitespace()
                                "[" .utf8
                                Many(
                                    into: (Double?.none)
                                ) { (result: inout Double?, argument: Double?) in
                                    result = (
                                        result ?? argument
                                    )
                                } element: {
                                    Whitespace()
                                    OneOf {
                                        Parse({ value -> Double? in
                            (value)
                                            }) {
                            "height:" .utf8
                            Whitespace()
                            Double.parser(in: context)
                                        }
                                        _ErrorParse {
                                            Identifier().map(ArgumentParseError.unknownArgument)
                                            ":" .utf8
                                            Whitespace()
                                        }
                                    }
                                    Whitespace()
                                } separator: {
                                    "," .utf8
                                } terminator: {
                                    "]" .utf8
                                }
                            }
                            Always((Double?.none))
                            }
                            "]" .utf8
                        }
                           .parse(&input)} catch {
                           input = copy}
            #endif
                        throw ModifierParseError(error: .noMatchingClause(Output.name, [["_", "height"]]), metadata: context.metadata)
                    }
                }
             static func arguments(in context: ParseableModifierContext) -> ExpressionArgumentsBody {
                    ExpressionArgumentsBody(context: context)
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func testDefaultArguments() {
        assertMacroExpansion(
            #"""
            @ParseableExpression
            struct Padding {
                init(_ edges: Edge.Set = .all, _ length: AttributeReference<CGFloat?>? = .init(storage: .constant(nil))) {
                    // ...
                }
            }
            """#,
            expandedSource: "",
            macros: testMacros
        )
    }
}
#endif
