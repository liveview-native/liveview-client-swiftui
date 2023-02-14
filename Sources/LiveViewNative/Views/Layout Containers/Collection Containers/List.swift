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
    
    /// Selection of either a single value or set of values.
    enum Selection: Codable {
        case single(String?)
        case multiple(Set<String>)
        
        var single: String? {
            get {
                guard case let .single(selection) = self else { fatalError() }
                return selection
            }
            set {
                self = .single(newValue)
            }
        }
        
        var multiple: Set<String> {
            get {
                guard case let .multiple(selection) = self else { fatalError() }
                return selection
            }
            set {
                self = .multiple(newValue)
            }
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if container.decodeNil() {
                self = .single(nil)
            } else if let item = try? container.decode(String.self) {
                self = .single(item)
            } else {
                self = .multiple(try container.decode(Set<String>.self))
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .single(let selection):
                try container.encode(selection)
            case .multiple(let selection):
                try container.encode(selection)
            }
        }
    }
    
    @LiveBinding(attribute: "selection") private var selection = Selection.multiple([])
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }
    
    public var body: some View {
        list
            .applyListStyle(element.attributeValue(for: "list-style").flatMap(ListStyle.init) ?? .automatic)
    }
    
    @ViewBuilder
    private var list: some View {
        #if os(watchOS)
        SwiftUI.List {
            content
        }
        #else
        switch selection {
        case .single:
            SwiftUI.List(selection: $selection.single) {
                content
            }
        case .multiple:
            SwiftUI.List(selection: $selection.multiple) {
                content
            }
        }
        #endif
    }
    
    private var content: some View {
        forEach(nodes: element.children(), context: context)
            .onDelete(perform: onDeleteHandler)
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

private extension View {
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
