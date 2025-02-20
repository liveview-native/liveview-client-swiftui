//
//  AccessControl.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/29/25.
//

import SwiftSyntax

public extension DeclModifierListSyntax {
    /// Checks if this decl contains a `public` modifier.
    var isPublic: Bool {
        contains(where: { $0.name.tokenKind == .keyword(.public) })
    }
    
    /// Checks if this decl contains a `static` modifier.
    var isStatic: Bool {
        contains(where: { $0.name.tokenKind == .keyword(.static) })
    }
    
    /// Checks if this decl does *not* contain the modifiers
    /// `private`, `internal`, `fileprivate`, or `package`.
    ///
    /// If not, this decl can be accessed outside of its defining module.
    var isAccessible: Bool {
        !contains(where: {
            $0.name.tokenKind == .keyword(.private)
            || $0.name.tokenKind == .keyword(.internal)
            || $0.name.tokenKind == .keyword(.fileprivate)
            || $0.name.tokenKind == .keyword(.package)
        })
    }
}

public extension EnumDeclSyntax {
    /// Checks if this decl is marked `public` and is *not* prefixed with an underscore (`_`).
    var isPublic: Bool {
        self.modifiers.isPublic
            && !self.name.text.starts(with: "_") // underscored types are internal
    }
}

public extension StructDeclSyntax {
    /// Checks if this decl is marked `public` and is *not* prefixed with an underscore (`_`).
    var isPublic: Bool {
        self.modifiers.isPublic
            && !self.name.text.starts(with: "_") // underscored types are internal
    }
}

public extension FunctionDeclSyntax {
    /// Checks if this decl is marked `public` and is *not* prefixed with an underscore (`_`).
    var isPublic: Bool {
        self.modifiers.isPublic
            && !self.name.text.starts(with: "_") // underscored types are internal
    }
}
