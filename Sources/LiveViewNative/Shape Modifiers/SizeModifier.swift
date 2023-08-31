//
//  SizeModifier.swift
//  
//
//  Created by Carson Katri on 5/11/23.
//

import SwiftUI

/// Sets the size of the ``Shape``.
///
/// - Note: This modifier does not affect the layout of elements.
/// Use the ``FrameModifier`` modifier to adjust the bounding box of an element.
///
/// ```html
/// <Rectangle modifiers={size(width: 100, height: 100)} />
/// ```
///
/// ## Arguments
/// * ``width``
/// * ``height``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct SizeModifier: ShapeModifier, Decodable {
    /// The horizontal size of the shape.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    let width: CGFloat
    
    /// The vertical size of the shape.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    let height: CGFloat
    
    func apply(to shape: some SwiftUI.Shape) -> any SwiftUI.Shape {
        shape.size(width: width, height: height)
    }
    
    func apply(to shape: some SwiftUI.InsettableShape) -> any SwiftUI.Shape {
        shape.size(width: width, height: height)
    }
}
