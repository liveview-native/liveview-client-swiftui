import SwiftUI
import SwiftSyntax

// MARK: - AccessibilityTraits

extension AccessibilityTraits: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Handle single trait like .isButton
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self) {
            let name = memberAccess.declName.baseName.text
            if let trait = Self.trait(for: name) {
                self = trait
                return
            }
            return nil
        }
        
        // Handle array of traits like [.isButton, .isHeader]
        if let arrayExpr = syntax.as(ArrayExprSyntax.self) {
            var combined = AccessibilityTraits()
            for element in arrayExpr.elements {
                if let trait = AccessibilityTraits(syntax: element.expression) {
                    combined.insert(trait)
                } else {
                    return nil
                }
            }
            self = combined
            return
        }
        
        return nil
    }
    
    private static func trait(for name: String) -> AccessibilityTraits? {
        switch name {
        case "isButton":
            return .isButton
        case "isHeader":
            return .isHeader
        case "isSelected":
            return .isSelected
        case "isLink":
            return .isLink
        case "isSearchField":
            return .isSearchField
        case "isImage":
            return .isImage
        case "playsSound":
            return .playsSound
        case "isKeyboardKey":
            return .isKeyboardKey
        case "isStaticText":
            return .isStaticText
        case "isSummaryElement":
            return .isSummaryElement
        case "updatesFrequently":
            return .updatesFrequently
        case "startsMediaSession":
            return .startsMediaSession
        case "allowsDirectInteraction":
            return .allowsDirectInteraction
        case "causesPageTurn":
            return .causesPageTurn
        case "isModal":
            return .isModal
        #if os(iOS) || os(tvOS) || os(visionOS)
        case "isToggle":
            if #available(iOS 17.0, tvOS 17.0, *) {
                return .isToggle
            } else {
                return nil
            }
        #endif
        default:
            return nil
        }
    }
}

// MARK: - AccessibilityChildBehavior

extension AccessibilityChildBehavior: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self) {
            let name = memberAccess.declName.baseName.text
            switch name {
            case "ignore":
                self = .ignore
            case "combine":
                self = .combine
            case "contain":
                self = .contain
            default:
                return nil
            }
            return
        }
        return nil
    }
}
