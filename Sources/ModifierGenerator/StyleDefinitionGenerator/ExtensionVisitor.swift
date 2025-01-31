//
//  ExtensionVisitor.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/29/25.
//

import SwiftSyntax
import SwiftSyntaxExtensions

/// Collects all ``ExtensionDeclSyntax`` from the input, keyed by the type name.
final class ExtensionVisitor: SyntaxVisitor {
    var extensions = [String:[ExtensionDeclSyntax]]()
    
    override func visit(_ node: ExtensionDeclSyntax) -> SyntaxVisitorContinueKind {
        guard !typeDenylist.contains(node.extendedType.trimmedDescription)
        else { return .skipChildren }
        
        extensions[node.extendedType.trimmedDescription] = extensions[node.extendedType.trimmedDescription, default: []] + [node]
        
        return .skipChildren
    }
}
