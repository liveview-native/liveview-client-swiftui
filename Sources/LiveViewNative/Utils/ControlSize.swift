//
//  ControlSize.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 4/19/23.
//

import SwiftUI

#if !os(tvOS)
/// The size classes that apply to controls.
///
/// Possible values:
/// * `mini`
/// * `small`
/// * `regular`
/// * `large`
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension ControlSize: Decodable {
    public init(from decoder: Decoder) throws {
        switch try decoder.singleValueContainer().decode(String.self) {
        case "mini":
            self = .mini
        case "small":
            self = .small
        case "regular":
            self = .regular
        case "large":
            self = .large
        case let `default`:
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Unknown control size '\(`default`)'"))
        }
    }
}
#endif
