//
//  BackgroundModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 3/17/23.
//

import SwiftUI

/// Renders content behind an element.
///
/// There are several ways to create a background.
///
/// ### Nested Content
///
/// Nested content is referenced using the ``content`` argument.
/// This allows any arbitrary elements to be placed behind the element.
///
/// ```html
/// <HStack>
///   <Image system-name="heart.fill" modifiers={background(alignment: :center, content: :bg_content)}>
///     <Circle template={:bg_content} />
///   </Image>
/// </HStack>
/// ```
///
/// ### ShapeStyle
///
/// Provide a ``LiveViewNative/SwiftUI/AnyShapeStyle`` to the ``style`` argument to fill the background with a style.
/// Use ``ignoresSafeAreaEdges`` to control how the background interacts with safe areas.
///
/// ```html
/// <Text modifiers={background({:color, :red})}>
///   Hello, world!
/// </Text>
/// ```
///
/// Providing no ``style`` will assume the default background style.
///
/// ### Shape
///
/// Provide a ``ShapeReference`` to the ``shape`` argument to fill the background in a particular shape.
/// Optionally provide the ``style`` and ``fillStyle`` arguments to customize the fill.
///
/// ```html
/// <Text modifiers={background({:color, :red}, in: :capsule)}>
///   Hello, world!
/// </Text>
/// ```
///
/// ## Arguments
/// * ``alignment``
/// * ``content``
/// * ``style``
/// * ``shape``
/// * ``ignoresSafeAreaEdges``
/// * ``fillStyle``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct BackgroundModifier<R: RootRegistry>: ViewModifier, Decodable {
    @ObservedElement private var element
    @LiveContext<R> private var context
    
    /// The alignment of the nested content. Defaults to `center`.
    ///
    /// See ``LiveViewNative/SwiftUI/Alignment`` for a list of possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let alignment: Alignment
    
    /// The name of the template content to display behind the element.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let content: String?
    
    /// The ``LiveViewNative/SwiftUI/AnyShapeStyle`` to fill the background with.
    ///
    /// See ``LiveViewNative/SwiftUI/AnyShapeStyle`` for more details.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let style: AnyShapeStyle?
    
    /// The shape to use for the background.
    /// Use ``style`` to customize the shape's fill.
    ///
    /// See ``ShapeReference`` for more details.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let shape: ShapeReference?
    
    /// `ignores_safe_area`, The edges that ignore system safe areas.
    /// Used with the ``style`` argument.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let ignoresSafeAreaEdges: Edge.Set
    
    /// `fill_style`, rendering options for the ``shape``.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let fillStyle: FillStyle

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.alignment = try container.decodeIfPresent(Alignment.self, forKey: .alignment) ?? .center
        self.content = try container.decodeIfPresent(String.self, forKey: .content)
        self.style = try container.decodeIfPresent(AnyShapeStyle.self, forKey: .style)
        self.shape = try container.decodeIfPresent(ShapeReference.self, forKey: .shape)
        self.ignoresSafeAreaEdges = try container.decodeIfPresent(Edge.Set.self, forKey: .ignoresSafeAreaEdges) ?? .all
        self.fillStyle = try container.decodeIfPresent(FillStyle.self, forKey: .fillStyle) ?? .init()
    }

    func body(content: Content) -> some View {
        if let reference = self.content {
            content
                .background(alignment: alignment) {
                    context.buildChildren(of: element, forTemplate: reference)
                }
        } else if let shape {
            content.background(style ?? AnyShapeStyle(.background), in: shape.resolve(on: element), fillStyle: fillStyle)
        } else if let style {
            content.background(style, ignoresSafeAreaEdges: ignoresSafeAreaEdges)
        } else {
            content.background(ignoresSafeAreaEdges: ignoresSafeAreaEdges)
        }
    }

    enum CodingKeys: CodingKey {
        case alignment
        case content
        case style
        case shape
        case ignoresSafeAreaEdges
        case fillStyle
    }
}
