//
//  ListRowInsetsModifier.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 9/14/22.
//

import SwiftUI

struct ListRowInsetsModifier: ViewModifier {
    private let insets: EdgeInsets
    
    init(string value: String) {
        self.insets = try! BuiltinRegistry.attributeDecoder.decode(EdgeInsets.self, from: value.data(using: .utf8)!)
    }
    
    func body(content: Content) -> some View {
        content.listRowInsets(insets)
    }
}
