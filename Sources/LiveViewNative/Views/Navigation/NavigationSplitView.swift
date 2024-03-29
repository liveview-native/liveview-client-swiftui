//
//  NavigationStack.swift
//
//
//  Created by Carson Katri on 11/16/23.
//

import SwiftUI

struct NavigationSplitView<R: RootRegistry>: View {
    @LiveContext<R> private var context
    @ObservedElement private var element
    
    @EnvironmentObject private var session: LiveSessionCoordinator<R>
    
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
        context.hasTemplate(of: element, withName: "sidebar")
    }
    var sidebar: some View {
        context.buildChildren(of: element, forTemplate: "sidebar", includeDefaultSlot: false)
    }
    
    var hasContent: Bool {
        context.hasTemplate(of: element, withName: "content") || context.hasDefaultSlot(of: element)
    }
    var content: some View {
        context.buildChildren(of: element, forTemplate: "content", includeDefaultSlot: true)
    }
    
    var hasDetail: Bool {
        context.hasTemplate(of: element, withName: "detail")
    }
    var detail: some View {
        context.buildChildren(of: element, forTemplate: "detail", includeDefaultSlot: false)
    }
}
