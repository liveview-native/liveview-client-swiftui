//
//  TintModifier.swift
// LiveViewNative
//
//  Created by Shadowfacts on 9/14/22.
//

import SwiftUI

struct TintModifier: ViewModifier, Decodable {
    private let color: SwiftUI.Color?
    
    func body(content: Content) -> some View {
        content.tint(color)
    }
}
