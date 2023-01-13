//
//  TintModifier.swift
// LiveViewNative
//
//  Created by Shadowfacts on 9/14/22.
//

import SwiftUI

struct TintModifier: ViewModifier, Decodable, Equatable {
    private let color: Color?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.color = Color(fromNamedOrCSSHex: try container.decode(String.self, forKey: .color))
    }
    
    init(color: Color) {
        self.color = color
    }
    
    func body(content: Content) -> some View {
        content.tint(color)
    }
    
    enum CodingKeys: String, CodingKey {
        case color
    }
}
