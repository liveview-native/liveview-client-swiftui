//
//  Stacks.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI
import SwiftSoup

struct PhxHStack: View {
    var element: Element
    var coordinator: LiveViewCoordinator
    
    var body: some View {
        HStack {
            ViewTreeBuilder.fromElements(element.children(), coordinator: coordinator)
        }
    }
}

struct PhxVStack: View {
    var element: Element
    var coordinator: LiveViewCoordinator
    
    var body: some View {
        VStack {
            ViewTreeBuilder.fromElements(element.children(), coordinator: coordinator)
        }
    }
}

struct PhxZStack: View {
    var element: Element
    var coordinator: LiveViewCoordinator
    
    var body: some View {
        ZStack {
            ViewTreeBuilder.fromElements(element.children(), coordinator: coordinator)
        }
    }
}
