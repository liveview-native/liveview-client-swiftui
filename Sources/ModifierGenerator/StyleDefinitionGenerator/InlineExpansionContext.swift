//
//  InlineExpansionContext.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/29/25.
//

import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros

/// Mocked macro expansion context to pass to `ASTDecodable` invocations.
final class InlineExpansionContext: MacroExpansionContext {
    func diagnose(_ diagnostic: Diagnostic) {
        fatalError(diagnostic.message) // we should never pass invalid syntax to a macro expansion
    }
    
    func location(of node: some SyntaxProtocol, at position: PositionInSyntaxNode, filePathMode: SourceLocationFilePathMode) -> AbstractSourceLocation? {
        nil
    }
    
    func makeUniqueName(_ name: String) -> TokenSyntax {
        .identifier("__\(name)") // avoid collisions by applying an underscored (__) prefix
    }
    
    var lexicalContext: [Syntax] { [] }
}
