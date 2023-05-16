//
//  TrimModifier.swift
//  
//
//  Created by Carson Katri on 5/11/23.
//

import SwiftUI

/// Trim the start/end points of a ``Shape``.
///
/// Provide a ``startFraction`` and/or ``endFraction`` to trim the beginning/end of the ``Shape``.
///
/// ```html
/// <Circle modifiers={trim(@native, start_fraction: 0.5, end_fraction: 1)} />
/// ```
///
/// ## Arguments
/// * ``startFraction``
/// * ``endFraction``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct TrimModifier: ShapeModifier, Decodable {
    /// A decimal representing the offset from the start of the ``Shape``. Defaults to `0`.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    let startFraction: CGFloat
    
    /// A decimal representing the offset from the end of the ``Shape``. Defaults to `1`.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    let endFraction: CGFloat
    
    func apply(to shape: some SwiftUI.Shape) -> any SwiftUI.Shape {
        shape.trim(from: startFraction, to: endFraction)
    }
    
    func apply(to shape: some SwiftUI.InsettableShape) -> any SwiftUI.Shape {
        shape.trim(from: startFraction, to: endFraction)
    }
}
