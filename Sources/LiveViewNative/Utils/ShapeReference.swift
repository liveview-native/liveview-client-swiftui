//
//  ShapeReference.swift
//  LiveViewNative
//
//  Created by Carson Katri on 5/16/2023.
//

import SwiftUI

/// A type that provides a shape argument.
/// 
/// There are two main types of shape reference: system shapes and template shapes.
/// 
/// ## System Shapes
/// Use an atom to reference a system shape.
/// If the shape has any properties, provide them as a keyword list in a tuple.
/// 
/// ```elixir
/// :rectangle
/// {:capsule, [style: :continuous]}
/// ```
/// 
/// Possible values:
/// * `:capsule`
/// * `:circle`
/// * `:container_relative_shape`
/// * `:ellipse`
/// * `:rectangle`
/// * `:rounded_rectangle`
/// 
/// ### :capsule
/// Arguments:
/// * `style` - the corner style, see ``LiveViewNative/SwiftUI/RoundedCornerStyle`` for a list of possible values.
/// 
/// ```elixir
/// {:capsule, [style: :continuous]}
/// ```
/// 
/// ### :rounded_rectangle
/// Arguments:
/// * `radius` - takes precedence over `width`/`height`.
/// * `width` - the width of the corners, requires `height` to be provided
/// * `height` - the height of the corners, requires `width` to be provided
/// * `style` - the corner style, see ``LiveViewNative/SwiftUI/RoundedCornerStyle`` for a list of possible values.
/// 
/// ```elixir
/// {:rounded_rectangle, [radius: 10, style: :continuous]}
/// ```
/// 
/// ## Template Shapes
/// Use an atom to reference a ``Shape`` element with a `template` attribute.
/// 
/// Shape modifiers can be used to customize the appearance of the shape.
/// 
/// ```elixir
/// :my_shape
/// ```
/// ```html
/// <Rectangle template={:my_shape} modifiers={rotation(@native, angle: {:degrees, 45})} />
/// ```
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
enum ShapeReference: Decodable {
    case `static`(AnyShape)
    case key(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let key = try container.decodeIfPresent(String.self, forKey: .key) {
            self = .key(key)
        } else {
            let staticContainer = try container.nestedContainer(keyedBy: CodingKeys.PropertiesKeys.self, forKey: .properties)
            switch try container.decode(StaticShape.self, forKey: .static) {
            case .capsule: self = .static(AnyShape(
                Capsule(style: try staticContainer.decodeIfPresent(RoundedCornerStyle.self, forKey: .style) ?? .circular)
            ))
            case .circle: self = .static(AnyShape(Circle()))
            case .containerRelativeShape: self = .static(AnyShape(ContainerRelativeShape()))
            case .ellipse: self = .static(AnyShape(Ellipse()))
            case .rectangle: self = .static(AnyShape(Rectangle()))
            case .roundedRectangle:
                let style = try staticContainer.decodeIfPresent(RoundedCornerStyle.self, forKey: .style) ?? .circular
                if let radius = try staticContainer.decodeIfPresent(CGFloat.self, forKey: .radius) {
                    self = .static(AnyShape(RoundedRectangle(
                        cornerRadius: radius,
                        style: style
                    )))
                } else {
                    self = .static(AnyShape(RoundedRectangle(
                        cornerSize: .init(
                            width: try staticContainer.decode(CGFloat.self, forKey: .width),
                            height: try staticContainer.decode(CGFloat.self, forKey: .height)
                        ),
                        style: style
                    )))
                }
            }
        }
    }
    
    enum StaticShape: String, Decodable {
        case capsule
        case circle
        case containerRelativeShape = "container_relative_shape"
        case ellipse
        case rectangle
        case roundedRectangle = "rounded_rectangle"
    }
    
    enum CodingKeys: String, CodingKey {
        case `static`
        case key
        case properties
        
        enum PropertiesKeys: String, CodingKey {
            case style
            
            case radius
            
            case width
            case height
        }
    }
    
    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> AnyShape {
        switch self {
        case let .static(anyShape):
            return anyShape
        case let .key(keyName):
            return context.children(of: element, forTemplate: keyName)
                .compactMap { $0.asElement() }
                .compactMap {
                    let shape: any InsettableShape
                    switch $0.tag {
                    case "Capsule":
                        shape = Capsule(from: $0)
                    case "Circle":
                        shape = Circle()
                    case "ContainerRelativeShape":
                        shape = ContainerRelativeShape()
                    case "Ellipse":
                        shape = Ellipse()
                    case "Rectangle":
                        shape = Rectangle()
                    case "RoundedRectangle":
                        shape = RoundedRectangle(from: $0)
                    default:
                        shape = Rectangle()
                    }
                    if let modifiers = try? ShapeModifierStack(from: $0.attribute(named: "modifiers")) {
                        return modifiers.stack.reduce(EitherAnyShape.insettable(shape)) { shape, modifier in
                            modifier.apply(to: shape)
                        }.eraseToAnyShape()
                    } else {
                        return AnyShape(shape)
                    }
                }.first ?? AnyShape(Rectangle())
        }
    }
}
