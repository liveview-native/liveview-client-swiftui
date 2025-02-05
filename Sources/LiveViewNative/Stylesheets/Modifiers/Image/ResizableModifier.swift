//
//  ResizableModifier.swift
//
//
//  Created by Carson Katri on 2/5/25.
//

import SwiftUI
import LiveViewNativeStylesheet

@ASTDecodable("resizable")
struct ResizableModifier: ImageModifier, @preconcurrency Decodable {
    let capInsets: EdgeInsets.Resolvable
    let resizingMode: Image.ResizingMode.Resolvable
    
    init(
        capInsets: EdgeInsets.Resolvable = .__constant(EdgeInsets()),
        resizingMode: Image.ResizingMode.Resolvable = .__constant(.stretch)
    ) {
        self.capInsets = capInsets
        self.resizingMode = resizingMode
    }
    
    func body(content: Content) -> some View {
        content
    }
    
    func apply<R: RootRegistry>(
        to image: Image,
        on element: ElementNode,
        in context: LiveContext<R>
    ) -> Image {
        image.resizable(
            capInsets: capInsets.resolve(on: element, in: context),
            resizingMode: resizingMode.resolve(on: element, in: context)
        )
    }
}
