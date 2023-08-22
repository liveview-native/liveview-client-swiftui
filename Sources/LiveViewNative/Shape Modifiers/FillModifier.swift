//
//  FillModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 5/11/23.
//

import SwiftUI

/// Fills a ``Shape`` with a ``LiveViewNative/SwiftUI/AnyShapeStyle``.
///
/// Optionally provide a ``LiveViewNative/SwiftUI/FillStyle`` to configure how the shape should be drawn.
///
/// ```html
/// <Circle modifiers={fill({:color, :red}, style: [antialiased: false])} />
/// ```
///
/// ## Arguments
/// * ``content``
/// * ``style``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct FillModifier: FinalShapeModifier, Decodable {
    /// The shape style to fill the shape with.
    ///
    /// See ``LiveViewNative/SwiftUI/AnyShapeStyle`` for more details on creating shape styles.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    let content: AnyShapeStyle
    
    /// Configuration for the fill.
    ///
    /// See ``LiveViewNative/SwiftUI/FillStyle`` for more details on configuring fills.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    let style: FillStyle?
    
    func apply(to shape: any SwiftUI.Shape) -> some View {
        AnyShape(shape).fill(content, style: style ?? .init())
    }
    
    func apply(to shape: any InsettableShape) -> some View {
        AnyShape(shape).fill(content, style: style ?? .init())
    }
}
