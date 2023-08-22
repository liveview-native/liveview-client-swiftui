//
//  StrokeModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 5/11/23.
//

import SwiftUI

/// Strokes a ``Shape`` with a shape style.
///
/// Pass a ``LiveViewNative/SwiftUI/AnyShapeStyle`` to the `content` argument to create the stroke.
///
/// Optionally provide a ``LiveViewNative/SwiftUI/StrokeStyle`` to configure the stroke.
///
/// ```html
/// <Circle modifiers={stroke({:color, :red}, style: [line_width: 10])}>
/// ```
///
/// - Note: This modifier applies a stroke to the edges of the ``Shape``.
/// To add an inner stroke, use the ``StrokeBorderModifier`` modifier.
///
/// ## Arguments
/// * ``content``
/// * ``style``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct StrokeModifier: FinalShapeModifier, Decodable {
    /// The shape style to stroke with.
    ///
    /// See ``LiveViewNative/SwiftUI/AnyShapeStyle`` for more details on creating shape styles.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    let content: AnyShapeStyle
    
    /// Configuration for the stroke.
    ///
    /// See ``LiveViewNative/SwiftUI/StrokeStyle`` for more details on configuring strokes.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    let style: StrokeStyle?
    
    func apply(to shape: any SwiftUI.Shape) -> some View {
        AnyShape(shape).stroke(content, style: style ?? .init())
    }
    
    func apply(to shape: any InsettableShape) -> some View {
        AnyShape(shape).stroke(content, style: style ?? .init())
    }
}
