//
//  LazyHGrid.swift
//
//
//  Created by Carson Katri on 2/15/23.
//

import SwiftUI

struct LazyHGrid<R: CustomRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }

    public var body: some View {
        SwiftUI.LazyHGrid(
            rows: rows,
            alignment: element.attributeValue(for: "alignment").flatMap(VerticalAlignment.init) ?? .center,
            spacing: element.attributeValue(for: "spacing").flatMap(Double.init(_:)).flatMap(CGFloat.init),
            pinnedViews: pinnedViews
        ) {
            context.buildChildren(of: element)
        }
    }
    
    private var rows: [GridItem] {
        try! JSONDecoder().decode([GridItem].self, from: element.attributeValue(for: "rows")!.data(using: .utf8)!)
    }
    
    private var pinnedViews: PinnedScrollableViews {
         switch element.attributeValue(for: "pinned-views") {
         case "section-headers":
             return .sectionHeaders
         case "section-footers":
             return .sectionFooters
         case "all":
             return [.sectionHeaders, .sectionFooters]
         default:
             return .init()
         }
     }
}
