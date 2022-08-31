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
            PhxButton<R>(element: element, context: context, action: nil)
        case "image":
            PhxImage(element: element, context: context)
        case "asyncimage":
            PhxAsyncImage(element: element, context: context)
        case "scrollview":
            PhxScrollView<R>(element: element, context: context)
        case "spacer":
            PhxSpacer(element: element)
        case "navigationlink":
            if #available(iOS 16.0, *) {
                PhxModernNavigationLink(element: element, context: context)
            } else {
                PhxNavigationLink(element: element, context: context)
            }
        case "list":
            PhxList<R>(element: element, context: context)
        case "rectangle":
            PhxShape(element: element, shape: Rectangle())
        case "roundedrectangle":
            PhxShape(element: element, shape: RoundedRectangle(from: element))
            
        case "phx-form":
            PhxForm<R>(element: element, context: context)
        case "phx-hero":
            PhxHeroView(element: element, context: context)
        case "phx-submit-button":
            PhxSubmitButton(element: element, context: context)
        default:
            // log here that view type cannot be found
            EmptyView()
        }
    }
}
