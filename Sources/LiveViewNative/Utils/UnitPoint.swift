//
//  UnitPoint.swift
//  
//
//  Created by Carson Katri on 2/14/23.
//

import SwiftUI
import LiveViewNativeCore
import RegexBuilder

/// Decodes a unit point from a string value.
///
/// The value may be a named constant, or a comma-separated X/Y pair (e.g., `0,0.25`).
///
/// Named values:
/// - `zero`
/// - `center`
/// - `leading`
/// - `trailing`
/// - `top`
/// - `bottom`
/// - `top-leading`
/// - `top-trailing`
/// - `bottom-leading`
/// - `bottom-trailing`
extension UnitPoint: AttributeDecodable {
    public init(from attribute: LiveViewNativeCore.Attribute?, on element: ElementNode) throws {
        guard let value = attribute?.value else { throw AttributeDecodingError.missingAttribute(Self.self) }
        try self.init(from: value)
    }
}

extension UnitPoint {
    init(from value: String) throws {
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
        case "top-leading", "top_leading":
            self = .topLeading
        case "top-trailing", "top_trailing":
            self = .topTrailing
        case "bottom-leading", "bottom_leading":
            self = .bottomLeading
        case "bottom-trailing", "bottom_trailing":
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
}
