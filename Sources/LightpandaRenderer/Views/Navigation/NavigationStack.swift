//
//  NavigationStack.swift
//
//
//  Created by Carson Katri on 11/16/23.
//

import SwiftUI
import LightpandaClient

struct NavigationStack<Library: ElementLibrary>: View {
    let node: Node
    
    @Environment(\.namespaces)
    private var namespaces
    
    var body: some View {
        SwiftUI.NavigationStack {
            SwiftUI.VStack {
                node.children(library: Library.self)
            }
        }
    }
}
