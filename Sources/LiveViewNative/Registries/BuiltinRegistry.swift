//
//  ViewRegistry.swift
// LiveViewNative
//
//  Created by Shadowfacts on 2/11/22.
//

import SwiftUI
import LiveViewNativeCore

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
        case "AsyncImage":
            AsyncImage(element: element, context: context)
        case "Button":
            Button<R>(element: element, context: context, action: nil)
        case "Capsule":
            Shape(element: element, context: context, shape: Capsule(from: element))
        case "Circle":
            Shape(element: element, context: context, shape: Circle())
        case "Color":
            Color(context: context)
#if os(iOS) || os(macOS)
        case "ColorPicker":
            ColorPicker(element: element, context: context)
#endif
        case "ContainerRelativeShape":
            Shape(element: element, context: context, shape: ContainerRelativeShape())
#if os(iOS) || os(macOS)
        case "ControlGroup":
            ControlGroup(element: element, context: context)
#endif
#if os(iOS) || os(macOS)
        case "DatePicker":
            DatePicker(context: context)
#endif
#if os(iOS) || os(macOS)
        case "DisclosureGroup":
            DisclosureGroup(context: context)
#endif
        case "Divider":
            Divider()
#if os(iOS)
        case "EditButton":
            EditButton()
#endif
        case "Ellipse":
            Shape(element: element, context: context, shape: Ellipse())
        case "Form":
            Form(context: context)
#if !os(tvOS)
        case "Gauge":
            Gauge(element: element, context: context)
#endif
        case "Group":
            Group(element: element, context: context)
        case "Grid":
            Grid(element: element, context: context)
        case "GridRow":
            GridRow(element: element, context: context)
#if os(iOS) || os(macOS)
        case "GroupBox":
            GroupBox(element: element, context: context)
#endif
#if os(macOS)
        case "HSplitView":
            HSplitView(context: context)
#endif
        case "HStack":
            HStack<R>(element: element, context: context)
        case "Image":
            Image(element: element, context: context)
        case "Label":
            Label(element: element, context: context)
        case "LabeledContent":
            LabeledContent(context: context)
        case "LazyHGrid":
            LazyHGrid(element: element, context: context)
        case "LazyHStack":
            LazyHStack(element: element, context: context)
        case "LazyVGrid":
            LazyVGrid(element: element, context: context)
        case "LazyVStack":
            LazyVStack(element: element, context: context)
        case "Link":
            Link(element: element, context: context)
        case "List":
            List<R>(element: element, context: context)
#if !os(watchOS)
        case "Menu":
            Menu(element: element, context: context)
#endif
#if os(iOS)
        case "MultiDatePicker":
            MultiDatePicker<R>(context: context)
#endif
        case "NavigationLink":
            NavigationLink(element: element, context: context)
#if os(iOS) || os(macOS)
        case "PasteButton":
            PasteButton(context: context)
#endif
        case "ProgressView":
            ProgressView(element: element, context: context)
        case "Picker":
            Picker(context: context)
        case "Rectangle":
            Shape(element: element, context: context, shape: Rectangle())
        case "RenameButton":
            RenameButton()
        case "RoundedRectangle":
            Shape(element: element, context: context, shape: RoundedRectangle(from: element))
        case "ScrollView":
            ScrollView<R>(element: element, context: context)
        case "Section":
            Section(element: element, context: context)
        case "SecureField":
            SecureField<R>(element: element, context: context)
        case "ShareLink":
            ShareLink(element: element, context: context)
        case "Slider":
            Slider(element: element, context: context)
        case "Stepper":
            Stepper(element: element, context: context)
        case "Spacer":
            Spacer(element: element, context: context)
#if os(iOS) || os(macOS)
        case "Table":
            Table(element: element, context: context)
#endif
        case "Text":
            Text(context: context)
#if os(iOS) || os(macOS)
        case "TextEditor":
            TextEditor(element: element, context: context)
#endif
        case "TextField":
            TextField<R>(element: element, context: context)
#if os(watchOS)
        case "TextFieldLink":
            TextFieldLink(context: context)
#endif
        case "Toggle":
            Toggle(element: element, context: context)
#if os(macOS)
        case "VSplitView":
            VSplitView(context: context)
#endif
        case "VStack":
            VStack<R>(element: element, context: context)
        case "ViewThatFits":
            ViewThatFits(element: element, context: context)
        case "ZStack":
            ZStack<R>(element: element, context: context)
        default:
            // log here that view type cannot be found
            EmptyView()
        }
    }
    
    enum ModifierType: String {
        case backgroundStyle = "background_style"
        case fontWeight = "font_weight"
        case foregroundStyle = "foreground_style"
        case frame
        case gridCellAnchor = "grid_cell_anchor"
        case gridCellColumns = "grid_cell_columns"
        case gridCellUnsizedAxes = "grid_cell_unsized_axes"
        case gridColumnAlignment = "grid_column_alignment"
        case listRowInsets = "list_row_insets"
        case listRowSeparator = "list_row_separator"
        case navigationTitle = "navigation_title"
        case padding
        case renameAction = "rename_action"
        case tag
        case tint
    }
    
    @ViewModifierBuilder
    static func decodeModifier(_ type: ModifierType, from decoder: Decoder) throws -> some ViewModifier {
        switch type {
        case .backgroundStyle:
            try BackgroundStyleModifier(from: decoder)
        case .foregroundStyle:
            try ForegroundStyleModifier(from: decoder)
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
        case .renameAction:
            try RenameActionModifier(from: decoder)
        case .tag:
            try TagModifier(from: decoder)
        case .tint:
            try TintModifier(from: decoder)
        }
    }
}
