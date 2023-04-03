//
//  BoldModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 3/23/23.
//

import SwiftUI

struct BoldModifier: ViewModifier, Decodable {
    /// Enables/disables the bold effect.
    private var active: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.active = try container.decodeIfPresent(Bool.self, forKey: .active) ?? true
    }

    func body(content: Content) -> some View {
        content.bold(active)
    }
    
    enum CodingKeys: String, CodingKey {
        case active
    }
}
