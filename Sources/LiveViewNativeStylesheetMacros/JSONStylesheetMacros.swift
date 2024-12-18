import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct JSONStylesheetMacros: CompilerPlugin {
    var providingMacros: [Macro.Type] = [
        ASTDecodable.self,
        StaticMemberDecodable.self
    ]
}
