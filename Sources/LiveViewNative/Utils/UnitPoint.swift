//
//  UnitPoint.swift
//  
//
//  Created by Carson Katri on 2/14/23.
//

import SwiftUI
import LiveViewNativeCore
import RegexBuilder

extension UnitPoint: Decodable, AttributeDecodable {
    public init(from value: String) throws {
        switch value {
        case "zero":
            self = .zero
        case "center":
            self = .center
        case "leading":
            self = .leading
        case "trailing":
            self = .trailing
        case "top":
            self = .top
        case "bottom":
            self = .bottom
        case "top-leading":
            self = .topLeading
        case "top-trailing":
            self = .topTrailing
        case "bottom-leading":
            self = .bottomLeading
        case "bottom-trailing":
            self = .bottomTrailing
        default:
            let doublePattern = Regex {
                Optionally("-")
                OneOrMore(.digit)
                Optionally {
                    "."
                    OneOrMore(.digit)
                }
            }
            let pattern = Regex {
                Capture {
                    doublePattern
                } transform: { Double($0) }
                OneOrMore {
                    ChoiceOf {
                        ","
                        OneOrMore(.whitespace)
                    }
                }
                Capture {
                    doublePattern
                } transform: { Double($0) }
            }
            .anchorsMatchLineEndings()

            guard let (_, x, y) = value.firstMatch(of: pattern)?.output,
                  let x,
                  let y
            else { throw AttributeDecodingError.badValue(Self.self) }
            self = .init(x: x, y: y)
        }
    }
    
    public init(from attribute: LiveViewNativeCore.Attribute?) throws {
        guard let value = attribute?.value else { throw AttributeDecodingError.missingAttribute(Self.self) }
        try self.init(from: value)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(
            x: try container.decode(Double.self, forKey: .x),
            y: try container.decode(Double.self, forKey: .y)
        )
    }
    
    enum CodingKeys: String, CodingKey {
        case x
        case y
    }
}
