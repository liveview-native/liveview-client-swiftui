//
//  ImageModifier.swift
//
//
//  Created by Carson Katri on 11/2/23.
//

import SwiftUI
import LiveViewNativeStylesheet

protocol ImageModifier: ViewModifier {
    func apply(to image: SwiftUI.Image, on element: ElementNode) -> SwiftUI.Image
}

/// A type-erased `ImageModifier`, which can be applied to a `View` or directly on `Image`.
enum _AnyImageModifier<R: RootRegistry>: ViewModifier, ImageModifier, ParseableModifierValue {
    case renderingMode(_RenderingModeModifier)
    case resizable(_ResizableModifier)
    
    func body(content: Content) -> some View {
        switch self {
        case let .renderingMode(modifier):
            content.modifier(modifier)
        case let .resizable(modifier):
            content.modifier(modifier)
        }
    }
    
    func apply(to image: SwiftUI.Image, on element: ElementNode) -> SwiftUI.Image {
        switch self {
        case let .renderingMode(modifier):
            return modifier.apply(to: image, on: element)
        case let .resizable(modifier):
            return modifier.apply(to: image, on: element)
        }
    }
    
    static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            _RenderingModeModifier.parser(in: context).map(Self.renderingMode)
            _ResizableModifier.parser(in: context).map(Self.resizable)
        }
    }
}

