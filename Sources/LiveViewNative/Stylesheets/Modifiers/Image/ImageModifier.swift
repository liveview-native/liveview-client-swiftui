//
//  ImageModifier.swift
//
//
//  Created by Carson Katri on 2/5/25.
//

import SwiftUI
import LiveViewNativeStylesheet

protocol ImageModifier: ViewModifier {
    func apply<R: RootRegistry>(
        to image: Image,
        on element: ElementNode,
        in context: LiveContext<R>
    ) -> Image
}

extension BuiltinRegistry {
    enum ImageModifierRegistry: ImageModifier, @preconcurrency Decodable {
        case resizable(ResizableModifier)
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            
            if let modifier = try? container.decode(ResizableModifier.self) {
                self = .resizable(modifier)
            } else {
                throw BuiltinRegistryModifierError.unknownModifier
            }
        }
        
        func body(content: Content) -> some View {
            content
        }
        
        func apply<Root>(
            to image: Image,
            on element: ElementNode,
            in context: LiveContext<Root>
        ) -> Image where Root : RootRegistry {
            switch self {
            case .resizable(let modifier):
                modifier.apply(to: image, on: element, in: context)
            }
        }
    }
}
