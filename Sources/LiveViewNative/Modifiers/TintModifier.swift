//
//  TintModifier.swift
// LiveViewNative
//
//  Created by Shadowfacts on 9/14/22.
//

import SwiftUI

struct TintModifier: ViewModifier, Decodable, Equatable {
    private let color: SwiftUI.Color?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.color = SwiftUI.Color(fromNamedOrCSSHex: try container.decode(String.self, forKey: .color))

        // self.color = try container.decode(Color.self, forKey: .color)
    }
    
    init(color: SwiftUI.Color) {
        self.color = color
    }
    
    func body(content: Content) -> some View {
        content.tint(color)
    }
    
    enum CodingKeys: String, CodingKey {
        case color
    }
}
