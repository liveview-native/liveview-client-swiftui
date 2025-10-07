//
//  LightpandaRenderer.swift
//  LightpandaClient
//
//  Created by Carson.Katri on 10/7/25.
//

import SwiftUI
import LightpandaClient

public struct LightpandaRenderer<Library: ElementLibrary>: View {
    let document: Node
    
    public init(document: Node) {
        self.document = document
    }
    
    public var body: some View {
        if let tagName = Library.TagName(rawValue: document.name) {
            Library.render(tagName, for: document)
        } else {
            document.children(library: Library.self)
        }
    }
}
