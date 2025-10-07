//
//  StaticLibrary.swift
//  LightpandaClient
//
//  Created by Carson.Katri on 10/7/25.
//

import LightpandaClient
import SwiftUI

public struct StaticElementLibrary: ElementLibrary {
    public enum TagName: String {
        case contentUnavailableView = "contentunavailableview"
        
        case gauge = "gauge"
        case progressView = "progressview"
        
        case color = "color"
        
        case asyncImage = "asyncimage"
        case image = "image"
        
        case list = "list"
        case section = "section"
        
        case labeledContent = "labeledcontent"
        
        case grid = "grid"
        case gridRow = "gridrow"
        
        case disclosureGroup = "disclosuregroup"
        case group = "group"
        case groupBox = "groupbox"
        
        case lazyHGrid = "lazyhgrid"
        case lazyVGrid = "lazyvgrid"
        
        case hSplitView = "hsplitview"
        case vSplitView = "vsplitview"
        
        case spacer = "spacer"
        
        case viewThatFits = "viewthatfits"
        
        case hStack = "hstack"
        case vStack = "vstack"
        case zStack = "zstack"
        
        case rectangle = "rectangle"
        case roundedRectangle = "roundedrectangle"
        case circle = "circle"
        case capsule = "capsule"
        
        case label = "label"
        case text = "text"
    }
    
    @MainActor
    public static func render(_ tag: TagName, for node: Node) -> some View {
        switch tag {
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
        }
    }
}
