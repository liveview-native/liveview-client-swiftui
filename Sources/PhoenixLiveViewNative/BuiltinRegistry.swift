//
//  ViewRegistry.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 2/11/22.
//

import SwiftUI

struct BuiltinRegistry {
    
    static let attributeDecoder = JSONDecoder()
    
    @ViewBuilder
    static func lookup<R: CustomRegistry>(_ name: String, _ element: ElementNode, context: LiveContext<R>) -> some View {
        switch name {
        case "textfield":
            PhxTextField<R>(element: element, context: context)
        case "text":
            PhxText(element: element, context: context)
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
            PhxSpacer(element: element, context: context)
        case "navigationlink":
            PhxNavigationLink(element: element, context: context)
        case "list":
            PhxList<R>(element: element, context: context)
        case "rectangle":
            PhxShape(element: element, context: context, shape: Rectangle())
        case "roundedrectangle":
            PhxShape(element: element, context: context, shape: RoundedRectangle(from: element))
            
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
    
    enum ModifierType: String {
        case frame
        case listRowInsets = "list-row-insets"
        case listRowSeparator = "list-row-separator"
        case navigationTitle = "navigation-title"
        case padding
        case tint
    }
    
    static func decodeModifier(_ type: ModifierType, from decoder: Decoder) throws -> any ViewModifier {
        switch type {
        case .frame:
            return try FrameModifier(from: decoder)
        case .listRowInsets:
            return try ListRowInsetsModifier(from: decoder)
        case .listRowSeparator:
            return try ListRowSeparatorModifier(from: decoder)
        case .navigationTitle:
            return try NavigationTitleModifier(from: decoder)
        case .padding:
            return try PaddingModifier(from: decoder)
        case .tint:
            return try TintModifier(from: decoder)
        }
    }
}
