//
//  PaddingModifier.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 9/12/22.
//

import SwiftUI

struct PaddingModifier: ViewModifier {
    private let insets: EdgeInsets
    
    init(string value: String) {
        self.insets = try! BuiltinRegistry.attributeDecoder.decode(EdgeInsets.self, from: value.data(using: .utf8)!)
    }
    
    func body(content: Content) -> some View {
        content.padding(insets)
    }
}
