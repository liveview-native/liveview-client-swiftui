//
//  TintModifier.swift
// LiveViewNative
//
//  Created by Shadowfacts on 9/14/22.
//

import SwiftUI

struct TintModifier: ViewModifier, Decodable, Equatable {
    // TODO: Documentation
    private let color: SwiftUI.Color?
    
    init(color: SwiftUI.Color) {
        self.color = color
    }
    
    func body(content: Content) -> some View {
        content.tint(color)
    }
}
