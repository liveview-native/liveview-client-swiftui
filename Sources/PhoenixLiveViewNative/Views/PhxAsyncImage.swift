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
    
    init<R: CustomRegistry>(element: Element, context: LiveContext<R>) {
        self.url = URL(string: try! element.attr("src"), relativeTo: context.url)
        if let attr = element.attrIfPresent("scale"),
           let f = Double(attr) {
            self.scale = f
        } else {
            self.scale = nil
        }
    }
    
    var body: some View {
        // todo: do we want to customize the loading state for this
        // todo: this will use URLCache.shared by default, do we want to customize that?
        AsyncImage(url: url, scale: scale ?? 1) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            ProgressView().progressViewStyle(.circular)
        }
    }
}
