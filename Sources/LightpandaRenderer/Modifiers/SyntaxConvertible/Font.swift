import SwiftUI
import SwiftSyntax

extension Font: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Handle member access expressions (e.g., .body, Font.title)
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self) {
            let fontName = memberAccess.declName.baseName.text
            
            // Check if this is a dot access (.body) or fully qualified (Font.body)
            let isValidFontAccess: Bool
            if memberAccess.base == nil {
                // Dot access like .body
                isValidFontAccess = true
            } else if let base = memberAccess.base?.as(DeclReferenceExprSyntax.self) {
                isValidFontAccess = base.baseName.text == "Font"
            } else {
                isValidFontAccess = false
            }
            
            guard isValidFontAccess else { return nil }
            
            // Handle static font constants
            switch fontName {
            case "largeTitle":
                self = .largeTitle
            case "title":
                self = .title
            case "title2":
                self = .title2
            case "title3":
                self = .title3
            case "headline":
                self = .headline
            case "subheadline":
                self = .subheadline
            case "body":
                self = .body
            case "callout":
                self = .callout
            case "footnote":
                self = .footnote
            case "caption":
                self = .caption
            case "caption2":
                self = .caption2
            #if os(iOS)
            case "default":
                self = .default
            #endif
            default:
                return nil
            }
            return
        }
        
        // Handle function call expressions
        if let functionCall = syntax.as(FunctionCallExprSyntax.self) {
            // Parse the function being called
            let functionName: String?
            
            if let declRef = functionCall.calledExpression.as(DeclReferenceExprSyntax.self) {
                functionName = declRef.baseName.text
            } else if let memberAccess = functionCall.calledExpression.as(MemberAccessExprSyntax.self) {
                functionName = memberAccess.declName.baseName.text
            } else {
                functionName = nil
            }
            
            guard let name = functionName else { return nil }
            
            let args = functionCall.arguments
            
            switch name {
            // Font.system(size:weight:design:)
            case "system":
                // Check if first argument is a TextStyle or size
                guard let firstArg = args.first else { return nil }
                
                // Font.system(_:design:weight:) with TextStyle
                if firstArg.label == nil {
                    // Could be TextStyle or size - check the type
                    if let textStyle = TextStyle(syntax: firstArg.expression) {
                        var design: Font.Design?
                        var weight: Font.Weight?
                        
                        for arg in args.dropFirst() {
                            switch arg.label?.text {
                            case "design":
                                design = Font.Design(syntax: arg.expression)
                            case "weight":
                                weight = Font.Weight(syntax: arg.expression)
                            default:
                                break
                            }
                        }
                        
                        self = .system(textStyle, design: design, weight: weight)
                        return
                    }
                }
                
                // Font.system(size:weight:design:)
                var size: CGFloat?
                var weight: Font.Weight?
                var design: Font.Design?
                
                for arg in args {
                    switch arg.label?.text {
                    case "size":
                        size = CGFloat(syntax: arg.expression)
                    case "weight":
                        weight = Font.Weight(syntax: arg.expression)
                    case "design":
                        design = Font.Design(syntax: arg.expression)
                    default:
                        break
                    }
                }
                
                if let s = size {
                    self = .system(size: s, weight: weight, design: design)
                    return
                }
                
                return nil
                
            // Font.custom(_:size:) / Font.custom(_:size:relativeTo:) / Font.custom(_:fixedSize:)
            case "custom":
                var name: String?
                var size: CGFloat?
                var fixedSize: CGFloat?
                var relativeTo: Font.TextStyle?
                
                for arg in args {
                    let label = arg.label?.text
                    
                    if label == nil, name == nil {
                        // First unlabeled argument is the font name
                        name = String(syntax: arg.expression)
                    } else {
                        switch label {
                        case "size":
                            size = CGFloat(syntax: arg.expression)
                        case "fixedSize":
                            fixedSize = CGFloat(syntax: arg.expression)
                        case "relativeTo":
                            relativeTo = TextStyle(syntax: arg.expression)
                        default:
                            break
                        }
                    }
                }
                
                guard let fontName = name else { return nil }
                
                if let fixed = fixedSize {
                    self = .custom(fontName, fixedSize: fixed)
                    return
                } else if let s = size {
                    if let relative = relativeTo {
                        self = .custom(fontName, size: s, relativeTo: relative)
                    } else {
                        self = .custom(fontName, size: s)
                    }
                    return
                }
                
                return nil
                
            // Font modifiers (chained calls)
            case "italic", "bold", "weight", "width", "leading", "monospacedDigit",
                 "monospaced", "smallCaps", "lowercaseSmallCaps", "uppercaseSmallCaps",
                 "pointSize", "scaled":
                // These are modifiers on an existing font
                // We need to parse the base font from the member access
                guard let memberAccess = functionCall.calledExpression.as(MemberAccessExprSyntax.self),
                      let baseFont = memberAccess.base.flatMap(Font.init(syntax:)) ?? Font(syntax: memberAccess)
                else { return nil }
                
                // Apply the modifier
                self = applyModifier(to: baseFont, modifier: name, arguments: args)
                return
                
            default:
                return nil
            }
        }
        
        return nil
    }
}

