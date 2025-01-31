//
//  ExtensionDeclSyntax+isViewExtension.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/29/25.
//

import SwiftSyntax

public extension ExtensionDeclSyntax {
    /// Is this an extension of `SwiftUICore.View`.
    var isViewExtension: Bool {
        if let extendedType = self.extendedType.as(MemberTypeSyntax.self),
           extendedType.baseType.as(IdentifierTypeSyntax.self)?.name.text == "SwiftUICore",
           extendedType.name.text == "View"
        { // extension SwiftUICore.View
            return true
        } else if self.extendedType.as(IdentifierTypeSyntax.self)?.name.text == "View" { // extension View
            return true
        } else {
            return false
        }
    }
}
