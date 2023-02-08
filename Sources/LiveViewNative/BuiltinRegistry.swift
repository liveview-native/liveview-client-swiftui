//
//  ViewRegistry.swift
// LiveViewNative
//
//  Created by Shadowfacts on 2/11/22.
//

import SwiftUI

/// This protocol provides access to the `ViewModifier` type returned from `decodeModifier` in the `BuiltinRegistry`.
/// That type is used by `ModifierContainer.builtin`.
protocol BuiltinRegistryProtocol {
    associatedtype BuiltinModifier: ViewModifier
    associatedtype ModifierType: RawRepresentable where ModifierType.RawValue == String
    static func decodeModifier(_ type: ModifierType, from decoder: Decoder) throws -> BuiltinModifier
}

struct BuiltinRegistry: BuiltinRegistryProtocol {
    
    static let attributeDecoder = JSONDecoder()
    
    @ViewBuilder
    static func lookup<R: CustomRegistry>(_ name: String, _ element: ElementNode, context: LiveContext<R>) -> some View {
        switch name {
        case "text-field":
            TextField<R>(element: element, context: context)
        case "secure-field":
            SecureField<R>(element: element, context: context)
        case "text":
            Text(context: context)
        case "h-stack", "hstack":
            HStack<R>(element: element, context: context)
        case "v-stack", "vstack":
            VStack<R>(element: element, context: context)
        case "z-stack", "zstack":
            ZStack<R>(element: element, context: context)
        case "button":
            Button<R>(element: element, context: context, action: nil)
        case "image":
            Image(element: element, context: context)
        case "async-image":
            AsyncImage(element: element, context: context)
        case "scroll-view":
            ScrollView<R>(element: element, context: context)
        case "spacer":
            Spacer(element: element, context: context)
        case "navigation-link":
            NavigationLink(element: element, context: context)
        case "list":
            List<R>(element: element, context: context)
        case "rectangle":
            Shape(element: element, context: context, shape: Rectangle())
        case "rounded-rectangle":
            Shape(element: element, context: context, shape: RoundedRectangle(from: element))
        case "circle":
            Shape(element: element, context: context, shape: Circle())
        case "ellipse":
            Shape(element: element, context: context, shape: Ellipse())
        case "capsule":
            Shape(element: element, context: context, shape: Capsule(from: element))
        case "container-relative-shape":
            Shape(element: element, context: context, shape: ContainerRelativeShape())
        case "link":
            Link(element: element, context: context)
        case "progress-view":
            ProgressView(element: element, context: context)
        case "divider":
            Divider()
#if os(iOS)
        case "edit-button":
            EditButton()
#endif
        case "toggle":
            Toggle(element: element, context: context)
#if !os(watchOS)
        case "menu":
            Menu(element: element, context: context)
#endif
#if !os(tvOS)
        case "gauge":
            Gauge(element: element, context: context)
#endif
        case "slider":
            Slider(element: element, context: context)
        case "label":
            Label(element: element, context: context)
        case "stepper":
            Stepper(element: element, context: context)
        case "form":
            Form(context: context)
        case "section":
            Section(element: element, context: context)
#if os(iOS) || os(macOS)
        case "text-editor":
            TextEditor(element: element, context: context)
#endif
            
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
    
    @ViewModifierBuilder
    static func decodeModifier(_ type: ModifierType, from decoder: Decoder) throws -> some ViewModifier {
        switch type {
        case .frame:
            try FrameModifier(from: decoder)
        case .listRowInsets:
            try ListRowInsetsModifier(from: decoder)
        case .listRowSeparator:
            try ListRowSeparatorModifier(from: decoder)
        case .navigationTitle:
            try NavigationTitleModifier(from: decoder)
        case .padding:
            try PaddingModifier(from: decoder)
        case .tint:
            try TintModifier(from: decoder)
        }
    }
}
