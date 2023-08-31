//
//  OverlayModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 5/30/2023.
//

import SwiftUI

/// Renders content above an element.
///
/// There are several ways to create an overlay.
///
/// ### Nested Content
///
/// Nested content is referenced using the ``content`` argument.
/// This allows any arbitrary elements to be placed above the element.
///
/// ```html
/// <Circle modifiers={overlay(alignment: :center, content: :my_icon)}>
///   <Image system-name="heart.fill" template={:my_icon} modifiers={foreground_style({:color, :red})} />
/// </Circle>
/// ```
///
/// ### ShapeStyle
///
/// Provide a ``LiveViewNative/SwiftUI/AnyShapeStyle`` to the ``style`` argument to fill the overlay with a style.
/// Use ``ignoresSafeAreaEdges`` to control how the overlay interacts with safe areas.
///
/// ```html
/// <Text modifiers={overlay({:material, :ultra_thin})}>
///   Hello, world!
/// </Text>
/// ```
///
/// ### Shape
///
/// Provide a ``ShapeReference`` to the ``shape`` argument to fill the overlay in a particular shape.
/// Optionally provide the ``style`` and ``fillStyle`` arguments to customize the fill.
///
/// ```html
/// <Text modifiers={overlay({:material, :ultra_thin}, in: :capsule)}>
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
struct OverlayModifier<R: RootRegistry>: ViewModifier, Decodable {
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
    
    /// The ``LiveViewNative/SwiftUI/AnyShapeStyle`` to fill the overlay with.
    ///
    /// See ``LiveViewNative/SwiftUI/AnyShapeStyle`` for more details.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let style: AnyShapeStyle?
    
    /// The shape to use for the overlay.
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
                .overlay(alignment: alignment) {
                    context.buildChildren(of: element, forTemplate: reference)
                }
        } else if let shape,
                  let style
        {
            content.overlay(style, in: shape.resolve(on: element), fillStyle: fillStyle)
        } else if let style {
            content.overlay(style, ignoresSafeAreaEdges: ignoresSafeAreaEdges)
        } else {
            content
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

