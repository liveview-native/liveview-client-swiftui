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
            
                init(width: Double?, height: Double?) {
                    self.width = width
                    self.height = height
                }
            }
            """,
            expandedSource: """
            struct TestModifier: ParseableModifier {
                let width: Double?
                let height: Double?
            }
            
            extension TestModifier {}
            """,
            macros: testMacros
        )
    }
}
