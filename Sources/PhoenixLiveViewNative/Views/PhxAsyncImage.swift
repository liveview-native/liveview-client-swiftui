//
//  PhxAsyncImage.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 7/21/22.
//

import SwiftUI

struct PhxAsyncImage: View {
    private let url: URL?
    private let scale: Double?
    private let contentMode: ContentMode
    
    init<R: CustomRegistry>(element: ElementNode, context: LiveContext<R>) {
        self.url = URL(string: element.attributeValue(for: "src")!, relativeTo: context.url)
        if let attr = element.attributeValue(for: "scale"),
           let f = Double(attr) {
            self.scale = f
        } else {
            self.scale = nil
        }
        switch element.attributeValue(for: "content-mode") {
        case "fill":
            self.contentMode = .fill
        default:
            self.contentMode = .fit
        }
    }
    
    public var body: some View {
        // todo: do we want to customize the loading state for this
        // todo: this will use URLCache.shared by default, do we want to customize that?
        AsyncImage(url: url, scale: scale ?? 1, transaction: Transaction(animation: .default)) { phase in
            switch phase {
            case .success(let image):
                let configured = configureImage(image)
                configured
                    // when using an AsyncImage in the hero transition overlay, it never resolves to the actual image
                    // so when the source AsyncImage resolves, we use a preference to communicate the resulting
                    // Image up to the overlay view, in case it needs to be used
                    .preference(key: HeroViewOverrideKey.self, value: HeroViewOverride(configured))
            case .failure(let error):
                Text(error.localizedDescription)
            case .empty:
                ProgressView().progressViewStyle(.circular)
            @unknown default:
                EmptyView()
            }
        }
    }
    
    private func configureImage(_ image: Image) -> some View {
        image
            .resizable()
            .aspectRatio(contentMode: contentMode)
    }
}
