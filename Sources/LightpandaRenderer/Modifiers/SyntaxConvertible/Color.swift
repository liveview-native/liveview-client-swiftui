import SwiftUI
import SwiftSyntax

extension Color: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Handle member access expressions (e.g., Color.red, .blue)
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self) {
            if memberAccess.base == nil {
                // Static color constants without base
                switch memberAccess.declName.baseName.text {
                case "red": self = .red
                case "orange": self = .orange
                case "yellow": self = .yellow
                case "green": self = .green
                case "mint": self = .mint
                case "teal": self = .teal
                case "cyan": self = .cyan
                case "blue": self = .blue
                case "indigo": self = .indigo
                case "purple": self = .purple
                case "pink": self = .pink
                case "brown": self = .brown
                case "white": self = .white
                case "gray": self = .gray
                case "black": self = .black
                case "clear": self = .clear
                case "primary": self = .primary
                case "secondary": self = .secondary
                case "accentColor": self = .accentColor
                default: return nil
                }
                return
            } else if let base = memberAccess.base?.as(DeclReferenceExprSyntax.self),
                      base.baseName.text == "Color" {
                // Color.red format
                switch memberAccess.declName.baseName.text {
                case "red": self = .red
                case "orange": self = .orange
                case "yellow": self = .yellow
                case "green": self = .green
                case "mint": self = .mint
                case "teal": self = .teal
                case "cyan": self = .cyan
                case "blue": self = .blue
                case "indigo": self = .indigo
                case "purple": self = .purple
                case "pink": self = .pink
                case "brown": self = .brown
                case "white": self = .white
                case "gray": self = .gray
                case "black": self = .black
                case "clear": self = .clear
                case "primary": self = .primary
                case "secondary": self = .secondary
                case "accentColor": self = .accentColor
                default: return nil
                }
                return
            }
        }
        
        // Handle function call expressions (e.g., Color(red:green:blue:))
        if let functionCall = syntax.as(FunctionCallExprSyntax.self) {
            // Ensure it's a Color initializer
            guard let calledExpr = functionCall.calledExpression.as(DeclReferenceExprSyntax.self),
                  calledExpr.baseName.text == "Color"
            else { return nil }
            
            let args = functionCall.arguments
            
            // Color(_ name: String, bundle: Bundle?)
            if args.count >= 1,
               let firstArg = args.first,
               firstArg.label == nil,
               let stringLiteral = firstArg.expression.as(StringLiteralExprSyntax.self),
               let nameValue = stringLiteral.segments.first?.as(StringSegmentSyntax.self)?.content.text {
                self = Color(nameValue)
                return
            }
            
            // Parse RGB components (red, green, blue, opacity)
            var red: Double?
            var green: Double?
            var blue: Double?
            var opacity: Double = 1.0
            var colorSpace: Color.RGBColorSpace = .sRGB
            
            // Parse HSB components (hue, saturation, brightness)
            var hue: Double?
            var saturation: Double?
            var brightness: Double?
            
            // Parse grayscale (white)
            var white: Double?
            
            for arg in args {
                let label = arg.label?.text
                let value = Double(syntax: arg.expression)
                
                switch label {
                case "red": red = value
                case "green": green = value
                case "blue": blue = value
                case "opacity": opacity = value ?? 1.0
                case "hue": hue = value
                case "saturation": saturation = value
                case "brightness": brightness = value
                case "white": white = value
                case "colorSpace":
                    if let memberAccess = arg.expression.as(MemberAccessExprSyntax.self) {
                        switch memberAccess.declName.baseName.text {
                        case "sRGB": colorSpace = .sRGB
                        case "sRGBLinear": colorSpace = .sRGBLinear
                        case "displayP3": colorSpace = .displayP3
                        default: break
                        }
                    }
                default: break
                }
            }
            
            // Color(red:green:blue:opacity:)
            if let r = red, let g = green, let b = blue {
                self = Color(colorSpace, red: r, green: g, blue: b, opacity: opacity)
                return
            }
            
            // Color(hue:saturation:brightness:opacity:)
            if let h = hue, let s = saturation, let b = brightness {
                self = Color(hue: h, saturation: s, brightness: b, opacity: opacity)
                return
            }
            
            // Color(white:opacity:)
            if let w = white {
                self = Color(colorSpace, white: w, opacity: opacity)
                return
            }
        }
        
        return nil
    }
}
