//
//  NodeView.swift
//  LightpandaClient
//
//  Created by Carson.Katri on 10/7/25.
//

import SwiftUI
import LightpandaClient

public struct NodeView<Library: ElementLibrary>: View {
    let node: Node
    
    public var body: some View {
        if let tagName = Library.TagName(rawValue: node.name) {
            Library.render(tagName, for: node)
        } else {
            node.children(library: Library.self)
        }
    }
}
