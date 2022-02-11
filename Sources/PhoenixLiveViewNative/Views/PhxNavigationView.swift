//
//  PhxNavigationView.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI
import SwiftSoup

struct PhxNavigationView: View {
    private let element: Element
    private let coordinator: LiveViewCoordinator
    
    init(element: Element, coordinator: LiveViewCoordinator) {
        self.element = element
        self.coordinator = coordinator
    }
    
    var body: some View {
        NavigationView {
            ViewTreeBuilder.fromElements(element.children(), coordinator: coordinator)
            // todo: make this configurable
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
