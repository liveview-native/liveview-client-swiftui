//
//  ShareLink.swift
//
//
//  Created by Carson Katri on 2/7/23.
//

import SwiftUI
import LiveViewNativeCore
import CoreTransferable


struct ShareLink<R: CustomRegistry>: View {
    @ObservedElement private var element: ElementNode
    let context: LiveContext<R>
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }
    
    private let decoder = JSONDecoder()
    
    public var body: some View {
        let subject = element.attributeValue(for: "subject").flatMap(SwiftUI.Text.init)
        let message = element.attributeValue(for: "message").flatMap(SwiftUI.Text.init)
        let useDefaultLabel = element.children().filter({
            guard let element = $0.asElement() else { return true }
            return !(element.tag == "preview" && element.namespace == "share-link")
        }).isEmpty
        let items: [String]? = element.attributeValue(for: "items").flatMap({
            guard let data = $0.data(using: .utf8) else { return nil }
            return try? decoder.decode([String].self, from: data)
        })
        if let items {
            let previews = previews(for: items)
            if useDefaultLabel {
                switch previews {
                case nil:
                    SwiftUI.ShareLink(
                        items: items,
                        subject: subject,
                        message: message
                    )
                case let .titled(titles):
                    SwiftUI.ShareLink(
                        items: items,
                        subject: subject,
                        message: message
                    ) { item in
                            .init(titles.value(for: item))
                    }
                case let .complete(titles, images, icons):
                    SwiftUI.ShareLink(
                        items: items,
                        subject: subject,
                        message: message
                    ) { item in
                            .init(titles.value(for: item), image: images.value(for: item), icon: icons.value(for: item))
                    }
                case let .imageOnly(titles, images):
                    SwiftUI.ShareLink(
                        items: items,
                        subject: subject,
                        message: message
                    ) { item in
                            .init(titles.value(for: item), image: images.value(for: item))
                    }
                case let .iconOnly(titles, icons):
                    SwiftUI.ShareLink(
                        items: items,
                        subject: subject,
                        message: message
                    ) { item in
                            .init(titles.value(for: item), icon: icons.value(for: item))
                    }
                }
            } else {
                let label = context.buildChildren(of: element)
                switch previews {
                case nil:
                    SwiftUI.ShareLink(
                        items: items,
                        subject: subject,
                        message: message
                    ) {
                        label
                    }
                case let .titled(titles):
                    SwiftUI.ShareLink(
                        items: items,
                        subject: subject,
                        message: message
                    ) { item in
                            .init(titles.value(for: item))
                    } label: {
                        label
                    }
                case let .complete(titles, images, icons):
                    SwiftUI.ShareLink(
                        items: items,
                        subject: subject,
                        message: message
                    ) { item in
                            .init(titles.value(for: item), image: images.value(for: item), icon: icons.value(for: item))
                    } label: {
                        label
                    }
                case let .imageOnly(titles, images):
                    SwiftUI.ShareLink(
                        items: items,
                        subject: subject,
                        message: message
                    ) { item in
                            .init(titles.value(for: item), image: images.value(for: item))
                    } label: {
                        label
                    }
                case let .iconOnly(titles, icons):
                    SwiftUI.ShareLink(
                        items: items,
                        subject: subject,
                        message: message
                    ) { item in
                            .init(titles.value(for: item), icon: icons.value(for: item))
                    } label: {
                        label
                    }
                }
            }
        } else if let item = element.attributeValue(for: "item") {
            if useDefaultLabel {
                switch previews(for: [item]) {
                case nil:
                    SwiftUI.ShareLink(
                        item: item,
                        subject: subject,
                        message: message
                    )
                case let .titled(titles):
                    SwiftUI.ShareLink(
                        item: item,
                        subject: subject,
                        message: message,
                        preview: .init(titles.value(for: item))
                    )
                case let .complete(titles, images, icons):
                    SwiftUI.ShareLink(
                        item: item,
                        subject: subject,
                        message: message,
                        preview: .init(titles.value(for: item), image: images.value(for: item), icon: icons.value(for: item))
                    )
                case let .imageOnly(titles, images):
                    SwiftUI.ShareLink(
                        item: item,
                        subject: subject,
                        message: message,
                        preview: .init(titles.value(for: item), image: images.value(for: item))
                    )
                case let .iconOnly(titles, icons):
                    SwiftUI.ShareLink(
                        item: item,
                        subject: subject,
                        message: message,
                        preview: .init(titles.value(for: item), icon: icons.value(for: item))
                    )
                }
            } else {
                let label = context.buildChildren(of: element)
                switch previews(for: [item]) {
                case nil:
                    SwiftUI.ShareLink(
                        item: item,
                        subject: subject,
                        message: message
                    ) { label }
                case let .titled(titles):
                    SwiftUI.ShareLink(
                        item: item,
                        subject: subject,
                        message: message,
                        preview: .init(titles.value(for: item))
                    ) { label }
                case let .complete(titles, images, icons):
                    SwiftUI.ShareLink(
                        item: item,
                        subject: subject,
                        message: message,
                        preview: .init(titles.value(for: item), image: images.value(for: item), icon: icons.value(for: item))
                    ) { label }
                case let .imageOnly(titles, images):
                    SwiftUI.ShareLink(
                        item: item,
                        subject: subject,
                        message: message,
                        preview: .init(titles.value(for: item), image: images.value(for: item))
                    ) { label }
                case let .iconOnly(titles, icons):
                    SwiftUI.ShareLink(
                        item: item,
                        subject: subject,
                        message: message,
                        preview: .init(titles.value(for: item), icon: icons.value(for: item))
                    ) { label }
                }
            }
        }
    }
    
    struct PreviewData {
        let title: String
        let image: SwiftUI.Image?
        let icon: SwiftUI.Image?
    }
    
    enum PreviewBranch<Item: Hashable> {
        struct Properties<Property> {
            let values: [Item:Property]
            let defaultValue: Property?
            
            init(_ values: [Item:Property], default defaultValue: Property?) {
                self.values = values
                self.defaultValue = defaultValue
            }
            
            func value(for item: Item?) -> Property {
                guard let item = item,
                      let value = values[item]
                else { return defaultValue! }
                return value
            }
        }
        case titled(Properties<String>)
        case imageOnly(Properties<String>, Properties<SwiftUI.Image>)
        case iconOnly(Properties<String>, Properties<SwiftUI.Image>)
        case complete(Properties<String>, images: Properties<SwiftUI.Image>, icons: Properties<SwiftUI.Image>)
    }
    
    private func previews<Item>(for items: [Item]) -> PreviewBranch<Item>? where Item == String {
        var previews: ([Item: PreviewData], default: PreviewData?) = element.elementChildren()
            .filter({ $0.tag == "preview" && $0.namespace == "share-link" })
            .reduce(into: ([:], default: nil)) { pairs, element in
                let title = element.attributeValue(for: "title") ?? ""
                let image = element.elementChildren()
                    .first(where: { $0.tag == "image" && $0.namespace == "preview" })?
                    .elementChildren()
                    .first
                    .flatMap({ Image(overrideElement: $0, context: context).image })
                let icon = element.elementChildren()
                    .first(where: { $0.tag == "icon" && $0.namespace == "preview" })?
                    .elementChildren()
                    .first
                    .flatMap({ Image(overrideElement: $0, context: context).image })
                
                let data = PreviewData(
                    title: title,
                    image: image,
                    icon: icon
                )
                if let item = element.attributeValue(for: "item") {
                    pairs.0[item] = data
                } else {
                    pairs.1 = data
                }
            }
        if Set(previews.0.keys) != Set(items) && previews.default == nil {
            previews.default = .init(title: "", image: nil, icon: nil)
        }
        guard !previews.0.isEmpty || previews.1 != nil else { return nil }
        let accessors = (previews.0.values + (previews.default.flatMap({ [$0] }) ?? []))
            .reduce(
                into: Set([\PreviewData.title, \PreviewData.image, \PreviewData.icon])
            ) { accessors, preview in
                if preview.image == nil {
                    accessors.remove(\.image)
                }
                if preview.icon == nil {
                    accessors.remove(\.icon)
                }
            }
        switch accessors {
        case [\.title, \.image]:
            return .imageOnly(
                .init(previews.0.mapValues(\.title), default: previews.default?.title),
                .init(previews.0.compactMapValues(\.image), default: previews.default?.image)
            )
        case [\.title, \.icon]:
            return .iconOnly(
                .init(previews.0.mapValues(\.title), default: previews.default?.title),
                .init(previews.0.compactMapValues(\.icon), default: previews.default?.icon)
            )
        case [\.title, \.image, \.icon]:
            return .complete(
                .init(previews.0.mapValues(\.title), default: previews.default?.title),
                images: .init(previews.0.compactMapValues(\.image), default: previews.default?.image),
                icons: .init(previews.0.compactMapValues(\.icon), default: previews.default?.icon)
            )
        default:
            return .titled(.init(previews.0.mapValues(\.title), default: previews.default?.title))
        }
    }
}
