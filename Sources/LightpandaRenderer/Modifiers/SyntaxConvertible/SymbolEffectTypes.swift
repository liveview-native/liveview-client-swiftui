import SwiftUI
import SwiftSyntax
import Symbols

// MARK: - SymbolEffectOptions

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SymbolEffectOptions: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Handle member access like .default, .nonRepeating, .repeating
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self) {
            let name = memberAccess.declName.baseName.text

            switch name {
            case "default": self = .default
            case "nonRepeating": self = .nonRepeating
            case "repeating": self = .repeating
            default: return nil
            }
            return
        }

        // Handle function calls like .speed(2.0), .repeat(3)
        if let functionCall = syntax.as(FunctionCallExprSyntax.self),
           let memberAccess = functionCall.calledExpression.as(MemberAccessExprSyntax.self) {
            let name = memberAccess.declName.baseName.text

            switch name {
            case "speed":
                if let speedArg = functionCall.arguments.first,
                   let speed = Double(syntax: speedArg.expression) {
                    self = .speed(speed)
                    return
                }
            case "repeat":
                if let countArg = functionCall.arguments.first,
                   let count = Int(syntax: countArg.expression) {
                    self = .repeat(count)
                    return
                }
            default:
                return nil
            }
        }

        return nil
    }
}

// MARK: - AnySymbolEffect

