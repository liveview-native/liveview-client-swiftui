import SwiftUI
import SwiftSyntax

extension BlendMode: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }
        
        let name = memberAccess.declName.baseName.text
        
        switch name {
        case "normal": self = .normal
        case "multiply": self = .multiply
        case "screen": self = .screen
        case "overlay": self = .overlay
        case "darken": self = .darken
        case "lighten": self = .lighten
        case "colorDodge": self = .colorDodge
        case "colorBurn": self = .colorBurn
        case "softLight": self = .softLight
        case "hardLight": self = .hardLight
        case "difference": self = .difference
        case "exclusion": self = .exclusion
        case "hue": self = .hue
        case "saturation": self = .saturation
        case "color": self = .color
        case "luminosity": self = .luminosity
        case "sourceAtop": self = .sourceAtop
        case "destinationOver": self = .destinationOver
        case "destinationOut": self = .destinationOut
        case "plusDarker": self = .plusDarker
        case "plusLighter": self = .plusLighter
        default: return nil
        }
    }
}
