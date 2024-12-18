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
/// See [`SwiftUI.View/mask(alignment:mask:)`](https://developer.apple.com/documentation/swiftui/view/mask(alignment:_:)) for more details on this ViewModifier.
///
/// ### mask(alignment:mask:)
/// - `alignment`: ``SwiftUI/Alignment``
/// - `mask`: ``ViewReference`` (required)
///
/// See [`SwiftUI.View/mask(alignment:mask:)`](https://developer.apple.com/documentation/swiftui/view/mask(alignment:mask:)) for more details on this ViewModifier.
///
/// Example:
///
/// ```heex
/// <Element style='mask(alignment: .center, mask: :mask)'>
///   <Child template="mask" />
/// </Element>
/// ```
@_documentation(visibility: public)
@ASTDecodable("mask")
struct _MaskModifier<R: RootRegistry>: ViewModifier {
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

