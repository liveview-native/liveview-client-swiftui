//
//  ResizableModifier.swift
//
//
//  Created by Carson Katri on 11/2/23.
//

import SwiftUI
import LiveViewNativeStylesheet

@ParseableExpression
struct _ResizableModifier: ImageModifier {
    static let name = "resizable"
    
    let capInsets: EdgeInsets
    let resizingMode: SwiftUI.Image.ResizingMode
    
    init(capInsets: EdgeInsets = EdgeInsets(), resizingMode: SwiftUI.Image.ResizingMode = SwiftUI.Image.ResizingMode.stretch) {
        self.capInsets = capInsets
        self.resizingMode = resizingMode
    }
    
    func apply(to image: SwiftUI.Image) -> SwiftUI.Image {
        image.resizable(
            capInsets: capInsets,
            resizingMode: resizingMode
        )
    }
}

extension SwiftUI.Image.ResizingMode: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "tile": .tile,
            "stretch": .stretch,
        ])
    }
}
