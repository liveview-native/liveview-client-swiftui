//
//  ContainerShapeModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 5/31/2023.
//

import SwiftUI

/// Sets the shape of a <doc:ContainerRelativeShape> element.
///
/// Use a ``ShapeReference`` to create the container shape.
/// This shape will be used for all child <doc:ContainerRelativeShape> elements.
/// An inset will be applied to the shape based on the distance from the element this modifier is attached to.
///
/// - Note: Only insettable shapes can be used. Some shape modifiers can cause a shape to no longer be insettable.
///
/// In this example, you can see how adding padding to the <doc:ContainerRelativeShape> causes the shape to be inset.
///
/// ```html
/// <ZStack modifiers={container_shape(:capsule)}>
///   <%= for {color, index} <- Enum.with_index([:red, :orange, :yellow, :green, :blue, :purple]) do %>
///     <ContainerRelativeShape modifiers={fill({:color, color}) |> padding(index * 30)} />
///   <% end %>
/// </ZStack>
/// ```
///
/// ## Arguments
/// * ``shape``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ContainerShapeModifier<R: RootRegistry>: ViewModifier, Decodable {
    /// The shape to use for all child <doc:ContainerRelativeShape> elements.
    ///
    /// See ``ShapeReference`` for a list of possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let shape: ShapeReference
    
    @ObservedElement private var element
    @LiveContext<R> private var context
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.shape = try container.decode(ShapeReference.self, forKey: .shape)
    }
    
    func body(content: Content) -> some View {
        content.containerShape(shape.resolveInsettableShape(on: element))
    }
    
    enum CodingKeys: CodingKey {
        case shape
    }
}

