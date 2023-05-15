//
//  AspectRatioModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 3/23/23.
//

import SwiftUI

struct AspectRatioModifier: ViewModifier, Decodable {
    // TODO: Documentation
    private let aspectRatio: CGSize?
    private let contentMode: ContentMode

    func body(content: Content) -> some View {
        if let aspectRatio {
            content.aspectRatio(aspectRatio, contentMode: contentMode)
        } else {
            content.aspectRatio(contentMode: contentMode)
        }
    }
}
