//
//  ViewRegistry.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 2/11/22.
//

import SwiftUI
import SwiftSoup

struct BuiltinRegistry {
    
    // todo: remove me
    static func lookup<R: CustomRegistry>(_ name: String, _ element: Element, _ coordinator: LiveViewCoordinator<R>) -> some View {
        return lookup(name, element, coordinator, context: LiveContext(coordinator: coordinator))
    }
    
    @ViewBuilder
    static func lookup<R: CustomRegistry>(_ name: String, _ element: Element, _ coordinator: LiveViewCoordinator<R>, context: LiveContext<R>) -> some View {
        switch name {
        case "textfield":
            PhxTextField<R>(element: element, coordinator: coordinator, context: context)
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
        case "navigation":
            PhxNavigationView<R>(element: element, context: context)
        case "list":
            PhxList<R>(element: element, context: context)
        case "roundrect":
            PhxShape(element: element, shape: RoundedRectangle(from: element))
        default:
            // log here that view type cannot be found
            EmptyView()
        }
    }
}
