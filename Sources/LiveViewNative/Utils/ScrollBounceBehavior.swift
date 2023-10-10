//
//  ScrollBounceBehavior.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/28/23.
//

import SwiftUI

/// The ways that a scrollable view can bounce when it reaches the end of its content.
///
/// Possible values:
/// * `automatic`
/// * `always`
/// * `based_on_size`
#if swift(>=5.8)
@_documentation(visibility: public)
@available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
extension ScrollBounceBehavior: Decodable {
    public init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        
        switch value {
        case "automatic": self = .automatic
        case "always": self = .always
        case "based_on_size": self = .basedOnSize
        default:
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Unknown \(String(describing: decoder.codingPath.last)): \(value)"))
        }
    }
}
#endif
