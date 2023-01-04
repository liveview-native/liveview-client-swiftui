//
//  PaddingModifier.swift
// LiveViewNative
//
//  Created by Shadowfacts on 9/12/22.
//

import SwiftUI

struct PaddingModifier: ViewModifier, Decodable, Equatable {
    private let insets: EdgeInsets
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.insets = try container.decode(EdgeInsets.self)
    }
    
    init(insets: EdgeInsets) {
        self.insets = insets
    }
    
    func body(content: Content) -> some View {
        content.padding(insets)
    }
}
