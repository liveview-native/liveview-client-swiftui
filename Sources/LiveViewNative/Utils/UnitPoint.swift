//
//  UnitPoint.swift
//  
//
//  Created by Carson Katri on 2/14/23.
//

import SwiftUI

extension UnitPoint: Decodable {
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
