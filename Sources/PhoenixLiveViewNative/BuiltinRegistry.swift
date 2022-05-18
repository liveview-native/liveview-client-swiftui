//
//  ViewRegistry.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 2/11/22.
//

import SwiftUI
import SwiftSoup

struct BuiltinRegistry {
    
    @ViewBuilder
    static func lookup<R: CustomRegistry>(_ name: String, _ element: Element, context: LiveContext<R>) -> some View {
        switch name {
        case "textfield":
            PhxTextField<R>(element: element, context: context)
        case "text":
            PhxText(element: element)
        case "hstack":
            PhxHStack<R>(element: element, context: context)
        case "vstack":
            PhxVStack<R>(element: element, context: context)
        case "zstack":
            PhxZStack<R>(element: element, context: context)
        case "button":
            PhxButton<R>(element: element, context: context)
        case "form":
            PhxForm<R>(element: element, context: context)
        case "img":
            PhxImage(element: element)
        case "scroll":
            PhxScrollView<R>(element: element, context: context)
        case "spacer":
            Spacer()
        case "navigationlink":
            PhxNavigationLink(element: element, context: context)
        case "hero":
            PhxHeroView(element: element, context: context)
        case "list":
            PhxList<R>(element: element, context: context)
        case "rect":
            PhxShape(element: element, shape: Rectangle())
        case "roundrect":
            PhxShape(element: element, shape: RoundedRectangle(from: element))
        default:
            // log here that view type cannot be found
            EmptyView()
        }
    }
}
