//
//  StaticLibrary.swift
//  LightpandaClient
//
//  Created by Carson.Katri on 10/7/25.
//

import LightpandaClient
import SwiftUI

public struct SwiftUIElementLibrary: ElementLibrary {
    public enum TagName: String {
        case button = "Button"
        case pasteButton = "PasteButton"
        case link = "Link"
        case menu = "Menu"
        
        case contentUnavailableView = "ContentUnavailableView"
        
        case gauge = "Gauge"
        case progressView = "ProgressView"
        
        case color = "Color"
        case colorPicker = "ColorPicker"
        case datePicker = "DatePicker"
        case multiDatePicker = "MultiDatePicker"
        case picker = "Picker"
        
        case slider = "Slider"
        case stepper = "Stepper"
        case toggle = "Toggle"
        
        case asyncImage = "AsyncImage"
        case image = "Image"
        
        case list = "List"
        case section = "Section"
        case table = "Table"
        case tableColumn = "TableColumn"
        case tableRow = "TableRow"
        
        case form = "Form"
        case labeledContent = "LabeledContent"
        
        case grid = "Grid"
        case gridRow = "GridRow"
        
        case controlGroup = "ControlGroup"
        case disclosureGroup = "DisclosureGroup"
        case group = "Group"
        case groupBox = "GroupBox"
        
        case lazyHGrid = "LazyHGrid"
        case lazyVGrid = "LazyVGrid"
        case lazyHStack = "LazyHStack"
        case lazyVStack = "LazyVStack"
        
        case hSplitView = "HSplitView"
        case vSplitView = "VSplitView"
        
        case tabView = "TabView"
        
        case scrollView = "ScrollView"
        
        case spacer = "Spacer"
        
        case viewThatFits = "ViewThatFits"
        
        case hStack = "HStack"
        case vStack = "VStack"
        case zStack = "ZStack"
        
        case rectangle = "Rectangle"
        case roundedRectangle = "RoundedRectangle"
        case circle = "Circle"
        case capsule = "Capsule"
        
        case label = "Label"
        case secureField = "SecureField"
        case text = "Text"
        case textEditor = "TextEditor"
        case textField = "TextField"
        case textFieldLink = "TextFieldLink"
        
        case navigationLink = "NavigationLink"
        case navigationStack = "NavigationStack"
        case navigationSplitView = "NavigationSplitView"
        
        public init?(rawValue: String) {
            switch rawValue.lowercased() {
            case "button":
                self = .button
            case "pastebutton":
                self = .pasteButton
            case "link":
                self = .link
            case "menu":
                self = .menu
            case "contentunavailableview":
                self = .contentUnavailableView
            case "gauge":
                self = .gauge
            case "progressview":
                self = .progressView
            case "color":
                self = .color
            case "colorpicker":
                self = .colorPicker
            case "datepicker":
                self = .datePicker
            case "multidatepicker":
                self = .multiDatePicker
            case "picker":
                self = .picker
            case "slider":
                self = .slider
            case "stepper":
                self = .stepper
            case "toggle":
                self = .toggle
            case "asyncimage":
                self = .asyncImage
            case "image":
                self = .image
            case "list":
                self = .list
            case "section":
                self = .section
            case "table":
                self = .table
            case "tablecolumn":
                self = .tableColumn
            case "tablerow":
                self = .tableRow
            case "form":
                self = .form
            case "labeledcontent":
                self = .labeledContent
            case "grid":
                self = .grid
            case "gridrow":
                self = .gridRow
            case "controlgroup":
                self = .controlGroup
            case "disclosuregroup":
                self = .disclosureGroup
            case "group":
                self = .group
            case "groupbox":
                self = .groupBox
            case "lazyhgrid":
                self = .lazyHGrid
            case "lazyvgrid":
                self = .lazyVGrid
            case "lazyhstack":
                self = .lazyHStack
            case "lazyvstack":
                self = .lazyVStack
            case "hsplitview":
                self = .hSplitView
            case "vsplitview":
                self = .vSplitView
            case "tabview":
                self = .tabView
            case "scrollview":
                self = .scrollView
            case "spacer":
                self = .spacer
            case "viewthatfits":
                self = .viewThatFits
            case "hstack":
                self = .hStack
            case "vstack":
                self = .vStack
            case "zstack":
                self = .zStack
            case "rectangle":
                self = .rectangle
            case "roundedrectangle":
                self = .roundedRectangle
            case "circle":
                self = .circle
            case "capsule":
                self = .capsule
            case "label":
                self = .label
            case "securefield":
                self = .secureField
            case "text":
                self = .text
            case "texteditor":
                self = .textEditor
            case "textfield":
                self = .textField
            case "textfieldlink":
                self = .textFieldLink
            case "navigationlink":
                self = .navigationLink
            case "navigationstack":
                self = .navigationStack
            case "navigationsplitview":
                self = .navigationSplitView
            default:
                return nil
            }
        }
    }
    
