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
        .applyListStyle(element.attributeValue(for: "list-style").flatMap(ListStyle.init) ?? .automatic)
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

fileprivate enum ListStyle: String {
    case automatic
    case plain
#if os(iOS) || os(macOS)
    case sidebar
    case inset
#endif
#if os(iOS)
    case insetGrouped = "inset-grouped"
#endif
#if os(iOS) || os(tvOS)
    case grouped
#endif
}

private extension SwiftUI.List {
    @ViewBuilder
    func applyListStyle(_ style: ListStyle) -> some View {
        switch style {
        case .automatic:
            self.listStyle(.automatic)
        case .plain:
            self.listStyle(.plain)
#if os(iOS) || os(macOS)
        case .sidebar:
            self.listStyle(.sidebar)
        case .inset:
            self.listStyle(.inset)
#endif
#if os(iOS)
        case .insetGrouped:
            self.listStyle(.insetGrouped)
#endif
#if os(iOS) || os(tvOS)
        case .grouped:
            self.listStyle(.grouped)
#endif
        }
    }
}
