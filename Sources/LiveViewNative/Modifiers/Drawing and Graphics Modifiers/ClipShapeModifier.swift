//
//  ClipShapeModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 5/16/2023.
//

import SwiftUI

/// Masks an element with a given shape.
///
/// Provide a ``ShapeReference`` to clip the element with.
///
/// ```html
/// <Text modifiers={clip_shape(:circle)}>
///     Hello,
///     world!
/// </Text>
/// ```
///
/// If the shape is not predefined, provide a ``Shape`` element with a `template` attribute.
/// This lets you apply modifiers to the clip shape.
///
/// ```html
/// <Text modifiers={clip_shape(:my_shape)}>
///     Hello,
///     world!
///     <Rectangle template={:my_shape} modifiers={rotation({:degrees, 45})} />
/// </Text>
/// ```
///
/// ## Arguments
/// * ``shape``
/// * ``style``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ClipShapeModifier<R: RootRegistry>: ViewModifier, Decodable {
    /// The shape to use as a mask.
    ///
    /// See ``ShapeReference`` for more details on creating shape arguments.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let shape: ShapeReference

    /// The style to use when filling the ``shape`` for the mask.
    ///
    /// See ``LiveViewNative/SwiftUI/FillStyle`` for more details.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let style: FillStyle
    
    @ObservedElement private var element
    @LiveContext<R> private var context

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.shape = try container.decode(ShapeReference.self, forKey: .shape)
        self.style = try container.decodeIfPresent(FillStyle.self, forKey: .style) ?? .init()
    }

    func body(content: Content) -> some View {
        content.clipShape(
            shape.resolve(on: element),
            style: style
        )
    }

    enum CodingKeys: String, CodingKey {
        case shape
        case style
    }
}
