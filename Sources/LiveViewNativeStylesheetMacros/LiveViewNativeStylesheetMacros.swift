import SwiftCompilerPlugin
import SwiftSyntaxMacros
import ASTDecodable

@main
struct StylesheetMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ASTDecodable.self,
    ]
}
