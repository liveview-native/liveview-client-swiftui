import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct StylesheetMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ParseableExpressionMacro.self,
    ]
}
