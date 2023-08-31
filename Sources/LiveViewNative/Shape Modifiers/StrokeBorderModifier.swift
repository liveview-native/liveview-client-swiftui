//
//  StrokeBorderModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 5/11/23.
//

import SwiftUI

/// Adds an inner stroke to a ``Shape``.
///
/// Pass a ``LiveViewNative/SwiftUI/AnyShapeStyle`` to the `content` argument to create the stroke.
///
/// Optionally provide a ``LiveViewNative/SwiftUI/StrokeStyle`` to configure the stroke.
///
/// ```html
/// <Circle modifiers={stroke_border({:color, :red}, style: [line_width: 10])} />
/// ```
///
/// - Note: Unlike the ``StrokeModifier`` modifier, this strokes the inside of the shape.
/// This is equivalent to using a ``TrimModifier`` modifier set to half the line thickness, then stroking.
/// This means that this modifier only operates on insettable shapes.
///
/// ## Arguments
/// * ``content``
/// * ``style``
/// * ``antialiased``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct StrokeBorderModifier: FinalShapeModifier, Decodable {
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
    
    /// Enable/disable antialiasing on the shape's edges. Defaults to `true`.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    let antialiased: Bool
    
    func apply(to shape: any SwiftUI.Shape) -> some View {
        AnyShape(shape)
    }
    
    func apply(to shape: any InsettableShape) -> some View {
        let modified = shape.strokeBorder(content, style: style ?? .init(), antialiased: antialiased)
        return modified.eraseToAnyView()
    }
}

private extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}
