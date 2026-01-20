import SwiftUI
import SwiftSyntax
import Accessibility

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

// MARK: - AccessibilityHeadingLevel

extension AccessibilityHeadingLevel: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "unspecified": self = .unspecified
        case "h1": self = .h1
        case "h2": self = .h2
        case "h3": self = .h3
        case "h4": self = .h4
        case "h5": self = .h5
        case "h6": self = .h6
        default: return nil
        }
    }
}

// MARK: - AccessibilityTextContentType

extension AccessibilityTextContentType: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "plain": self = .plain
        case "console": self = .console
        case "fileSystem": self = .fileSystem
        case "messaging": self = .messaging
        case "narrative": self = .narrative
        case "sourceCode": self = .sourceCode
        case "spreadsheet": self = .spreadsheet
        case "wordProcessing": self = .wordProcessing
        default: return nil
        }
    }
}

// MARK: - AccessibilityDirectTouchOptions

extension AccessibilityDirectTouchOptions: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "silentOnTouch": self = .silentOnTouch
        case "requiresActivation": self = .requiresActivation
        default: return nil
        }
    }
}

// MARK: - AccessibilityActionCategory

extension AccessibilityActionCategory: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "default": self = .default
        case "edit": self = .edit
        default: return nil
        }
    }
}

// MARK: - AccessibilitySystemRotor

extension AccessibilitySystemRotor: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "links": self = .links
        case "headings": self = .headings
        case "boldText": self = .boldText
        case "italicText": self = .italicText
        case "underlineText": self = .underlineText
        case "misspelledWords": self = .misspelledWords
        case "images": self = .images
        case "textFields": self = .textFields
        case "tables": self = .tables
        case "lists": self = .lists
        case "landmarks": self = .landmarks
        default: return nil
        }
    }
}

// MARK: - AccessibilityCustomContentKey

extension AccessibilityCustomContentKey: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Handle AccessibilityCustomContentKey("label") constructor
        if let functionCall = syntax.as(FunctionCallExprSyntax.self) {
            // Check if it's a constructor call like AccessibilityCustomContentKey("...")
            if let memberAccess = functionCall.calledExpression.as(MemberAccessExprSyntax.self),
               memberAccess.declName.baseName.text == "AccessibilityCustomContentKey",
               let firstArg = functionCall.arguments.first,
               let stringValue = String(syntax: firstArg.expression) {
                self.init(LocalizedStringKey(stringValue))
                return
            }
            // Direct call like AccessibilityCustomContentKey("...")
            if let declRef = functionCall.calledExpression.as(DeclReferenceExprSyntax.self),
               declRef.baseName.text == "AccessibilityCustomContentKey",
               let firstArg = functionCall.arguments.first,
               let stringValue = String(syntax: firstArg.expression) {
                self.init(LocalizedStringKey(stringValue))
                return
            }
        }

        // Handle string literal directly as a convenience
        if let stringValue = String(syntax: syntax) {
            self.init(LocalizedStringKey(stringValue))
            return
        }

        return nil
    }
}

// MARK: - AXCustomContent.Importance

extension AXCustomContent.Importance: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "default": self = .default
        case "high": self = .high
        default: return nil
        }
    }
}