/// A type-erased symbol effect that can store any discrete or indefinite symbol effect.
/// This allows parsing symbol effects from syntax and applying them to views at runtime.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public enum AnySymbolEffect: Sendable {
    // Discrete effects (triggered by value change)
    case bounce
    case bounceUp
    case bounceDown
    case bounceWholeSymbol
    case bounceByLayer
    case pulse
    case pulseWholeSymbol
    case pulseByLayer
    case variableColor
    case variableColorIterative
    case variableColorCumulative
    case variableColorReversing
    case variableColorHideInactiveLayers
    case variableColorDimInactiveLayers

    // Indefinite effects (continuous, controlled by isActive)
    case scale
    case scaleUp
    case scaleDown
    case scaleWholeSymbol
    case scaleByLayer
    case breathe
    case breathePlain
    case breathePulse
    case rotate
    case rotateClockwise
    case rotateCounterClockwise
    case rotateWholeSymbol
    case rotateByLayer
    case wiggle
    case wiggleClockwise
    case wiggleCounterClockwise
    case wiggleForward
    case wiggleBackward
    case wiggleUp
    case wiggleDown
    case wiggleCustom(Double)  // angle in degrees

    /// Apply as a discrete effect triggered by value changes
    @MainActor @ViewBuilder
    func applyDiscrete<V: View, T: Equatable>(to view: V, options: SymbolEffectOptions, value: T) -> some View {
        switch self {
        case .bounce:
            view.symbolEffect(.bounce, options: options, value: value)
        case .bounceUp:
            view.symbolEffect(.bounce.up, options: options, value: value)
        case .bounceDown:
            view.symbolEffect(.bounce.down, options: options, value: value)
        case .bounceWholeSymbol:
            view.symbolEffect(.bounce.wholeSymbol, options: options, value: value)
        case .bounceByLayer:
            view.symbolEffect(.bounce.byLayer, options: options, value: value)
        case .pulse:
            view.symbolEffect(.pulse, options: options, value: value)
        case .pulseWholeSymbol:
            view.symbolEffect(.pulse.wholeSymbol, options: options, value: value)
        case .pulseByLayer:
            view.symbolEffect(.pulse.byLayer, options: options, value: value)
        case .variableColor:
            view.symbolEffect(.variableColor, options: options, value: value)
        case .variableColorIterative:
            view.symbolEffect(.variableColor.iterative, options: options, value: value)
        case .variableColorCumulative:
            view.symbolEffect(.variableColor.cumulative, options: options, value: value)
        case .variableColorReversing:
            view.symbolEffect(.variableColor.reversing, options: options, value: value)
        case .variableColorHideInactiveLayers:
            view.symbolEffect(.variableColor.hideInactiveLayers, options: options, value: value)
        case .variableColorDimInactiveLayers:
            view.symbolEffect(.variableColor.dimInactiveLayers, options: options, value: value)
        // For indefinite-only effects, just show the view unchanged when used as discrete
        case .scale, .scaleUp, .scaleDown, .scaleWholeSymbol, .scaleByLayer,
             .breathe, .breathePlain, .breathePulse,
             .rotate, .rotateClockwise, .rotateCounterClockwise, .rotateWholeSymbol, .rotateByLayer,
             .wiggle, .wiggleClockwise, .wiggleCounterClockwise, .wiggleForward, .wiggleBackward,
             .wiggleUp, .wiggleDown, .wiggleCustom:
            view
        }
    }

    /// Apply as an indefinite effect controlled by isActive
    @MainActor @ViewBuilder
    func applyIndefinite<V: View>(to view: V, options: SymbolEffectOptions, isActive: Bool) -> some View {
        switch self {
        case .bounce:
            view.symbolEffect(.bounce, options: options, isActive: isActive)
        case .bounceUp:
            view.symbolEffect(.bounce.up, options: options, isActive: isActive)
        case .bounceDown:
            view.symbolEffect(.bounce.down, options: options, isActive: isActive)
        case .bounceWholeSymbol:
            view.symbolEffect(.bounce.wholeSymbol, options: options, isActive: isActive)
        case .bounceByLayer:
            view.symbolEffect(.bounce.byLayer, options: options, isActive: isActive)
        case .pulse:
            view.symbolEffect(.pulse, options: options, isActive: isActive)
        case .pulseWholeSymbol:
            view.symbolEffect(.pulse.wholeSymbol, options: options, isActive: isActive)
        case .pulseByLayer:
            view.symbolEffect(.pulse.byLayer, options: options, isActive: isActive)
        case .variableColor:
            view.symbolEffect(.variableColor, options: options, isActive: isActive)
        case .variableColorIterative:
            view.symbolEffect(.variableColor.iterative, options: options, isActive: isActive)
        case .variableColorCumulative:
            view.symbolEffect(.variableColor.cumulative, options: options, isActive: isActive)
        case .variableColorReversing:
            view.symbolEffect(.variableColor.reversing, options: options, isActive: isActive)
        case .variableColorHideInactiveLayers:
            view.symbolEffect(.variableColor.hideInactiveLayers, options: options, isActive: isActive)
        case .variableColorDimInactiveLayers:
            view.symbolEffect(.variableColor.dimInactiveLayers, options: options, isActive: isActive)
        case .scale:
            view.symbolEffect(.scale, options: options, isActive: isActive)
        case .scaleUp:
            view.symbolEffect(.scale.up, options: options, isActive: isActive)
        case .scaleDown:
            view.symbolEffect(.scale.down, options: options, isActive: isActive)
        case .scaleWholeSymbol:
            view.symbolEffect(.scale.wholeSymbol, options: options, isActive: isActive)
        case .scaleByLayer:
            view.symbolEffect(.scale.byLayer, options: options, isActive: isActive)
        case .breathe:
            if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
                view.symbolEffect(.breathe, options: options, isActive: isActive)
            } else {
                view
            }
        case .breathePlain:
            if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
                view.symbolEffect(.breathe.plain, options: options, isActive: isActive)
            } else {
                view
            }
        case .breathePulse:
            if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
                view.symbolEffect(.breathe.pulse, options: options, isActive: isActive)
            } else {
                view
            }
        case .rotate:
            if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
                view.symbolEffect(.rotate, options: options, isActive: isActive)
            } else {
                view
            }
        case .rotateClockwise:
            if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
                view.symbolEffect(.rotate.clockwise, options: options, isActive: isActive)
            } else {
                view
            }
        case .rotateCounterClockwise:
            if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
                view.symbolEffect(.rotate.counterClockwise, options: options, isActive: isActive)
            } else {
                view
            }
        case .rotateWholeSymbol:
            if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
                view.symbolEffect(.rotate.wholeSymbol, options: options, isActive: isActive)
            } else {
                view
            }
        case .rotateByLayer:
            if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
                view.symbolEffect(.rotate.byLayer, options: options, isActive: isActive)
            } else {
                view
            }
        case .wiggle:
            if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
                view.symbolEffect(.wiggle, options: options, isActive: isActive)
            } else {
                view
            }
        case .wiggleClockwise:
            if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
                view.symbolEffect(.wiggle.clockwise, options: options, isActive: isActive)
            } else {
                view
            }
        case .wiggleCounterClockwise:
            if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
                view.symbolEffect(.wiggle.counterClockwise, options: options, isActive: isActive)
            } else {
                view
            }
        case .wiggleForward:
            if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
                view.symbolEffect(.wiggle.forward, options: options, isActive: isActive)
            } else {
                view
            }
        case .wiggleBackward:
            if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
                view.symbolEffect(.wiggle.backward, options: options, isActive: isActive)
            } else {
                view
            }
        case .wiggleUp:
            if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
                view.symbolEffect(.wiggle.up, options: options, isActive: isActive)
            } else {
                view
            }
        case .wiggleDown:
            if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
                view.symbolEffect(.wiggle.down, options: options, isActive: isActive)
            } else {
                view
            }
        case .wiggleCustom(let angle):
            if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
                view.symbolEffect(.wiggle.custom(angle: .degrees(angle)), options: options, isActive: isActive)
            } else {
                view
            }
        }
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension AnySymbolEffect: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Handle simple member access like .bounce, .pulse, .variableColor
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self) {
            let name = memberAccess.declName.baseName.text

            switch name {
            case "bounce": self = .bounce
            case "pulse": self = .pulse
            case "variableColor": self = .variableColor
            case "scale": self = .scale
            case "breathe": self = .breathe
            case "rotate": self = .rotate
            case "wiggle": self = .wiggle
            default: return nil
            }
            return
        }

        // Handle chained member access like .bounce.up, .variableColor.iterative
        // These appear as nested MemberAccessExprSyntax structures
        if let outerAccess = syntax.as(MemberAccessExprSyntax.self),
           let innerAccess = outerAccess.base?.as(MemberAccessExprSyntax.self) {
            let baseName = innerAccess.declName.baseName.text
            let modifierName = outerAccess.declName.baseName.text

            switch (baseName, modifierName) {
            // Bounce variants
            case ("bounce", "up"): self = .bounceUp
            case ("bounce", "down"): self = .bounceDown
            case ("bounce", "wholeSymbol"): self = .bounceWholeSymbol
            case ("bounce", "byLayer"): self = .bounceByLayer
            // Pulse variants
            case ("pulse", "wholeSymbol"): self = .pulseWholeSymbol
            case ("pulse", "byLayer"): self = .pulseByLayer
            // Variable color variants
            case ("variableColor", "iterative"): self = .variableColorIterative
            case ("variableColor", "cumulative"): self = .variableColorCumulative
            case ("variableColor", "reversing"): self = .variableColorReversing
            case ("variableColor", "hideInactiveLayers"): self = .variableColorHideInactiveLayers
            case ("variableColor", "dimInactiveLayers"): self = .variableColorDimInactiveLayers
            // Scale variants
            case ("scale", "up"): self = .scaleUp
            case ("scale", "down"): self = .scaleDown
            case ("scale", "wholeSymbol"): self = .scaleWholeSymbol
            case ("scale", "byLayer"): self = .scaleByLayer
            // Breathe variants
            case ("breathe", "plain"): self = .breathePlain
            case ("breathe", "pulse"): self = .breathePulse
            // Rotate variants
            case ("rotate", "clockwise"): self = .rotateClockwise
            case ("rotate", "counterClockwise"): self = .rotateCounterClockwise
            case ("rotate", "wholeSymbol"): self = .rotateWholeSymbol
            case ("rotate", "byLayer"): self = .rotateByLayer
            // Wiggle variants
            case ("wiggle", "clockwise"): self = .wiggleClockwise
            case ("wiggle", "counterClockwise"): self = .wiggleCounterClockwise
            case ("wiggle", "forward"): self = .wiggleForward
            case ("wiggle", "backward"): self = .wiggleBackward
            case ("wiggle", "up"): self = .wiggleUp
            case ("wiggle", "down"): self = .wiggleDown
            default: return nil
            }
            return
        }

        // Handle function calls like .wiggle.custom(angle: .degrees(45))
        if let functionCall = syntax.as(FunctionCallExprSyntax.self),
           let memberAccess = functionCall.calledExpression.as(MemberAccessExprSyntax.self) {
            let functionName = memberAccess.declName.baseName.text

            // Check if base is another member access (e.g., .wiggle.custom)
            if let baseAccess = memberAccess.base?.as(MemberAccessExprSyntax.self) {
                let baseName = baseAccess.declName.baseName.text

                if baseName == "wiggle" && functionName == "custom" {
                    // Parse .wiggle.custom(angle: .degrees(45))
                    if let angleArg = functionCall.argument(named: "angle"),
                       let angle = Self.parseAngleDegrees(angleArg.expression) {
                        self = .wiggleCustom(angle)
                        return
                    }
                }
            }
        }

        return nil
    }

    /// Parse an angle expression like .degrees(45) or .radians(0.5)
    private static func parseAngleDegrees(_ syntax: ExprSyntax) -> Double? {
        if let functionCall = syntax.as(FunctionCallExprSyntax.self),
           let memberAccess = functionCall.calledExpression.as(MemberAccessExprSyntax.self) {
            let name = memberAccess.declName.baseName.text

            if let valueArg = functionCall.arguments.first,
               let value = Double(syntax: valueArg.expression) {
                switch name {
                case "degrees":
                    return value
                case "radians":
                    return value * 180.0 / .pi
                default:
                    return nil
                }
            }
        }
        return nil
    }
}
