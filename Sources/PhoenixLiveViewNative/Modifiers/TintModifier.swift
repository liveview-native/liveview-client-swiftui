//
//  TintModifier.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 9/14/22.
//

import SwiftUI

struct TintModifier: ViewModifier {
    private let color: Color?
    
    init(string value: String) {
        self.color = Color(fromNamedOrCSSHex: value)
    }
    
    func body(content: Content) -> some View {
        content.tint(color)
    }
}
