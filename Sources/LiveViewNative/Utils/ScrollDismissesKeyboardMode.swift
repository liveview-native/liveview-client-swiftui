//
//  ScrollDismissesKeyboardMode.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/28/23.
//

import SwiftUI

/// The ways that scrollable content can interact with the software keyboard.
///
/// Possible values:
/// * `automatic`
/// * `immediately`
/// * `interactively`
/// * `never`
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension ScrollDismissesKeyboardMode: Decodable {
    public init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        
        switch value {
        case "automatic": self = .automatic
        case "immediately": self = .immediately
        case "interactively": self = .interactively
        case "never": self = .never
        default:
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Unknown \(String(describing: decoder.codingPath.last)): \(value)"))
        }
    }
}
