import SwiftUI
import SwiftSyntax

/// Modifier for setting environment values.
/// Since WritableKeyPath cannot be parsed from syntax, this supports common environment values explicitly.
///
/// Usage:
/// - `.environment(\.colorScheme, .dark)`
/// - `.environment(\.layoutDirection, .rightToLeft)`
/// - `.environment(\.isEnabled, false)`
/// - `.environment(\.locale, Locale(identifier: "fr"))`
public enum EnvironmentModifier<Library: ElementLibrary>: @unchecked Sendable {
    case colorScheme(ColorScheme)
    case layoutDirection(LayoutDirection)
    case isEnabled(Bool)
}

extension EnvironmentModifier: RuntimeViewModifier {
    public static var baseName: String { "environment" }

    public init(syntax: FunctionCallExprSyntax) throws {
        var errors: [Error] = []

        // Parse the keypath from the first argument
        guard let firstArg = syntax.arguments.first,
              let keyPathExpr = firstArg.expression.as(KeyPathExprSyntax.self),
              let component = keyPathExpr.components.first,
              let propertyName = component.component.as(KeyPathPropertyComponentSyntax.self)?.declName.baseName.text
        else {
            throw ModifierParseError.missingRequiredArgument(modifier: "EnvironmentModifier", argument: "keyPath")
        }

        // Get the value from the second argument
        guard syntax.arguments.count > 1 else {
            throw ModifierParseError.missingRequiredArgument(modifier: "EnvironmentModifier", argument: "value")
        }
        let valueArg = syntax.arguments[syntax.arguments.index(after: syntax.arguments.startIndex)]

        // Match on keypath property name and parse appropriate value
        switch propertyName {
        case "colorScheme":
            do {
                guard let value = ColorScheme(syntax: valueArg.expression) else {
                    throw ModifierParseError.invalidArgumentValue(modifier: "EnvironmentModifier", argument: "colorScheme", reason: "Expected .light or .dark")
                }
                self = .colorScheme(value)
                return
            } catch {
                errors.append(error)
            }

        case "layoutDirection":
            do {
                guard let value = LayoutDirection(syntax: valueArg.expression) else {
                    throw ModifierParseError.invalidArgumentValue(modifier: "EnvironmentModifier", argument: "layoutDirection", reason: "Expected .leftToRight or .rightToLeft")
                }
                self = .layoutDirection(value)
                return
            } catch {
                errors.append(error)
            }

        case "isEnabled":
            do {
                guard let value = Bool(syntax: valueArg.expression) else {
                    throw ModifierParseError.invalidArgumentValue(modifier: "EnvironmentModifier", argument: "isEnabled", reason: "Expected true or false")
                }
                self = .isEnabled(value)
                return
            } catch {
                errors.append(error)
            }

        default:
            throw ModifierParseError.unsupportedEnvironmentKey(modifier: "EnvironmentModifier", key: propertyName)
        }

        throw ModifierParseError.noMatchingVariant(modifier: "EnvironmentModifier", errors: errors)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .colorScheme(let value):
            _content.environment(\.colorScheme, value)
        case .layoutDirection(let value):
            _content.environment(\.layoutDirection, value)
        case .isEnabled(let value):
            _content.environment(\.isEnabled, value)
        }
    }
}
