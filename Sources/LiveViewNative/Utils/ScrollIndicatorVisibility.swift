//
//  ScrollIndicatorVisibility.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/28/23.
//

import SwiftUI

/// The visibility of scroll indicators of a UI element.
///
/// Possible values:
/// * `automatic`
/// * `hidden`
/// * `never`
/// * `visible`
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension ScrollIndicatorVisibility: Decodable {
    public init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        
        switch value {
        case "automatic": self = .automatic
        case "hidden": self = .hidden
        case "never": self = .never
        case "visible": self = .visible
        default:
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Unknown \(String(describing: decoder.codingPath.last)): \(value)"))
        }
    }
}
