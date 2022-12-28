//
//  AsyncImage.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 7/21/22.
//

import SwiftUI

struct AsyncImage<R: CustomRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }
    
    public var body: some View {
        // todo: do we want to customize the loading state for this
        // todo: this will use URLCache.shared by default, do we want to customize that?
        SwiftUI.AsyncImage(url: url, scale: scale ?? 1, transaction: Transaction(animation: .default)) { phase in
            switch phase {
            case .success(let image):
                let configured = configureImage(image)
                configured
                    // when using an AsyncImage in the hero transition overlay, it never resolves to the actual image
                    // so when the source AsyncImage resolves, we use a preference to communicate the resulting
                    // Image up to the overlay view, in case it needs to be used
                    .preference(key: HeroViewOverrideKey.self, value: HeroViewOverride(configured))
            case .failure(let error):
                SwiftUI.Text(error.localizedDescription)
            case .empty:
                ProgressView().progressViewStyle(.circular)
            @unknown default:
                EmptyView()
            }
        }
    }
    
    private var url: URL? {
        URL(string: element.attributeValue(for: "src")!, relativeTo: context.url)
    }
    
    private var scale: Double? {
        if let attr = element.attributeValue(for: "scale"),
           let f = Double(attr) {
            return f
        } else {
            return nil
        }
    }
    
    private var contentMode: ContentMode {
        switch element.attributeValue(for: "content-mode") {
        case "fill":
            return .fill
        default:
            return .fit
        }
    }
    
    private func configureImage(_ image: SwiftUI.Image) -> some View {
        image
            .resizable()
            .aspectRatio(contentMode: contentMode)
    }
}