// Helper to apply font modifiers
private func applyModifier(to font: Font, modifier: String, arguments: LabeledExprListSyntax) -> Font {
    switch modifier {
    #if os(iOS)
    case "italic":
        if let arg = arguments.first, arg.label == nil {
            if let isActive = Bool(syntax: arg.expression) {
                return font.italic(isActive)
            }
        }
        return font.italic()
    case "bold":
        if let arg = arguments.first, arg.label == nil {
            if let isActive = Bool(syntax: arg.expression) {
                return font.bold(isActive)
            }
        }
        return font.bold()
    #endif
    case "weight":
        if let arg = arguments.first,
           let weight = Font.Weight(syntax: arg.expression) {
            return font.weight(weight)
        }
        return font
        
    case "width":
        if let arg = arguments.first,
           let width = Font.Width(syntax: arg.expression) {
            return font.width(width)
        }
        return font
        
    case "leading":
        if let arg = arguments.first,
           let leading = Font.Leading(syntax: arg.expression) {
            return font.leading(leading)
        }
        return font
        
    case "monospacedDigit":
        return font.monospacedDigit()
        
    #if os(iOS)
    case "monospaced":
        if let arg = arguments.first, arg.label == nil {
            if let isActive = Bool(syntax: arg.expression) {
                return font.monospaced(isActive)
            }
        }
        return font.monospaced()
        
    case "smallCaps":
        if let arg = arguments.first, arg.label == nil {
            if let isActive = Bool(syntax: arg.expression) {
                return font.smallCaps(isActive)
            }
        }
        return font.smallCaps()
        
    case "lowercaseSmallCaps":
        if let arg = arguments.first, arg.label == nil {
            if let isActive = Bool(syntax: arg.expression) {
                return font.lowercaseSmallCaps(isActive)
            }
        }
        return font.lowercaseSmallCaps()
        
    case "uppercaseSmallCaps":
        if let arg = arguments.first, arg.label == nil {
            if let isActive = Bool(syntax: arg.expression) {
                return font.uppercaseSmallCaps(isActive)
            }
        }
        return font.uppercaseSmallCaps()
        
    case "pointSize":
        if let arg = arguments.first,
           let size = CGFloat(syntax: arg.expression) {
            return font.pointSize(size)
        }
        return font
        
    case "scaled":
        if let arg = arguments.first,
           let factor = CGFloat(syntax: arg.expression) {
            return font.scaled(by: factor)
        }
        return font
    #endif
    default:
        return font
    }
}

// Font.TextStyle parser
extension Font.TextStyle: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self) {
            switch memberAccess.declName.baseName.text {
            case "largeTitle": self = .largeTitle
            case "title": self = .title
            case "title2": self = .title2
            case "title3": self = .title3
            case "headline": self = .headline
            case "subheadline": self = .subheadline
            case "body": self = .body
            case "callout": self = .callout
            case "footnote": self = .footnote
            case "caption": self = .caption
            case "caption2": self = .caption2
            default: return nil
            }
            return
        }
        return nil
    }
}

// Font.Weight parser
extension Font.Weight: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self) {
            switch memberAccess.declName.baseName.text {
            case "ultraLight": self = .ultraLight
            case "thin": self = .thin
            case "light": self = .light
            case "regular": self = .regular
            case "medium": self = .medium
            case "semibold": self = .semibold
            case "bold": self = .bold
            case "heavy": self = .heavy
            case "black": self = .black
            default: return nil
            }
            return
        }
        return nil
    }
}

// Font.Width parser
extension Font.Width: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Handle member access (.compressed, .condensed, etc.)
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self) {
            switch memberAccess.declName.baseName.text {
            case "compressed": self = .compressed
            case "condensed": self = .condensed
            case "standard": self = .standard
            case "expanded": self = .expanded
            default: return nil
            }
            return
        }
        
        // Handle Font.Width(value:) initializer
        if let functionCall = syntax.as(FunctionCallExprSyntax.self),
           let firstArg = functionCall.arguments.first,
           let value = CGFloat(syntax: firstArg.expression) {
            self.init(value)
            return
        }
        
        return nil
    }
}

// Font.Design parser
extension Font.Design: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self) {
            switch memberAccess.declName.baseName.text {
            case "default": self = .default
            case "serif": self = .serif
            case "rounded": self = .rounded
            case "monospaced": self = .monospaced
            default: return nil
            }
            return
        }
        return nil
    }
}

// Font.Leading parser
extension Font.Leading: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self) {
            switch memberAccess.declName.baseName.text {
            case "standard": self = .standard
            case "tight": self = .tight
            case "loose": self = .loose
            default: return nil
            }
            return
        }
        return nil
    }
}
