//
//  AsyncImage.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 7/21/22.
//

import SwiftUI

struct AsyncImage<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    @Attribute("url") private var url: String?
    @Attribute("scale") private var scale: Double?
    @Attribute("content-mode", transform: { $0?.value == "fill" ? .fill : .fit }) private var contentMode: ContentMode
    
    public var body: some View {
        // todo: do we want to customize the loading state for this
        // todo: this will use URLCache.shared by default, do we want to customize that?
        SwiftUI.AsyncImage(url: url.flatMap({ URL(string: $0, relativeTo: context.url) }), scale: scale ?? 1, transaction: Transaction(animation: .default)) { phase in
            switch phase {
            case .success(let image):
                configureImage(image)
            case .failure(let error):
                SwiftUI.Text(error.localizedDescription)
            case .empty:
                SwiftUI.ProgressView().progressViewStyle(.circular)
            @unknown default:
                EmptyView()
            }
        }
    }
    
    private func configureImage(_ image: SwiftUI.Image) -> some View {
        image
            .resizable()
            .aspectRatio(contentMode: contentMode)
    }
}
