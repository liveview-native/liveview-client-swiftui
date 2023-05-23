//
//  CGRect.swift
//  
//
//  Created by Carson Katri on 5/23/23.
//

import CoreFoundation

/// A rectangular area.
///
/// Rectangles are created with an origin and a size.
///
/// ```elixir
/// [[x, y], [width, height]]
/// ```
///
/// The elements can also be provided as a flat list or keyword list/map.
///
/// ```elixir
/// [x, y, width, height]
/// [x: 0, y: 0, width: 100, height: 150]
/// %{ x: 0, y: 0, width: 100, height: 150 }
/// ```
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension CoreFoundation.CGRect {
    // DocC crashes when documentation is applied to an empty extension.
    var ___: Never { fatalError() }
}
