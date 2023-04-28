//
//  ContentMode.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/28/23.
//

import SwiftUI

/// The size classes that apply to controls.
///
/// Possible values:
/// * `fill`
/// * `fit`
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension ContentMode: Decodable {
    public init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        switch value {
        case "fill":
            self = .fill
        case "fit":
            self = .fit
        default:
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Unknown \(String(describing: decoder.codingPath.last)): \(value)"))
        }
    }
}
