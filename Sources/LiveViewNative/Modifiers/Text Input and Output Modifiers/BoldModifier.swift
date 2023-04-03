//
//  BoldModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 3/23/23.
//

import SwiftUI

struct BoldModifier: ViewModifier, Decodable {
    /// Enables/disables the bold effect.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private var active: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.active = try container.decode(Bool.self, forKey: .active)
    }

    func body(content: Content) -> some View {
        content.bold(active)
    }
    
    enum CodingKeys: String, CodingKey {
        case active
    }
}
