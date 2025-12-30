import SwiftUI
import SwiftSyntax

extension AnyShapeStyle: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Try Color first (most common)
        if let color = Color(syntax: syntax) {
            self = .init(color)
            return
        }
        
        // Try member access for static properties (e.g., .primary, .ultraThinMaterial)
        // Also handles chained hierarchical accessors like .blue.tertiary
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self) {
            let name = memberAccess.declName.baseName.text
            
            // Check if this is a chained accessor on another style (e.g., .blue.tertiary)
            if let base = memberAccess.base {
                // Try to parse the base as a style first
                if let baseStyle = AnyShapeStyle(syntax: base) {
                    // Apply hierarchical accessor to the base style
                    switch name {
                    case "secondary":
                        self = .init(baseStyle.secondary)
                        return
                    case "tertiary":
                        self = .init(baseStyle.tertiary)
                        return
                    case "quaternary":
                        self = .init(baseStyle.quaternary)
                        return
                    case "quinary":
                        self = .init(baseStyle.quinary)
                        return
                    default:
                        break
                    }
                }
            }
            
            // Hierarchical styles (standalone, e.g., .primary)
            switch name {
            case "primary":
                self = .init(HierarchicalShapeStyle.primary)
                return
            case "secondary":
                self = .init(HierarchicalShapeStyle.secondary)
                return
            case "tertiary":
                self = .init(HierarchicalShapeStyle.tertiary)
                return
            case "quaternary":
                self = .init(HierarchicalShapeStyle.quaternary)
                return
            case "quinary":
                self = .init(HierarchicalShapeStyle.quinary)
                return
            default:
                break
            }
            
            // Semantic styles
            switch name {
            case "foreground":
                self = .init(ForegroundStyle())
                return
            case "background":
                self = .init(BackgroundStyle())
                return
            case "selection":
                self = .init(SelectionShapeStyle.selection)
                return
            case "separator":
                self = .init(SeparatorShapeStyle.separator)
                return
            case "tint":
                self = .init(TintShapeStyle.tint)
                return
            case "placeholder":
                self = .init(PlaceholderTextShapeStyle.placeholder)
                return
            case "link":
                self = .init(LinkShapeStyle.link)
                return
            case "fill":
                self = .init(FillShapeStyle.fill)
                return
            case "windowBackground":
                self = .init(WindowBackgroundShapeStyle.windowBackground)
                return
            default:
                break
            }
            
            // Materials
            switch name {
            case "ultraThinMaterial":
                self = .init(Material.ultraThinMaterial)
                return
            case "thinMaterial":
                self = .init(Material.thinMaterial)
                return
            case "regularMaterial":
                self = .init(Material.regularMaterial)
                return
            case "thickMaterial":
                self = .init(Material.thickMaterial)
                return
            case "ultraThickMaterial":
                self = .init(Material.ultraThickMaterial)
                return
            case "bar":
                self = .init(Material.bar)
                return
            default:
                break
            }
        }
        
        // Try function calls for gradients and style modifiers
        if let functionCall = syntax.as(FunctionCallExprSyntax.self) {
            // Try style modifiers first (e.g., .blue.opacity(0.5))
            if let style = Self.parseStyleModifier(functionCall) {
                self = style
                return
            }
            
            // Try gradients
            if let style = Self.parseGradient(functionCall) {
                self = style
                return
            }
        }
        
        return nil
    }
    
    // MARK: - Style Modifier Parsing
    
    private static func parseStyleModifier(_ functionCall: FunctionCallExprSyntax) -> AnyShapeStyle? {
        guard let memberAccess = functionCall.calledExpression.as(MemberAccessExprSyntax.self),
              let base = memberAccess.base else {
            return nil
        }
        
        let methodName = memberAccess.declName.baseName.text
        
        // Parse the base style
        guard let baseStyle = AnyShapeStyle(syntax: base) else {
            return nil
        }
        
        switch methodName {
        case "opacity":
            // .blue.opacity(0.5)
            guard let firstArg = functionCall.arguments.first,
                  let opacity = Double(syntax: firstArg.expression) else {
                return nil
            }
            return AnyShapeStyle(baseStyle.opacity(opacity))
            
        case "blendMode":
            // .blue.blendMode(.multiply)
            guard let firstArg = functionCall.arguments.first,
                  let blendMode = BlendMode(syntax: firstArg.expression) else {
                return nil
            }
            return AnyShapeStyle(baseStyle.blendMode(blendMode))
            
        case "shadow":
            // .blue.shadow(.drop(radius: 5))
            guard let firstArg = functionCall.arguments.first,
                  let shadowStyle = ShadowStyle(syntax: firstArg.expression) else {
                return nil
            }
            return AnyShapeStyle(baseStyle.shadow(shadowStyle))
            
        default:
            return nil
        }
    }
    
    // MARK: - Gradient Parsing
    
    private static func parseGradient(_ functionCall: FunctionCallExprSyntax) -> AnyShapeStyle? {
        let calledExpr = functionCall.calledExpression
        
        // Handle .linearGradient, .radialGradient, etc.
        guard let memberAccess = calledExpr.as(MemberAccessExprSyntax.self) else {
            return nil
        }
        
        let name = memberAccess.declName.baseName.text
        
        switch name {
        case "linearGradient":
            return parseLinearGradient(functionCall)
        case "radialGradient":
            return parseRadialGradient(functionCall)
        case "angularGradient":
            return parseAngularGradient(functionCall)
        case "conicGradient":
            return parseConicGradient(functionCall)
        case "ellipticalGradient":
            return parseEllipticalGradient(functionCall)
        default:
            return nil
        }
    }
    
    private static func parseLinearGradient(_ functionCall: FunctionCallExprSyntax) -> AnyShapeStyle? {
        let startPoint: UnitPoint = functionCall.argument(named: "startPoint").flatMap { UnitPoint(syntax: $0.expression) } ?? .leading
        let endPoint: UnitPoint = functionCall.argument(named: "endPoint").flatMap { UnitPoint(syntax: $0.expression) } ?? .trailing
        
        // Try colors array first
        if let colorsArg = functionCall.argument(named: "colors"),
           let colors = parseColorArray(colorsArg.expression) {
            return AnyShapeStyle(LinearGradient(colors: colors, startPoint: startPoint, endPoint: endPoint))
        }
        
        // Try stops array
        if let stopsArg = functionCall.argument(named: "stops"),
           let stops = parseStopsArray(stopsArg.expression) {
            return AnyShapeStyle(LinearGradient(stops: stops, startPoint: startPoint, endPoint: endPoint))
        }
        
        return nil
    }
    
    private static func parseRadialGradient(_ functionCall: FunctionCallExprSyntax) -> AnyShapeStyle? {
        let center: UnitPoint = functionCall.argument(named: "center").flatMap { UnitPoint(syntax: $0.expression) } ?? .center
        let startRadius: CGFloat = functionCall.argument(named: "startRadius").flatMap { CGFloat(syntax: $0.expression) } ?? 0
        let endRadius: CGFloat = functionCall.argument(named: "endRadius").flatMap { CGFloat(syntax: $0.expression) } ?? 100
        
        // Try colors array first
        if let colorsArg = functionCall.argument(named: "colors"),
           let colors = parseColorArray(colorsArg.expression) {
            return AnyShapeStyle(RadialGradient(colors: colors, center: center, startRadius: startRadius, endRadius: endRadius))
        }
        
        // Try stops array
        if let stopsArg = functionCall.argument(named: "stops"),
           let stops = parseStopsArray(stopsArg.expression) {
            return AnyShapeStyle(RadialGradient(stops: stops, center: center, startRadius: startRadius, endRadius: endRadius))
        }
        
        return nil
    }
    
    private static func parseAngularGradient(_ functionCall: FunctionCallExprSyntax) -> AnyShapeStyle? {
        let center: UnitPoint = functionCall.argument(named: "center").flatMap { UnitPoint(syntax: $0.expression) } ?? .center
        let startAngle: Angle = functionCall.argument(named: "startAngle").flatMap { Angle(syntax: $0.expression) } ?? .zero
        let endAngle: Angle = functionCall.argument(named: "endAngle").flatMap { Angle(syntax: $0.expression) } ?? .degrees(360)
        
        // Try colors array first
        if let colorsArg = functionCall.argument(named: "colors"),
           let colors = parseColorArray(colorsArg.expression) {
            return AnyShapeStyle(AngularGradient(colors: colors, center: center, startAngle: startAngle, endAngle: endAngle))
        }
        
        // Try stops array
        if let stopsArg = functionCall.argument(named: "stops"),
           let stops = parseStopsArray(stopsArg.expression) {
            return AnyShapeStyle(AngularGradient(stops: stops, center: center, startAngle: startAngle, endAngle: endAngle))
        }
        
        return nil
    }
    
    private static func parseConicGradient(_ functionCall: FunctionCallExprSyntax) -> AnyShapeStyle? {
        let center: UnitPoint = functionCall.argument(named: "center").flatMap { UnitPoint(syntax: $0.expression) } ?? .center
        let angle: Angle = functionCall.argument(named: "angle").flatMap { Angle(syntax: $0.expression) } ?? .zero
        
        // Try colors array first
        if let colorsArg = functionCall.argument(named: "colors"),
           let colors = parseColorArray(colorsArg.expression) {
            return AnyShapeStyle(AngularGradient(colors: colors, center: center, angle: angle))
        }
        
        // Try stops array
        if let stopsArg = functionCall.argument(named: "stops"),
           let stops = parseStopsArray(stopsArg.expression) {
            return AnyShapeStyle(AngularGradient(stops: stops, center: center, angle: angle))
        }
        
        return nil
    }
    
    private static func parseEllipticalGradient(_ functionCall: FunctionCallExprSyntax) -> AnyShapeStyle? {
        let center: UnitPoint = functionCall.argument(named: "center").flatMap { UnitPoint(syntax: $0.expression) } ?? .center
        let startRadiusFraction: CGFloat = functionCall.argument(named: "startRadiusFraction").flatMap { CGFloat(syntax: $0.expression) } ?? 0
        let endRadiusFraction: CGFloat = functionCall.argument(named: "endRadiusFraction").flatMap { CGFloat(syntax: $0.expression) } ?? 0.5
        
        // Try colors array first
        if let colorsArg = functionCall.argument(named: "colors"),
           let colors = parseColorArray(colorsArg.expression) {
            return AnyShapeStyle(EllipticalGradient(colors: colors, center: center, startRadiusFraction: startRadiusFraction, endRadiusFraction: endRadiusFraction))
        }
        
        // Try stops array
        if let stopsArg = functionCall.argument(named: "stops"),
           let stops = parseStopsArray(stopsArg.expression) {
            return AnyShapeStyle(EllipticalGradient(stops: stops, center: center, startRadiusFraction: startRadiusFraction, endRadiusFraction: endRadiusFraction))
        }
        
        return nil
    }
    
    // MARK: - Array Parsing Helpers
    
    private static func parseColorArray(_ syntax: some SyntaxProtocol) -> [Color]? {
        guard let arrayExpr = syntax.as(ArrayExprSyntax.self) else {
            return nil
        }
        
        var colors: [Color] = []
        for element in arrayExpr.elements {
            guard let color = Color(syntax: element.expression) else {
                return nil
            }
            colors.append(color)
        }
        return colors
    }
    
    private static func parseStopsArray(_ syntax: some SyntaxProtocol) -> [Gradient.Stop]? {
        guard let arrayExpr = syntax.as(ArrayExprSyntax.self) else {
            return nil
        }
        
        var stops: [Gradient.Stop] = []
        for element in arrayExpr.elements {
            guard let stop = Gradient.Stop(syntax: element.expression) else {
                return nil
            }
            stops.append(stop)
        }
        return stops
    }
}
