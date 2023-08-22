//
//  OffsetShapeModifier.swift
//  
//
//  Created by Carson Katri on 5/11/23.
//

import SwiftUI

/// Moves a ``Shape`` by the given amount.
///
/// - Note: This modifier only applies to ``Shape`` elements, and is separate from the ``OffsetModifier`` modifier.
///
/// ```html
/// <Circle modifiers={offset_shape(x: 10, y: 50)} />
/// ```
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct OffsetShapeModifier: ShapeModifier, Decodable {
    /// The horizontal offset distance. Defaults to `0`.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    let x: CGFloat
    /// The vertical offset distance. Defaults to `0`.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    let y: CGFloat
    
    func apply(to shape: some SwiftUI.Shape) -> any SwiftUI.Shape {
        shape.offset(x: x, y: y)
    }
    
    func apply(to shape: some SwiftUI.InsettableShape) -> any SwiftUI.Shape {
        shape.offset(x: x, y: y)
    }
}
