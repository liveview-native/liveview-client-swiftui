//
//  ImageModifier.swift
//
//
//  Created by Carson Katri on 11/2/23.
//

import SwiftUI
import LiveViewNativeStylesheet

protocol ImageModifier: ViewModifier where Body == ImageModifierBody<Self.Content> {
    func apply(to image: SwiftUI.Image) -> SwiftUI.Image
}

extension ImageModifier {
    func body(content: Self.Content) -> Body {
        ImageModifierBody(content: content, modifier: self)
    }
}

struct ImageModifierBody<Content: View>: View {
    let content: Content
    let modifier: any ImageModifier
    
    var body: some View {
        content.transformEnvironment(\.imageModifiers) {
            $0.append(modifier)
        }
    }
}

extension EnvironmentValues {
    private enum ImageModifiersKey: EnvironmentKey {
        static let defaultValue = [any ImageModifier]()
    }
    
    var imageModifiers: [any ImageModifier] {
        get { self[ImageModifiersKey.self] }
        set { self[ImageModifiersKey.self] = newValue }
    }
}
