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
    
    // note: the context parameter is unused, but it needs to be there for swift to infer the generic type R
    @ViewBuilder
    static func lookup<R: RootRegistry>(_ name: String, _ element: ElementNode, context: LiveContextStorage<R>) -> some View {
        switch name {
        case "AsyncImage":
            AsyncImage<R>()
        case "Button":
            Button<R>(action: nil)
        case "Capsule":
            Shape(shape: Capsule(from: element))
        case "Circle":
            Shape(shape: Circle())
        case "Color":
            Color()
#if os(iOS) || os(macOS)
        case "ColorPicker":
            ColorPicker<R>()
#endif
        case "ContainerRelativeShape":
            Shape(shape: ContainerRelativeShape())
#if os(iOS) || os(macOS)
        case "ControlGroup":
            ControlGroup<R>()
#endif
#if os(iOS) || os(macOS)
        case "DatePicker":
            DatePicker<R>()
#endif
#if os(iOS) || os(macOS)
        case "DisclosureGroup":
            DisclosureGroup<R>()
#endif
        case "Divider":
            Divider()
#if os(iOS)
        case "EditButton":
            EditButton()
#endif
        case "Ellipse":
            Shape(shape: Ellipse())
        case "Form":
            Form<R>()
#if !os(tvOS)
        case "Gauge":
            Gauge<R>()
#endif
        case "Group":
            Group<R>()
        case "Grid":
            Grid<R>()
        case "GridRow":
            GridRow<R>()
#if os(iOS) || os(macOS)
        case "GroupBox":
            GroupBox<R>()
#endif
#if os(macOS)
        case "HSplitView":
            HSplitView<R>()
#endif
        case "HStack":
            HStack<R>()
        case "Image":
            Image()
        case "Label":
            Label<R>()
        case "LabeledContent":
            LabeledContent<R>()
        case "LazyHGrid":
            LazyHGrid<R>()
        case "LazyHStack":
            LazyHStack<R>()
        case "LazyVGrid":
            LazyVGrid<R>()
        case "LazyVStack":
            LazyVStack<R>()
        case "Link":
            Link<R>()
        case "List":
            List<R>()
#if !os(watchOS)
        case "Menu":
            Menu<R>()
#endif
#if os(iOS)
        case "MultiDatePicker":
            MultiDatePicker<R>()
#endif
        case "NavigationLink":
            NavigationLink<R>()
#if os(iOS) || os(macOS)
        case "PasteButton":
            PasteButton<R>()
#endif
        case "ProgressView":
            ProgressView<R>()
        case "Picker":
            Picker<R>()
        case "Rectangle":
            Shape(shape: Rectangle())
        case "RenameButton":
            RenameButton()
        case "RoundedRectangle":
            Shape(shape: RoundedRectangle(from: element))
        case "ScrollView":
            ScrollView<R>()
        case "Section":
            Section<R>()
        case "SecureField":
            SecureField<R>()
        case "ShareLink":
            ShareLink<R>()
        case "Slider":
            Slider<R>()
        case "Stepper":
            Stepper<R>()
        case "Spacer":
            Spacer()
#if os(iOS) || os(macOS)
        case "Table":
            Table<R>()
#endif
        case "Text":
            Text<R>()
#if os(iOS) || os(macOS)
        case "TextEditor":
            TextEditor()
#endif
        case "TextField":
            TextField<R>()
#if os(watchOS)
        case "TextFieldLink":
            TextFieldLink<R>()
#endif
        case "Toggle":
            Toggle<R>()
#if os(macOS)
        case "VSplitView":
            VSplitView<R>()
#endif
        case "VStack":
            VStack<R>()
        case "ViewThatFits":
            ViewThatFits<R>()
        case "ZStack":
            ZStack<R>()
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
