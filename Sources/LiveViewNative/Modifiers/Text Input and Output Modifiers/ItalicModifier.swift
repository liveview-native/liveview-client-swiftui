//
//  ItalicModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 3/23/23.
//

import SwiftUI

struct ItalicModifier: ViewModifier, Decodable {
    /// Enables/disables the italic effect.
    private var active: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.active = try container.decodeIfPresent(Bool.self, forKey: .active) ?? true
    }

    func body(content: Content) -> some View {
        content.italic(active)
    }
    
    enum CodingKeys: String, CodingKey {
        case active
    }
}
