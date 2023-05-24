//
//  KeyEquivalent.swift
//  
//
//  Created by murtza on 24/05/2023.
//

import SwiftUI

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
#if os(iOS) || os(macOS)
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension KeyEquivalent: Decodable {
    public init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        switch value {
        case "up_arrow":
            self = .upArrow
        case "down_arrow":
            self = .downArrow
        case "left_arrow":
            self = .leftArrow
        case "right_arrow":
            self = .rightArrow
        case "clear":
            self = .clear
        case "delete":
            self = .delete
        case "end":
            self = .end
        case "escap":
            self = .escape
        case "home":
            self = .home
        case "page_up":
            self = .pageUp
        case "page_down":
            self = .pageDown
        case "return":
            self = .return
        case "space":
            self = .space
        case "tab":
            self = .tab
        case let char where char.count == 1:
            self = KeyEquivalent(Character(char))
        case let `default`:
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Unknown key equivalent '\(`default`)'"))
        }
    }
}
#endif
