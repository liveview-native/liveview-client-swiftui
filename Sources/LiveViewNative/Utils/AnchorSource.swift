//
//  AnchorSource.swift
//  
//
//  Created by Carson Katri on 5/23/23.
//

import SwiftUI

/// A reference to rect layout data.
///
/// There are several types of anchor source.
///
/// ### :bounds
/// Creates an anchor source rect from the bounding rect of the element.
///
/// ```elixir
/// :bounds
/// ```
///
/// ### :rect
/// Creates an anchor source rect with the given ``LiveViewNative/CoreFoundation/CGRect``.
///
/// ```elixir
/// {:rect, [[0, 0], [100, 100]]}
/// ```
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension Anchor<CGRect>.Source: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(RectAnchorSourceType.self, forKey: .type) {
        case .rect:
            self = .rect(try container.decode(CGRect.self, forKey: .properties))
        case .bounds:
            self = .bounds
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case properties
    }
    
    enum RectAnchorSourceType: String, Decodable {
        case rect
        case bounds
    }
}
