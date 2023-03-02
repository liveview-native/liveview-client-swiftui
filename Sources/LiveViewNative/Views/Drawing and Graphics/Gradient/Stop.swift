//
//  Stop.swift
// LiveViewNative
//
//  Created by May Matyi on 2/17/23.
//

import SwiftUI

extension Gradient.Stop: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let color: SwiftUI.Color = try container.decode(SwiftUI.Color.self, forKey: .color)
        let location: CGFloat = try container.decode(CGFloat.self, forKey: .location)
    
        self = Gradient.Stop(color: color, location: location)
    }
    
    enum CodingKeys: String, CodingKey {
        case color
        case location
    }
}
