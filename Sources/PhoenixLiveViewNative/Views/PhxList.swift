//
//  PhxList.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI
import SwiftSoup

struct PhxList<R: CustomRegistry>: View {
    private let element: Element
    private let context: LiveContext<R>
    private let deleteEvent: String?
    
    init(element: Element, context: LiveContext<R>) {
        self.element = element
        self.context = context
        self.deleteEvent = element.attrIfPresent("phx-delete")
    }
    
    public var body: some View {
        List {
            forEach(elements: element.children(), context: context)
                .onDelete(perform: onDeleteHandler)
        }
        .listStyle(from: element)
    }
    
    private var onDeleteHandler: ((IndexSet) -> Void)? {
        guard let deleteEvent = deleteEvent else {
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

private extension List {
    @ViewBuilder
    func listStyle(from element: Element) -> some View {
        switch element.attrIfPresent("style") {
        case nil, "plain":
            self.listStyle(.plain)
        case "grouped":
            self.listStyle(.grouped)
        case "inset-grouped":
            self.listStyle(.insetGrouped)
        default:
            fatalError("Invalid list style '\(element.attrIfPresent("name")!)'")
        }
    }
}
