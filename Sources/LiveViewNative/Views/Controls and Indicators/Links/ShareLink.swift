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
    
    public var body: some View {
        let subject = element.attributeValue(for: "subject").flatMap(SwiftUI.Text.init)
        let message = element.attributeValue(for: "message").flatMap(SwiftUI.Text.init)
        let useDefaultLabel = element.children().filter({
            guard let element = $0.asElement() else { return true }
            return !(element.tag == "preview" && element.namespace == "share-link")
        }).isEmpty
        if let item = element.attributeValue(for: "item") {
            if useDefaultLabel {
                switch preview {
                case nil:
                    SwiftUI.ShareLink(
                        item: item,
                        subject: subject,
                        message: message
                    )
                case let .title(title):
                    SwiftUI.ShareLink(
                        item: item,
                        subject: subject,
                        message: message,
                        preview: .init(title)
                    )
                case let .both(title, image, icon):
                    SwiftUI.ShareLink(
                        item: item,
                        subject: subject,
                        message: message,
                        preview: .init(title, image: image, icon: icon)
                    )
                case let .image(title, image):
                    SwiftUI.ShareLink(
                        item: item,
                        subject: subject,
                        message: message,
                        preview: .init(title, image: image)
                    )
                case let .icon(title, icon):
                    SwiftUI.ShareLink(
                        item: item,
                        subject: subject,
                        message: message,
                        preview: .init(title, icon: icon)
                    )
                }
            } else {
                let label = context.buildChildren(of: element)
                switch preview {
                case nil:
                    SwiftUI.ShareLink(
                        item: item,
                        subject: subject,
                        message: message
                    ) { label }
                case let .title(title):
                    SwiftUI.ShareLink(
                        item: item,
                        subject: subject,
                        message: message,
                        preview: .init(title)
                    ) { label }
                case let .both(title, image, icon):
                    SwiftUI.ShareLink(
                        item: item,
                        subject: subject,
                        message: message,
                        preview: .init(title, image: image, icon: icon)
                    ) { label }
                case let .image(title, image):
                    SwiftUI.ShareLink(
                        item: item,
                        subject: subject,
                        message: message,
                        preview: .init(title, image: image)
                    ) { label }
                case let .icon(title, icon):
                    SwiftUI.ShareLink(
                        item: item,
                        subject: subject,
                        message: message,
                        preview: .init(title, icon: icon)
                    ) { label }
                }
            }
        }
    }
    
    enum PreviewBranch {
        case title(String)
        case both(title: String, image: SwiftUI.Image, icon: SwiftUI.Image)
        case image(title: String, image: SwiftUI.Image)
        case icon(title: String, icon: SwiftUI.Image)
    }
    
    private var preview: PreviewBranch? {
        element.elementChildren()
            .first(where: { $0.tag == "preview" && $0.namespace == "share-link" })
            .flatMap { element in
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
                switch (image, icon) {
                case (nil, nil):
                    return .title(title)
                case (nil, let icon?):
                    return .icon(title: title, icon: icon)
                case (let image?, nil):
                    return .image(title: title, image: image)
                case (let image?, let icon?):
                    return .both(title: title, image: image, icon: icon)
                }
            }
    }
}
