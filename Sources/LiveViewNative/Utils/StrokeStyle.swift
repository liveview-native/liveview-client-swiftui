//
//  StrokeStyle.swift
//  LiveViewNative
//
//  Created by Carson Katri on 5/11/23.
//

import SwiftUI

/// Configuration for stroking a ``Shape``.
///
/// Create a map or keyword list to represent the style.
///
/// ```elixir
/// [line_width: 10, dash: [10, 20], line_cap: :round]
/// ```
///
/// ## Arguments
/// * `line_width` - The thickness of the line. Defaults to `1`.
/// * `line_cap` - The style of line endpoints. See ``LiveViewNative/SwiftUI/CGLineCap`` for a list of possible values. Defaults to `butt`.
/// * `line_join` - The style of line junctions. See ``LiveViewNative/SwiftUI/CGLineJoin`` for a list of possible values. Defaults to `miter`.
/// * `miter_limit` - Threshold that determines when to use a bevel instead of a miter. Defaults to `10`.
/// * `dash` - A list of lengths for filled and empty segments of a dashed line. Defaults to `[]`
/// * `dash_phase` - An offset for the dash pattern. Defaults to `0`
extension StrokeStyle: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(
            lineWidth: try container.decode(CGFloat.self, forKey: .lineWidth),
            lineCap: try container.decode(CGLineCap.self, forKey: .lineCap),
            lineJoin: try container.decode(CGLineJoin.self, forKey: .lineJoin),
            miterLimit: try container.decode(CGFloat.self, forKey: .miterLimit),
            dash: try container.decode([CGFloat].self, forKey: .dash),
            dashPhase: try container.decode(CGFloat.self, forKey: .dashPhase)
        )
    }
    
    enum CodingKeys: CodingKey {
        case lineWidth
        case lineCap
        case lineJoin
        case miterLimit
        case dash
        case dashPhase
    }
}

/// Style for the endpoint of a stroke.
///
/// Possible values:
/// * `butt`
/// * `round`
/// * `square`
extension CGLineCap: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "butt": self = .butt
        case "round": self = .round
        case "square": self = .square
        case let `default`: throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "Unknown line cap '\(`default`)'"))
        }
    }
}

/// Style for the stroke junctions.
///
/// Possible values:
/// * `miter`
/// * `round`
/// * `bevel`
extension CGLineJoin: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "miter": self = .miter
        case "round": self = .round
        case "bevel": self = .bevel
        case let `default`: throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "Unknown line join '\(`default`)'"))
        }
    }
}
