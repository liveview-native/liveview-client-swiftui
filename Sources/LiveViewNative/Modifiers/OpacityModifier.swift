//
//  OpacityModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 3/28/23.
//

import SwiftUI

struct OpacityModifier: ViewModifier, Decodable, Equatable {
    private let opacity: Double?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.opacity = try container.decode(Double.self, forKey: .opacity)
    }
    
    init(opacity: Double) {
        self.opacity = opacity
    }
    
    func body(content: Content) -> some View {
        content.opacity(opacity!)
    }
    
    enum CodingKeys: String, CodingKey {
        case opacity
    }
}
