import SwiftSyntax

extension FunctionParameterSyntax {
    var isViewBuilder: Bool {
        attributes.contains(where: {
            guard let attributeType = $0.as(AttributeSyntax.self)?.attributeName.as(MemberTypeSyntax.self),
                  attributeType.baseType.as(IdentifierTypeSyntax.self)?.name.tokenKind == .identifier("SwiftUI"),
                  attributeType.name.tokenKind == .identifier("ViewBuilder")
            else { return false }
            return true
        })
    }

    var isToolbarContentBuilder: Bool {
        attributes.contains(where: {
            guard let attributeType = $0.as(AttributeSyntax.self)?.attributeName.as(MemberTypeSyntax.self),
                  attributeType.baseType.as(IdentifierTypeSyntax.self)?.name.tokenKind == .identifier("SwiftUI"),
                  attributeType.name.tokenKind == .identifier("ToolbarContentBuilder")
            else { return false }
            return true
        })
    }
}