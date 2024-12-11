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
                @MainActor  struct ExpressionArgumentsBody: @preconcurrency Parser {
                    let context: ParseableModifierContext
                    func parse(_ input: inout Substring.UTF8View) throws -> TestModifier {
                        try "[".utf8.parse(&input)
                        try Whitespace().parse(&input)
                        let copy = input
                        var clauseFailures = [([String], ModifierParseError.ErrorType)]()
                        #if os(iOS) || os(macOS)
                        do {
                        let width: Double? = try Parse(input: Substring.UTF8View.self) {
                            Whitespace()

                            Whitespace()
                            Double?.parser(in: context)
                            Whitespace()
                        }
                        .parse(&input)
                        var failures = [ModifierParseError.ErrorType]()
                        var height: Double?
                        try Whitespace().parse(&input)
                        if input.first == ",".utf8.first || input.first == "[".utf8.first {
                        if input.first == ",".utf8.first {
                            try ",".utf8.parse(&input)
                        }
                        try Whitespace().parse(&input)
                        try "[".utf8.parse(&input)
                        while !input.isEmpty {
                            try Whitespace().parse(&input)
                            let __name = try Identifier().parse(&input)
                            try ":".utf8.parse(&input)
                            try Whitespace().parse(&input)
                            switch __name {
                            case "height":
                                let labelledArgumentCopy = input
            do {
                height = try Double?.parser(in: context).parse(&input)
            } catch {
                input = labelledArgumentCopy
                let value = try _AnyNodeParser.AnyArgument(context: context).parse(&input)
                failures.append(
                    .incorrectArgumentValue("height", value: value, expectedType: Double.self, replacement: nil)
                )
            }
                            default:
                                _ = try _AnyNodeParser.AnyArgument(context: context).parse(&input)
            failures.append(.unknownArgument(__name))
                            }
                            try Whitespace().parse(&input)
                            guard input.first == ",".utf8.first else {
                                break
                            }
                            try ",".utf8.parse(&input)
                        }
                        try "]".utf8.parse(&input)
                        guard failures.isEmpty else {
                            throw ModifierParseError(error: .multipleErrors(failures), metadata: context.metadata)
                        }}
                        try Whitespace().parse(&input)
                        try "]".utf8.parse(&input)
                        return Output(width, height: height)} catch let error as ModifierParseError {
                            clauseFailures.append((
                                ["_", "height"],
                                error.error
                            ))
                           input = copy} catch {
                           input = copy}
            #endif
                        if clauseFailures.isEmpty {
                            throw ModifierParseError(error: .noMatchingClause(Output.name, [["_", "height"]]), metadata: context.metadata)
                        } else {
                            throw ModifierParseError(error: .multipleClauseErrors(Output.name, clauseFailures), metadata: context.metadata)
                        }
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
            expandedSource: #"""
            struct Padding {
                init(_ edges: Edge.Set = .all, _ length: AttributeReference<CGFloat?>? = .init(storage: .constant(nil))) {
                    // ...
                }
            }

            extension Padding: ParseableExpressionProtocol {
             typealias _ParserType = StandardExpressionParser<Self>
                @MainActor  struct ExpressionArgumentsBody: @preconcurrency Parser {
                    let context: ParseableModifierContext
                    func parse(_ input: inout Substring.UTF8View) throws -> Padding {
                        try "[".utf8.parse(&input)
                        try Whitespace().parse(&input)
                        let copy = input
                        var clauseFailures = [([String], ModifierParseError.ErrorType)]()
                        do {
                        let edges: Edge.Set  = try OneOf(input: Substring.UTF8View.self, output: Edge.Set.self) {
                            Parse {
                                Whitespace()

                                Whitespace()
                                Edge.Set .parser(in: context)
                                Whitespace()
                            }
                            Always(.all)
                        } .parse(&input)
                        let length: AttributeReference<CGFloat?>?  = try OneOf(input: Substring.UTF8View.self, output: AttributeReference<CGFloat?>?.self) {
                            Parse {
                                Whitespace()
                                ",".utf8
                                Whitespace()
                                AttributeReference<CGFloat?>? .parser(in: context)
                                Whitespace()
                            }
                            Always(.init(storage: .constant(nil)))
                        } .parse(&input)
                        try Whitespace().parse(&input)
                        try "]".utf8.parse(&input)
                        return Output(edges, length)} catch let error as ModifierParseError {
                            clauseFailures.append((
                                ["_", "_"],
                                error.error
                            ))
                           input = copy} catch {
                           input = copy}
                        if clauseFailures.isEmpty {
                            throw ModifierParseError(error: .noMatchingClause(Output.name, [["_", "_"]]), metadata: context.metadata)
                        } else {
                            throw ModifierParseError(error: .multipleClauseErrors(Output.name, clauseFailures), metadata: context.metadata)
                        }
                    }
                }
             static func arguments(in context: ParseableModifierContext) -> ExpressionArgumentsBody {
                    ExpressionArgumentsBody(context: context)
                }
            }
            """#,
            macros: testMacros
        )
    }
}
#endif
