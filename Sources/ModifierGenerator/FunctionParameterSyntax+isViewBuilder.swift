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

    var functionType: FunctionTypeSyntax? {
        if let type = self.type.as(FunctionTypeSyntax.self) {
            return type
        } else if let type = self.type.as(AttributedTypeSyntax.self)?.baseType.as(FunctionTypeSyntax.self) {
            return type
        } else if let type = self.type.as(AttributedTypeSyntax.self)?.baseType.as(TupleTypeSyntax.self)?.elements.first?.type.as(FunctionTypeSyntax.self) {
            return type
        } else if let type = self.type.as(OptionalTypeSyntax.self)?.wrappedType.as(TupleTypeSyntax.self)?.elements.first?.type.as(FunctionTypeSyntax.self) {
            return type
        } else {
            return nil
        }
    }

    var isFocusState: Bool {
        self.type.as(MemberTypeSyntax.self)?.baseType.as(MemberTypeSyntax.self)?.name.text == "FocusState"
    }
    
    var isTextReference: Bool {
        if let optionalType = self.type.as(OptionalTypeSyntax.self) {
            return optionalType.wrappedType.as(IdentifierTypeSyntax.self)?.name.text == "TextReference"
        } else if let identifierType = self.type.as(IdentifierTypeSyntax.self) {
            return identifierType.name.text == "TextReference"
        } else {
            return false
        }
    }
}