    @MainActor
    public static func render(_ tag: TagName, for node: Node) -> some View {
        switch tag {
        case .button:
            Button<Self>(node: node)
        case .pasteButton:
            PasteButton<Self>(node: node)
        case .link:
            Link<Self>(node: node)
        case .menu:
            Menu<Self>(node: node)
        case .contentUnavailableView:
            ContentUnavailableView<Self>(node: node)
        case .gauge:
            Gauge<Self>(node: node)
        case .progressView:
            ProgressView<Self>(node: node)
        case .color:
            ColorView<Self>(node: node)
        case .colorPicker:
            ColorPicker<Self>(node: node)
        case .datePicker:
            DatePicker<Self>(node: node)
        case .multiDatePicker:
            MultiDatePicker<Self>(node: node)
        case .picker:
            Picker<Self>(node: node)
        case .slider:
            Slider<Self>(node: node)
        case .stepper:
            Stepper<Self>(node: node)
        case .toggle:
            Toggle<Self>(node: node)
        case .asyncImage:
            AsyncImage<Self>(node: node)
        case .image:
            ImageView<Self>.node(node)
        case .list:
            List<Self>(node: node)
        case .section:
            Section<Self>(node: node)
        case .table:
            Table<Self>(node: node)
        case .tableColumn:
            EmptyView() // TableColumn is handled within Table
        case .tableRow:
            EmptyView() // TableRow is handled within Table
        case .form:
            Form<Self>(node: node)
        case .labeledContent:
            LabeledContent<Self>(node: node)
        case .grid:
            Grid<Self>(node: node)
        case .gridRow:
            GridRow<Self>(node: node)
        case .controlGroup:
            ControlGroup<Self>(node: node)
        case .disclosureGroup:
            DisclosureGroup<Self>(node: node)
        case .group:
            Group<Self>(node: node)
        case .groupBox:
            GroupBox<Self>(node: node)
        case .lazyHGrid:
            LazyHGrid<Self>(node: node)
        case .lazyVGrid:
            LazyVGrid<Self>(node: node)
        case .lazyHStack:
            LazyHStack<Self>(node: node)
        case .lazyVStack:
            LazyVStack<Self>(node: node)
        case .hSplitView:
            HSplitView<Self>(node: node)
        case .vSplitView:
            VSplitView<Self>(node: node)
        case .tabView:
            TabView<Self>(node: node)
        case .scrollView:
            ScrollView<Self>(node: node)
        case .spacer:
            Spacer<Self>(node: node)
        case .viewThatFits:
            ViewThatFits<Self>(node: node)
        case .hStack:
            HStack<Self>(node: node)
        case .vStack:
            VStack<Self>(node: node)
        case .zStack:
            ZStack<Self>(node: node)
        case .rectangle:
            Shape<Self, Rectangle>(shape: Rectangle(), node: node)
        case .roundedRectangle:
            Shape<Self, RoundedRectangle>(shape: RoundedRectangle(node: node), node: node)
        case .circle:
            Shape<Self, Circle>(shape: Circle(), node: node)
        case .capsule:
            Shape<Self, Capsule>(shape: Capsule(node: node), node: node)
        case .label:
            Label<Self>(node: node)
        case .secureField:
            SecureField<Self>(node: node)
        case .text:
            TextView<Self>(node: node)
        case .textEditor:
            TextEditor<Self>(node: node)
        case .textField:
            TextField<Self>(node: node)
        case .textFieldLink:
            TextFieldLink<Self>(node: node)
        case .navigationLink:
            NavigationLinkView<Self>(node: node)
        case .navigationStack:
            NavigationStack<Self>(node: node)
        case .navigationSplitView:
            NavigationSplitView<Self>(node: node)
        }
    }
}
