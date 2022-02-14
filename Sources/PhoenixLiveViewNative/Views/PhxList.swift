//
//  PhxList.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI
import SwiftSoup

struct PhxList: View {
    private let element: Element
    private let context: LiveContext
    private let deleteEvent: String?
    
    init(element: Element, context: LiveContext) {
        self.element = element
        self.context = context
        self.deleteEvent = element.attrIfPresent("phx-delete")
    }
    
    var body: some View {
        List {
            ForEach(elements: element.children(), context: context)
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
            let payload: Payload = [
                // todo: should this have it's own type?
                "type": "click",
                "event": deleteEvent,
                "value":meta
            ]
            context.coordinator.pushWithReply(event: "event", payload: payload)
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
