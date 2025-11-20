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
        
        case contentUnavailableView = "ContentUnavailableView"
        
        case gauge = "Gauge"
        case progressView = "ProgressView"
        
        case color = "Color"
        
        case asyncImage = "AsyncImage"
        case image = "Image"
        
        case list = "List"
        case section = "Section"
        
        case labeledContent = "LabeledContent"
        
        case grid = "Grid"
        case gridRow = "GridRow"
        
        case disclosureGroup = "DisclosureGroup"
        case group = "Group"
        case groupBox = "GroupBox"
        
        case lazyHGrid = "LazyHGrid"
        case lazyVGrid = "LazyVGrid"
        
        case hSplitView = "HSplitView"
        case vSplitView = "VSplitView"
        
        case tabView = "TabView"
        
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
        case text = "Text"
        case textField = "TextField"
        
        public init?(rawValue: String) {
            switch rawValue.lowercased() {
            case "button":
                self = .button
            case "contentunavailableview":
                self = .contentUnavailableView
            case "gauge":
                self = .gauge
            case "progressview":
                self = .progressView
            case "color":
                self = .color
            case "asyncimage":
                self = .asyncImage
            case "image":
                self = .image
            case "list":
                self = .list
            case "section":
                self = .section
            case "labeledcontent":
                self = .labeledContent
            case "grid":
                self = .grid
            case "gridrow":
                self = .gridRow
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
            case "hsplitview":
                self = .hSplitView
            case "vsplitview":
                self = .vSplitView
            case "tabview":
                self = .tabView
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
            case "text":
                self = .text
            case "textfield":
                self = .textField
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
        case .contentUnavailableView:
            ContentUnavailableView<Self>(node: node)
        case .gauge:
            Gauge<Self>(node: node)
        case .progressView:
            ProgressView<Self>(node: node)
        case .color:
            ColorView<Self>(node: node)
        case .asyncImage:
            AsyncImage<Self>(node: node)
        case .image:
            ImageView<Self>.node(node)
        case .list:
            List<Self>(node: node)
        case .section:
            Section<Self>(node: node)
        case .labeledContent:
            LabeledContent<Self>(node: node)
        case .grid:
            Grid<Self>(node: node)
        case .gridRow:
            GridRow<Self>(node: node)
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
        case .hSplitView:
            HSplitView<Self>(node: node)
        case .vSplitView:
            VSplitView<Self>(node: node)
        case .tabView:
            TabView<Self>(node: node)
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
            RoundedRectangle(node: node)
        case .circle:
            Shape<Self, Circle>(shape: Circle(), node: node)
        case .capsule:
            Capsule(node: node)
        case .label:
            Label<Self>(node: node)
        case .text:
            TextView<Self>(node: node)
        case .textField:
            TextField<Self>(node: node)
        }
    }
}
