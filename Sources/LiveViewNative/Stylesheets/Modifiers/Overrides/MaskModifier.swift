//
//  _MaskModifier.swift
//
//
//  Created by Carson Katri on 11/22/23.
//

import SwiftUI
import LiveViewNativeStylesheet

// manual implementation
// Last argument has no label, which is incompatible with the stylesheet format.
@ParseableExpression
struct _MaskModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "mask" }
    
    @ObservedElement private var element
    @LiveContext<R> private var context
    
    let alignment: Alignment
    let mask: ViewReference
    
    init(alignment: Alignment = .center, mask: ViewReference) {
        self.alignment = alignment
        self.mask = mask
    }
    
    func body(content: Content) -> some View {
        content.mask(alignment: alignment, { mask.resolve(on: element, in: context) })
    }
}

