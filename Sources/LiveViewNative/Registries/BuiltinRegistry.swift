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
    static func lookup<R: RootRegistry>(_ name: String, _ element: ElementNode, context: LiveContext<R>) -> some View {
        switch name {
        case "async-image":
            AsyncImage(element: element, context: context)
        case "button":
            Button<R>(element: element, context: context, action: nil)
        case "capsule":
            Shape(element: element, context: context, shape: Capsule(from: element))
        case "circle":
            Shape(element: element, context: context, shape: Circle())
        case "color":
            Color(context: context)
#if os(iOS) || os(macOS)
        case "color-picker":
            ColorPicker(element: element, context: context)
#endif
        case "container-relative-shape":
            Shape(element: element, context: context, shape: ContainerRelativeShape())
#if os(iOS) || os(macOS)
        case "control-group":
            ControlGroup(element: element, context: context)
#endif
#if os(iOS) || os(macOS)
        case "date-picker":
            DatePicker(context: context)
#endif
#if os(iOS) || os(macOS)
        case "disclosure-group":
            DisclosureGroup(context: context)
#endif
        case "divider":
            Divider()
#if os(iOS)
        case "edit-button":
            EditButton()
#endif
        case "ellipse":
            Shape(element: element, context: context, shape: Ellipse())
        case "form":
            Form(context: context)
#if !os(tvOS)
        case "gauge":
            Gauge(element: element, context: context)
#endif
        case "group":
            Group(element: element, context: context)
        case "grid":
            Grid(element: element, context: context)
        case "grid-row":
            GridRow(element: element, context: context)
#if os(iOS) || os(macOS)
        case "group-box":
            GroupBox(element: element, context: context)
#endif
        case "h-stack", "hstack":
            HStack<R>(element: element, context: context)
        case "image":
            Image(element: element, context: context)
        case "label":
            Label(element: element, context: context)
        case "labeled-content":
            LabeledContent(context: context)
        case "lazy-h-grid":
            LazyHGrid(element: element, context: context)
        case "lazy-h-stack", "lazy-hstack":
            LazyHStack(element: element, context: context)
        case "lazy-v-grid":
            LazyVGrid(element: element, context: context)
        case "lazy-v-stack", "lazy-vstack":
            LazyVStack(element: element, context: context)
        case "link":
            Link(element: element, context: context)
        case "list":
            List<R>(element: element, context: context)
#if !os(watchOS)
        case "menu":
            Menu(element: element, context: context)
#endif
        case "navigation-link":
            NavigationLink(element: element, context: context)
        case "progress-view":
            ProgressView(element: element, context: context)
        case "picker":
            Picker(context: context)
        case "rectangle":
            Shape(element: element, context: context, shape: Rectangle())
        case "rounded-rectangle":
            Shape(element: element, context: context, shape: RoundedRectangle(from: element))
        case "scroll-view":
            ScrollView<R>(element: element, context: context)
        case "section":
            Section(element: element, context: context)
        case "secure-field":
            SecureField<R>(element: element, context: context)
        case "share-link":
            ShareLink(element: element, context: context)
        case "slider":
            Slider(element: element, context: context)
        case "stepper":
            Stepper(element: element, context: context)
        case "spacer":
            Spacer(element: element, context: context)
#if os(iOS) || os(macOS)
        case "table":
            Table(element: element, context: context)
#endif
        case "text":
            Text(context: context)
#if os(iOS) || os(macOS)
        case "text-editor":
            TextEditor(element: element, context: context)
#endif
        case "text-field":
            TextField<R>(element: element, context: context)
#if os(watchOS)
        case "text-field-link":
            TextFieldLink(context: context)
#endif
        case "toggle":
            Toggle(element: element, context: context)
        case "v-stack", "vstack":
            VStack<R>(element: element, context: context)
        case "view-that-fits":
            ViewThatFits(element: element, context: context)
        case "z-stack", "zstack":
            ZStack<R>(element: element, context: context)
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
        case fontWeight = "font_weight"
        case frame
        case gridCellAnchor = "grid_cell_anchor"
        case gridCellColumns = "grid_cell_columns"
        case gridCellUnsizedAxes = "grid_cell_unsized_axes"
        case gridColumnAlignment = "grid_column_alignment"
        case listRowInsets = "list_row_insets"
        case listRowSeparator = "list_row_separator"
        case navigationTitle = "navigation_title"
        case padding
        case tag
        case tint
    }
    
    @ViewModifierBuilder
    static func decodeModifier(_ type: ModifierType, from decoder: Decoder) throws -> some ViewModifier {
        switch type {
        case .fontWeight:
            try FontWeightModifier(from: decoder)
        case .frame:
            try FrameModifier(from: decoder)
        case .gridCellAnchor:
            try GridCellAnchorModifier(from: decoder)
        case .gridCellColumns:
            try GridCellColumnsModifier(from: decoder)
        case .gridCellUnsizedAxes:
            try GridCellUnsizedAxesModifier(from: decoder)
        case .gridColumnAlignment:
            try GridColumnAlignmentModifier(from: decoder)
        case .listRowInsets:
            try ListRowInsetsModifier(from: decoder)
        case .listRowSeparator:
            try ListRowSeparatorModifier(from: decoder)
        case .navigationTitle:
            try NavigationTitleModifier(from: decoder)
        case .padding:
            try PaddingModifier(from: decoder)
        case .tag:
            try TagModifier(from: decoder)
        case .tint:
            try TintModifier(from: decoder)
        }
    }
}
