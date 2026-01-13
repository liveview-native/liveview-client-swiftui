import SwiftUI
import SwiftSyntax

/// Modifier for adding keyboard shortcuts to buttons and controls.
///
/// Usage:
/// ```html
/// <button modifiers="keyboardShortcut(.defaultAction)">
/// <button modifiers="keyboardShortcut(.cancelAction)">
/// <button modifiers='keyboardShortcut("s", modifiers: .command)'>
/// ```
#if os(iOS) || os(macOS)
public enum KeyboardShortcutModifier<Library: ElementLibrary>: @unchecked Sendable {
    case shortcut(KeyboardShortcut)
    case keyAndModifiers(KeyEquivalent, EventModifiers)
}

extension KeyboardShortcutModifier: RuntimeViewModifier {
    public static var baseName: String { "keyboardShortcut" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // Try parsing as a KeyboardShortcut first (.defaultAction, .cancelAction)
        if let firstArg = syntax.arguments.first,
           let shortcut = KeyboardShortcut(syntax: firstArg.expression) {
            self = .shortcut(shortcut)
            return
        }

        // Try parsing as key + modifiers
        if let firstArg = syntax.arguments.first,
           let key = KeyEquivalent(syntax: firstArg.expression) {
            let modifiers = syntax.argument(named: "modifiers")
                .flatMap({ EventModifiers(syntax: $0.expression) }) ?? .command
            self = .keyAndModifiers(key, modifiers)
            return
        }

        throw ModifierParseError.noMatchingVariant(modifier: "KeyboardShortcutModifier", errors: [])
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .shortcut(let shortcut):
            _content.keyboardShortcut(shortcut)
        case .keyAndModifiers(let key, let modifiers):
            _content.keyboardShortcut(key, modifiers: modifiers)
        }
    }
}

extension KeyboardShortcut: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self),
              memberAccess.base == nil else { return nil }

        switch memberAccess.declName.baseName.text {
        case "defaultAction":
            self = .defaultAction
        case "cancelAction":
            self = .cancelAction
        default:
            return nil
        }
    }
}

extension KeyEquivalent: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Handle string literal like "s" or "a"
        if let stringLiteral = syntax.as(StringLiteralExprSyntax.self),
           let segment = stringLiteral.segments.first?.as(StringSegmentSyntax.self),
           let firstChar = segment.content.text.first {
            self.init(firstChar)
            return
        }

        // Handle member access like .return, .escape, .delete, etc.
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self),
           memberAccess.base == nil {
            switch memberAccess.declName.baseName.text {
            case "return":
                self = .return
            case "tab":
                self = .tab
            case "space":
                self = .space
            case "clear":
                self = .clear
            case "delete":
                self = .delete
            case "deleteForward":
                self = .deleteForward
            case "upArrow":
                self = .upArrow
            case "downArrow":
                self = .downArrow
            case "leftArrow":
                self = .leftArrow
            case "rightArrow":
                self = .rightArrow
            case "pageUp":
                self = .pageUp
            case "pageDown":
                self = .pageDown
            case "home":
                self = .home
            case "end":
                self = .end
            case "escape":
                self = .escape
            default:
                return nil
            }
            return
        }

        return nil
    }
}

extension EventModifiers: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self),
              memberAccess.base == nil else { return nil }

        switch memberAccess.declName.baseName.text {
        case "command":
            self = .command
        case "shift":
            self = .shift
        case "option":
            self = .option
        case "control":
            self = .control
        case "capsLock":
            self = .capsLock
        case "numericPad":
            self = .numericPad
        case "function":
            self = .function
        case "all":
            self = .all
        default:
            return nil
        }
    }
}
#endif
