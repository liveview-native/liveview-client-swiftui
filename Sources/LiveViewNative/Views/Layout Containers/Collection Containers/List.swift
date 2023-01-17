//
//  List.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI

struct List<R: CustomRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }
    
    public var body: some View {
        SwiftUI.List {
            forEach(nodes: element.children(), context: context)
                .onDelete(perform: onDeleteHandler)
        }
        .listStyle(from: element)
    }
    
    private var onDeleteHandler: ((IndexSet) -> Void)? {
        guard let deleteEvent = element.attributeValue(for: "phx-delete") else {
            return nil
        }
        return { indices in
            var meta = element.buildPhxValuePayload()
            // todo: what about multiple indicies?
            meta["index"] = indices.first!
            Task { [meta] in
                // todo: should this have its own type?
                try await context.coordinator.pushEvent(type: "click", event: deleteEvent, value: meta)
            }
        }
    }
}

private extension SwiftUI.List {
    @ViewBuilder
    func listStyle(from element: ElementNode) -> some View {
        switch element.attributeValue(for: "style") {
        case nil, "plain":
            self.listStyle(.plain)
        case "grouped":
            self.listStyle(.grouped)
        case "inset-grouped":
            self.listStyle(.insetGrouped)
        default:
            fatalError("Invalid list style '\(element.attributeValue(for: "name")!)'")
        }
    }
}
