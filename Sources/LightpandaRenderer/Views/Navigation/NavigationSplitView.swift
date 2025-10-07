//
//  NavigationStack.swift
//
//
//  Created by Carson Katri on 11/16/23.
//

import SwiftUI
import LightpandaClient

struct NavigationSplitView<Library: ElementLibrary>: View {
    let node: Node
    
    var body: some View {
        if hasContent && hasDetail {
            SwiftUI.NavigationSplitView(
                sidebar: {
                    sidebar
                },
                content: {
                    content
                }, detail: {
                    detail
                }
            )
        } else {
            SwiftUI.NavigationSplitView(
                sidebar: {
                    sidebar
                }, detail: {
                    content
                    detail
                }
            )
        }
    }
    
    var hasSidebar: Bool {
        node.hasTemplate("sidebar")
    }
    var sidebar: some View {
        node.children(in: "sidebar", library: Library.self)
    }
    
    var hasContent: Bool {
        node.hasTemplate("context", default: true)
    }
    var content: some View {
        node.children(in: "content", default: true, library: Library.self)
    }
    
    var hasDetail: Bool {
        node.hasTemplate("detail")
    }
    var detail: some View {
        node.children(in: "detail", library: Library.self)
    }
}
