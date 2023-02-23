//
//  ScrollView.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI

struct ScrollView<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>
    
    @Attribute("axes") private var axes: Axis.Set = .vertical
    @Attribute("shows-indicators") private var showsIndicators: Bool
    @LiveBinding(attribute: "scroll-position") private var scrollPosition: String? = nil
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }
    
    public var body: some View {
        SwiftUI.ScrollViewReader { proxy in
            SwiftUI.ScrollView(
                axes,
                showsIndicators: showsIndicators
            ) {
                context.buildChildren(of: element)
            }
            .onChange(of: scrollPosition) { newValue in
                guard let newValue else { return }
                proxy.scrollTo(
                    newValue,
                    anchor: element.attributeValue(for: "scroll-position-anchor")?
                        .data(using: .utf8)
                        .flatMap { try? JSONDecoder().decode(UnitPoint.self, from: $0) }
                )
            }
        }
    }
}
