//
//  ContentShapeKinds.swift
//  LightpandaRenderer
//

import SwiftUI
import SwiftSyntax

extension ContentShapeKinds: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }
        
        let name = memberAccess.declName.baseName.text
        
        switch name {
        case "interaction":
            self = .interaction
        case "dragPreview":
            self = .dragPreview
        case "accessibility":
            self = .accessibility
        default:
            return nil
        }
    }
}
