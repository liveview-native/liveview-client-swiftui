//
//  NavigationTitleModifier.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 9/12/22.
//

import SwiftUI

struct NavigationTitleModifier: ViewModifier {
    private let title: String
    
    init(string value: String) {
        self.title = value
    }
    
    func body(content: Content) -> some View {
        content
            .navigationTitle(title)
    }
}
