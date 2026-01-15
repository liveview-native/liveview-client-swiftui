import SwiftUI
import SwiftSyntax
import Symbols
import LightpandaClient

/// Modifier for adding symbol effect animations to SF Symbol images.
///
/// Usage:
/// ```html
/// <!-- Indefinite effect (continuous animation) -->
/// <image systemname="wifi" modifiers="symbolEffect(.variableColor, isActive: $animating)" />
/// <image systemname="bell" modifiers="symbolEffect(.bounce, options: .repeating, isActive: $active)" />
///
/// <!-- Discrete effect (triggered by value change) -->
/// <image systemname="star.fill" modifiers="symbolEffect(.bounce, value: count)" />
/// <image systemname="heart.fill" modifiers="symbolEffect(.pulse, options: .speed(2), value: likes)" />
///
/// <!-- Effect variants -->
/// <image systemname="wifi" modifiers="symbolEffect(.variableColor.iterative)" />
/// <image systemname="arrow.up" modifiers="symbolEffect(.bounce.up)" />
/// <image systemname="star" modifiers="symbolEffect(.scale.up, isActive: $highlighted)" />
/// ```
///
/// Supported effects:
/// - `.bounce`, `.bounce.up`, `.bounce.down`, `.bounce.wholeSymbol`, `.bounce.byLayer`
/// - `.pulse`, `.pulse.wholeSymbol`, `.pulse.byLayer`
/// - `.variableColor`, `.variableColor.iterative`, `.variableColor.cumulative`, `.variableColor.reversing`
/// - `.scale`, `.scale.up`, `.scale.down` (iOS 17+)
/// - `.breathe`, `.breathe.plain`, `.breathe.pulse` (iOS 18+)
/// - `.rotate`, `.rotate.clockwise`, `.rotate.counterClockwise` (iOS 18+)
/// - `.wiggle`, `.wiggle.up`, `.wiggle.down`, `.wiggle.forward`, `.wiggle.backward` (iOS 18+)
///
/// Options:
/// - `.default`, `.repeating`, `.nonRepeating`
/// - `.speed(Double)`, `.repeat(Int)`
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public enum SymbolEffectModifier<Library: ElementLibrary>: @unchecked Sendable {
    /// Indefinite effect controlled by isActive attribute
    case effectOptionsIsActive(AnySymbolEffect, options: SymbolEffectOptions, isActiveAttribute: String)
    /// Discrete effect triggered by value attribute changes
    case effectOptionsValue(AnySymbolEffect, options: SymbolEffectOptions, valueAttribute: String)
    /// Simple indefinite effect (always active)
    case effectOptions(AnySymbolEffect, options: SymbolEffectOptions)
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SymbolEffectModifier: RuntimeViewModifier {
    public static var baseName: String { "symbolEffect" }

    public init(syntax: FunctionCallExprSyntax) throws {
        var errors: [Error] = []

        // Try parsing .symbolEffect(effect, options:, isActive: $attribute)
        do {
            guard let effectArg = syntax.arguments.first,
                  let effect = AnySymbolEffect(syntax: effectArg.expression) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "SymbolEffectModifier", argument: "effect")
            }

            let options: SymbolEffectOptions = syntax.argument(named: "options")
                .flatMap({ SymbolEffectOptions(syntax: $0.expression) }) ?? .default

            // Check for isActive: $attribute binding
            if let isActiveArg = syntax.argument(named: "isActive") {
                if let prefixExpr = isActiveArg.expression.as(PrefixOperatorExprSyntax.self),
                   prefixExpr.operator.text == "$",
                   let declRef = prefixExpr.expression.as(DeclReferenceExprSyntax.self) {
                    let attributeName = declRef.baseName.text
                    self = .effectOptionsIsActive(effect, options: options, isActiveAttribute: attributeName)
                    return
                } else if let boolValue = Bool(syntax: isActiveArg.expression) {
                    // Direct boolean value - treat as always active/inactive
                    if boolValue {
                        self = .effectOptions(effect, options: options)
                    } else {
                        // isActive: false - no effect needed
                        self = .effectOptions(effect, options: .nonRepeating)
                    }
                    return
                }
            }

            // Check for value: attribute trigger
            if let valueArg = syntax.argument(named: "value") {
                if let declRef = valueArg.expression.as(DeclReferenceExprSyntax.self) {
                    let attributeName = declRef.baseName.text
                    self = .effectOptionsValue(effect, options: options, valueAttribute: attributeName)
                    return
                }
            }

            // No isActive or value - default to simple effect (always active)
            self = .effectOptions(effect, options: options)
            return
        } catch {
            errors.append(error)
        }

        throw ModifierParseError.noMatchingVariant(modifier: "SymbolEffectModifier", errors: errors)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .effectOptionsIsActive(let effect, let options, let isActiveAttribute):
            SymbolEffectIsActiveBody(effect: effect, options: options, attributeName: isActiveAttribute, content: _content)
        case .effectOptionsValue(let effect, let options, let valueAttribute):
            SymbolEffectValueBody(effect: effect, options: options, attributeName: valueAttribute, content: _content)
        case .effectOptions(let effect, let options):
            effect.applyIndefinite(to: _content, options: options, isActive: true)
        }
    }
}

/// Helper view for isActive-based symbol effects
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
private struct SymbolEffectIsActiveBody<Content: View>: View {
    let effect: AnySymbolEffect
    let options: SymbolEffectOptions
    let attributeName: String
    let content: Content

    @Environment(Node.self) private var node

    var body: some View {
        let isActive = node.attributes[attributeName] != nil &&
                       node.attributes[attributeName] != "false" &&
                       node.attributes[attributeName] != "0"
        effect.applyIndefinite(to: content, options: options, isActive: isActive)
    }
}

/// Helper view for value-triggered symbol effects
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
private struct SymbolEffectValueBody<Content: View>: View {
    let effect: AnySymbolEffect
    let options: SymbolEffectOptions
    let attributeName: String
    let content: Content

    @Environment(Node.self) private var node

    var body: some View {
        let value = node.attributes[attributeName] ?? ""
        effect.applyDiscrete(to: content, options: options, value: value)
    }
}
