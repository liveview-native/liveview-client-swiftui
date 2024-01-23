//
//  Font.swift
//  
//
//  Created by Carson Katri on 4/5/23.
//

import SwiftUI
import LiveViewNativeCore

/// A system text style.
///
/// Possible values:
/// * `large_title`
/// * `title`
/// * `title2`
/// * `title3`
/// * `headline`
/// * `subheadline`
/// * `body`
/// * `callout`
/// * `footnote`
/// * `caption`
/// * `caption2`
@_documentation(visibility: public)
extension Font.TextStyle: AttributeDecodable {
    public init(from attribute: LiveViewNativeCore.Attribute?, on element: ElementNode) throws {
        guard let value = attribute?.value
        else { throw AttributeDecodingError.missingAttribute(Self.self) }
        try self.init(from: value)
    }
    
    public init(from string: String) throws {
        switch string {
        case "large_title", "large-title": self = .largeTitle
        case "title": self = .title
        case "title2": self = .title2
        case "title3": self = .title3
        case "headline": self = .headline
        case "subheadline": self = .subheadline
        case "body": self = .body
        case "callout": self = .callout
        case "footnote": self = .footnote
        case "caption": self = .caption
        case "caption2": self = .caption2
        case let `default`: throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Unknown style named \(`default`)"))
        }
    }
}
