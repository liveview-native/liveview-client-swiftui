//
//  GridItem.swift
//  
//
//  Created by Carson Katri on 2/15/23.
//

import SwiftUI

extension GridItem: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let size: Size
        if let fixed = try container.decode(Double?.self, forKey: .fixed) {
            size = .fixed(fixed)
        } else if let flexible = try container.decode(Bounds?.self, forKey: .flexible) {
            size = .flexible(minimum: flexible.minimum, maximum: flexible.maximum)
        } else {
            let adaptive = try container.decode(Bounds.self, forKey: .adaptive)
            size = .adaptive(minimum: adaptive.minimum, maximum: adaptive.maximum)
        }
        self.init(
            size,
            spacing: try container.decode(Double?.self, forKey: .spacing).flatMap(CGFloat.init),
            alignment: try container.decode(Alignment?.self, forKey: .alignment)
        )
    }
    
    enum CodingKeys: String, CodingKey {
        case fixed
        case flexible
        case adaptive
        
        case spacing
        case alignment
    }
    
    struct Bounds: Decodable {
        let minimum: Double
        let maximum: Double
    }
}
