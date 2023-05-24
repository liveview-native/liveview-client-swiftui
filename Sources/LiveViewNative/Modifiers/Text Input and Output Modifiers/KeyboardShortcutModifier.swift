//
//  KeyboardShortcutModifier.swift
//  
//
//  Created by murtza on 18/05/2023.
//

import SwiftUI

/// Assigns a keyboard shortcut to the modified control.
///
/// ```html
/// <Button modifiers={keyboard_shortcut(@native, key: "+")}>Click Me!</Button>
/// <Button modifiers={keyboard_shortcut(@native, key: "7")}>Click Me!</Button>
/// <Button modifiers={keyboard_shortcut(@native, key: "s", modifiers: [:command])}>Click Me!</Button>
/// <Button modifiers={keyboard_shortcut(@native, key: "s", modifiers: [:command, :shift])}>Click Me!</Button>
/// ```
///
/// ## Arguments
/// * ``key``
/// * ``modifiers``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 14.0, macOS 11.0, *)
struct KeyboardShortcutModifier: ViewModifier, Decodable {
    #if !os(iOS) && !os(macOS)
    typealias KeyEquivalent = Never
    #endif
    /// The key equivalent that the user presses in conjunction with any specified modifier keys to activate the shortcut.
    /// One of the `KeyEquivalent` enumerations.
    ///
    /// Possible values:
    /// * `up_arrow`
    /// * `down_arrow`
    /// * `left_arrow`
    /// * `right_arrow`
    /// * `clear`
    /// * `delete`
    /// * `end`
    /// * `escape`
    /// * `home`
    /// * `page_up`
    /// * `page_down`
    /// * `return`
    /// * `space`
    /// * `tab`
    /// * `a-z`
    /// * `A-Z`
    /// * `0-9`
    /// * `!@#$%^*()-_=+[]{}|:"'<>,./?`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private var key: KeyEquivalent
    /// The modifier keys that the user presses in conjunction with a key equivalent to activate the shortcut.
    ///
    /// See ``LiveViewNative/SwiftUI/EventModifiers`` for a list possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let modifiers: EventModifiers = []
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        #if os(iOS) || os(macOS)
        let value = try container.decode(String.self, forKey: .key)
        
        switch value {
        case "up_arrow":
            key = .upArrow
        case "down_arrow":
            key = .downArrow
        case "left_arrow":
            key = .leftArrow
        case "right_arrow":
            key = .rightArrow
        case "clear":
            key = .clear
        case "delete":
            key = .delete
        case "end":
            key = .end
        case "escap":
            key = .escape
        case "home":
            key = .home
        case "page_up":
            key = .pageUp
        case "page_down":
            key = .pageDown
        case "return":
            key = .return
        case "space":
            key = .space
        case "tab":
            key = .tab
        case "a"..."z", "A"..."Z", "0"..."9":
            key = KeyEquivalent(Character(value))
        case let character where Set("!@#$%^*()-_=+[]{}|:;\"'<>,./?").contains(Character(character)):
            key = KeyEquivalent(Character(character))
        default:
            throw DecodingError.dataCorruptedError(forKey: .key, in: container, debugDescription: "invalid value for key")
        }
        
        #else
        throw DecodingError.typeMismatch(Self.self, .init(codingPath: container.codingPath, debugDescription: "`keyboard_shortcut` modifier not available on this platform"))
        #endif
    }

    func body(content: Content) -> some View {
        content
            #if os(iOS) || os(macOS)
            .keyboardShortcut(key, modifiers: modifiers)
            #endif
    }
    
    enum CodingKeys: String, CodingKey {
        case key
        case modifiers
    }
}
