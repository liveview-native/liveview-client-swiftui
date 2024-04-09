//
//  NavigationStack.swift
//
//
//  Created by Carson Katri on 11/16/23.
//

import SwiftUI

@LiveElement
struct NavigationSplitView<Root: RootRegistry>: View {
    @LiveElementIgnored
    @EnvironmentObject
    private var session: LiveSessionCoordinator<Root>
    
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
        $liveElement.hasTemplate("sidebar")
    }
    var sidebar: some View {
        $liveElement.children(in: "sidebar")
    }
    
    var hasContent: Bool {
        $liveElement.hasTemplate("context", default: true)
    }
    var content: some View {
        $liveElement.children(in: "content", default: true)
    }
    
    var hasDetail: Bool {
        $liveElement.hasTemplate("detail")
    }
    var detail: some View {
        $liveElement.children(in: "detail")
    }
}
