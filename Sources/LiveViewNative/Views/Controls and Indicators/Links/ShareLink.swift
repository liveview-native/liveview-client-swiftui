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
            return element.tag != "share-link-preview"
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
                        SharePreview(titles.value(for: item))
                    }
                case let .complete(titles, images, icons):
                    SwiftUI.ShareLink(
                        items: items,
                        subject: subject,
                        message: message
                    ) { item in
                        SharePreview(titles.value(for: item), image: images.value(for: item), icon: icons.value(for: item))
                    }
                case let .imageOnly(titles, images):
                    SwiftUI.ShareLink(
                        items: items,
                        subject: subject,
                        message: message
                    ) { item in
                        SharePreview(titles.value(for: item), image: images.value(for: item))
                    }
                case let .iconOnly(titles, icons):
                    SwiftUI.ShareLink(
                        items: items,
                        subject: subject,
                        message: message
                    ) { item in
                        SharePreview(titles.value(for: item), icon: icons.value(for: item))
                    }
                }
            } else {
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
                        SharePreview(titles.value(for: item))
                    } label: {
                        label
                    }
                case let .complete(titles, images, icons):
                    SwiftUI.ShareLink(
                        items: items,
                        subject: subject,
                        message: message
                    ) { item in
                        SharePreview(titles.value(for: item), image: images.value(for: item), icon: icons.value(for: item))
                    } label: {
                        label
                    }
                case let .imageOnly(titles, images):
                    SwiftUI.ShareLink(
                        items: items,
                        subject: subject,
                        message: message
                    ) { item in
                        SharePreview(titles.value(for: item), image: images.value(for: item))
                    } label: {
                        label
                    }
                case let .iconOnly(titles, icons):
                    SwiftUI.ShareLink(
                        items: items,
                        subject: subject,
                        message: message
                    ) { item in
                        SharePreview(titles.value(for: item), icon: icons.value(for: item))
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
    
    private var label: some View {
        context.buildChildren(of: element, withTagName: "label", namespace: "share-link", includeDefaultSlot: true)
    }
    
    /// The set of values used to create the `SharePreview` for each item.
    private enum PreviewBranch<Item: Hashable> {
        struct Properties<Property> {
            /// A map between share items and a certain property of the `SharePreview`.
            let values: [Item:Property]
            /// The value in the default `SharePreview`.
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
        
        /// Only the title is present.
        case titled(Properties<String>)
        /// Title and image are present.
        case imageOnly(Properties<String>, Properties<SwiftUI.Image>)
        /// Title and icon are present.
        case iconOnly(Properties<String>, Properties<SwiftUI.Image>)
        /// Title, image, and icon are present.
        case complete(Properties<String>, images: Properties<SwiftUI.Image>, icons: Properties<SwiftUI.Image>)
    }
    
    private struct PreviewData {
        let title: String
        let image: SwiftUI.Image?
        let icon: SwiftUI.Image?
    }
    
    /// Extract the `SharePreview` for each item.
    ///
    /// Selects the "least common denominator" set of properties.
    /// For example, if one preview provides the `title`, `image`, and `icon`, but another only provides the `title` and `icon`, `PreviewBranch.iconOnly` will be returned.
    ///
    /// This is due to a limitation in the `ShareLink` type wherein a single `SharePreview` type must be returned, but would have a different type if the presence of the `image`/`icon` differed.
    private func previews(for items: [String]) -> PreviewBranch<String>? {
        // Collect the `share-link:preview` values for each item, and the default if present.
        var previews: ([String: PreviewData], default: PreviewData?) = element.elementChildren()
            .filter({ $0.tag == "share-link-preview" })
            .reduce(into: ([:], default: nil)) { pairs, element in
                let title = element.attributeValue(for: "title") ?? ""
                let image = element.elementChildren()
                    .first(where: { $0.tag == "image" && $0.namespace == "share-link-preview" })?
                    .elementChildren()
                    .first
                    .flatMap({ Image(overrideElement: $0, context: context).image })
                let icon = element.elementChildren()
                    .first(where: { $0.tag == "icon" && $0.namespace == "share-link-preview" })?
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
        
        guard !previews.0.isEmpty || previews.1 != nil else { return nil }
        
        // If there is no default and not all items have a preview, create a fallback preview.
        if previews.default == nil && Set(previews.0.keys) != Set(items) {
            previews.default = .init(title: "", image: nil, icon: nil)
        }
        
        let allSharePreviews = previews.0.values + (previews.default.flatMap({ [$0] }) ?? [])
        let image = allSharePreviews.allSatisfy({ $0.image != nil })
        let icon = allSharePreviews.allSatisfy({ $0.icon != nil })
        
        switch (image, icon) {
        case (true, false):
            return .imageOnly(
                .init(previews.0.mapValues(\.title), default: previews.default?.title),
                .init(previews.0.compactMapValues(\.image), default: previews.default?.image)
            )
        case (false, true):
            return .iconOnly(
                .init(previews.0.mapValues(\.title), default: previews.default?.title),
                .init(previews.0.compactMapValues(\.icon), default: previews.default?.icon)
            )
        case (true, true):
            return .complete(
                .init(previews.0.mapValues(\.title), default: previews.default?.title),
                images: .init(previews.0.compactMapValues(\.image), default: previews.default?.image),
                icons: .init(previews.0.compactMapValues(\.icon), default: previews.default?.icon)
            )
        case (false, false):
            return .titled(.init(previews.0.mapValues(\.title), default: previews.default?.title))
        }
    }
}
