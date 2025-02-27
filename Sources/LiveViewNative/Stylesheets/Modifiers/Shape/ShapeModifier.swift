//
//  ShapeModifier.swift
//
//
//  Created by Carson Katri on 2/11/25.
//

import SwiftUI
import LiveViewNativeStylesheet

protocol ShapeFinalizerModifier: ViewModifier {
    func apply<R: RootRegistry>(
        to shape: AnyShape,
        on element: ElementNode,
        in context: LiveContext<R>
    ) -> AnyView
}

extension BuiltinRegistry {
    enum ShapeFinalizerModifierRegistry: ShapeFinalizerModifier, @preconcurrency Decodable {
        case fill(FillModifier)
        case stroke(StrokeModifier)
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            
            if let modifier = try? container.decode(FillModifier.self) {
                self = .fill(modifier)
            } else if let modifier = try? container.decode(StrokeModifier.self) {
                self = .stroke(modifier)
            } else {
                throw BuiltinRegistryModifierError.unknownModifier
            }
        }
        
        func body(content: Content) -> some View {
            content
        }
        
        func apply<Root>(
            to shape: AnyShape,
            on element: ElementNode,
            in context: LiveContext<Root>
        ) -> AnyView where Root : RootRegistry {
            switch self {
            case .fill(let modifier):
                return modifier.apply(to: shape, on: element, in: context)
            case .stroke(let modifier):
                return modifier.apply(to: shape, on: element, in: context)
            }
        }
    }
}

