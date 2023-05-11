//
//  FillStyle.swift
//  LiveViewNative
//
//  Created by Carson Katri on 5/11/23.
//

import SwiftUI

/// Configuration for filling a ``Shape``.
///
/// Create a map or keyword list with values for `eo_fill` and/or `antialiased`.
///
/// ```elixir
/// [eo_fill: true, antialiased: false]
/// ```
///
/// ## Arguments
/// * `eo_fill` - Whether to use an even-odd rule. Defaults to `false`.
/// * `antialiased` - Enable/disable antialiasing on the shape's edges. Defaults to `true`.
extension FillStyle: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(
            eoFill: try container.decode(Bool.self, forKey: .eoFill),
            antialiased: try container.decode(Bool.self, forKey: .antialiased)
        )
    }
    
    enum CodingKeys: CodingKey {
        case eoFill
        case antialiased
    }
}
