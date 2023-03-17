//
//  ScrollView.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI

struct ScrollView<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    @Attribute("axes") private var axes: Axis.Set = .vertical
    @Attribute("shows-indicators") private var showsIndicators: Bool
    
    @Attribute("scroll-position") private var scrollPosition: String?
    @Attribute("scroll-position-anchor") private var scrollPositionAnchor: UnitPoint?
    
    public var body: some View {
        SwiftUI.ScrollViewReader { proxy in
            SwiftUI.ScrollView(
                axes,
                showsIndicators: showsIndicators
            ) {
                context.buildChildren(of: element)
            }
            .onAppear {
                guard let scrollPosition else { return }
                proxy.scrollTo(scrollPosition, anchor: scrollPositionAnchor)
            }
            .onChange(of: scrollPosition) { newValue in
                guard let newValue else { return }
                proxy.scrollTo(newValue, anchor: scrollPositionAnchor)
            }
        }
    }
}
