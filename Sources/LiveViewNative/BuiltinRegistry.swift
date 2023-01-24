//
//  ViewRegistry.swift
// LiveViewNative
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
            TextField<R>(element: element, context: context)
        case "securefield":
            SecureField<R>(element: element, context: context)
        case "text":
            Text(element: element, context: context)
        case "hstack":
            HStack<R>(element: element, context: context)
        case "vstack":
            VStack<R>(element: element, context: context)
        case "zstack":
            ZStack<R>(element: element, context: context)
        case "button":
            Button<R>(element: element, context: context, action: nil)
        case "image":
            Image(element: element, context: context)
        case "asyncimage":
            AsyncImage(element: element, context: context)
        case "scrollview":
            ScrollView<R>(element: element, context: context)
        case "spacer":
            Spacer(element: element, context: context)
        case "navigationlink":
            NavigationLink(element: element, context: context)
        case "list":
            List<R>(element: element, context: context)
        case "rectangle":
            Shape(element: element, context: context, shape: Rectangle())
        case "roundedrectangle":
            Shape(element: element, context: context, shape: RoundedRectangle(from: element))
        case "circle":
            Shape(element: element, context: context, shape: Circle())
        case "ellipse":
            Shape(element: element, context: context, shape: Ellipse())
        case "capsule":
            Shape(element: element, context: context, shape: Capsule(from: element))
        case "containerrelativeshape":
            Shape(element: element, context: context, shape: ContainerRelativeShape())
        case "lvn-link":
            Link(element: element, context: context)
        case "divider":
            Divider()
        case "edit-button":
            EditButton()
        case "toggle":
            Toggle(element: element, context: context)
        case "menu":
            Menu(element: element, context: context)
        case "slider":
            Slider(element: element, context: context)
        case "phx-form":
            PhxForm<R>(element: element, context: context)
        case "phx-submit-button":
            PhxSubmitButton(element: element, context: context)
        default:
            // log here that view type cannot be found
            EmptyView()
        }
    }
    
    enum ModifierType: String {
        case frame
        case listRowInsets = "list_row_insets"
        case listRowSeparator = "list_row_separator"
        case navigationTitle = "navigation_title"
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
