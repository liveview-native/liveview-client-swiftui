//
//  EventModifiers.swift
//  
//
//  Created by murtza on 24/05/2023.
//

import SwiftUI

/// The modifier keys that the user presses in conjunction with a key equivalent to activate the shortcut.
///
/// Possible values:
/// * `all`
/// * `caps_lock`
/// * `command`
/// * `control`
/// * `numeric_pad`
/// * `option`
/// * `shift`
/// * An array of these values
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension EventModifiers: Decodable {
    public init(from decoder: Decoder) throws {
        if var container = try? decoder.unkeyedContainer() {
            var result = Self()
            while !container.isAtEnd {
                result.insert(try container.decode(EventModifiers.self))
            }
            self = result
        } else {
            let container = try decoder.singleValueContainer()
            switch try container.decode(String.self) {
            case "all":
                self = .all
            case "caps_lock":
                self = .capsLock
            case "command":
                self = .command
            case "control":
                self = .control
            case "numeric_pad":
                self = .numericPad
            case "option":
                self = .option
            case "shift":
                self = .shift
            case let `default`:
                throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Unknown event_modifier '\(`default`)'"))
            }
        }
    }
}
