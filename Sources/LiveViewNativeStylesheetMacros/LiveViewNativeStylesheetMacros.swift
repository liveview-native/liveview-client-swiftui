import SwiftCompilerPlugin
import SwiftSyntaxMacros

import SwiftSyntax
import SwiftSyntaxBuilder
import ASTDecodableImplementation

struct ASTDecodable: ExtensionMacro {
    static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        try ASTDecodableImplementation.ASTDecodable.expansion(
            of: node,
            attachedTo: declaration,
            providingExtensionsOf: type,
            conformingTo: protocols,
            in: context
        )
    }
}

@main
struct StylesheetMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ASTDecodable.self,
    ]
}
