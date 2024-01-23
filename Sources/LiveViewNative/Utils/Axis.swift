//
//  Axis.swift
//
//
//  Created by Carson Katri on 2/14/23.
//

import SwiftUI
import LiveViewNativeCore

/// A set of axes.
///
/// Possible values:
/// * `horizontal`
/// * `vertical`
/// * `all` - both `horizontal` and `vertical`
extension Axis.Set: AttributeDecodable {
    init?(string: String) {
        switch string {
        case "horizontal":
            self = .horizontal
        case "vertical":
            self = .vertical
        case "all":
            self = [.horizontal, .vertical]
        default:
            return nil
        }
    }
    
    public init(from attribute: LiveViewNativeCore.Attribute?, on element: ElementNode) throws {
        guard let value = attribute?.value else { throw AttributeDecodingError.missingAttribute(Self.self) }
        guard let result = Self(string: value) else { throw AttributeDecodingError.badValue(Self.self) }
        self = result
    }
}
