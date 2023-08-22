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
/// <Rectangle template={:my_shape} modifiers={rotation({:degrees, 45})} />
/// ```
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
public enum ShapeReference: Decodable {
    case `static`(any InsettableShape)
    case key(String)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let key = try container.decodeIfPresent(String.self, forKey: .key) {
            self = .key(key)
        } else {
            let staticContainer = try container.nestedContainer(keyedBy: CodingKeys.PropertiesKeys.self, forKey: .properties)
            switch try container.decode(StaticShape.self, forKey: .static) {
            case .capsule: self = .static(
                Capsule(style: try staticContainer.decodeIfPresent(RoundedCornerStyle.self, forKey: .style) ?? .circular)
            )
            case .circle: self = .static(Circle())
            case .containerRelativeShape: self = .static(ContainerRelativeShape())
            case .ellipse: self = .static(Ellipse())
            case .rectangle: self = .static(Rectangle())
            case .roundedRectangle:
                let style = try staticContainer.decodeIfPresent(RoundedCornerStyle.self, forKey: .style) ?? .circular
                if let radius = try staticContainer.decodeIfPresent(CGFloat.self, forKey: .radius) {
                    self = .static(RoundedRectangle(
                        cornerRadius: radius,
                        style: style
                    ))
                } else {
                    self = .static(RoundedRectangle(
                        cornerSize: .init(
                            width: try staticContainer.decode(CGFloat.self, forKey: .width),
                            height: try staticContainer.decode(CGFloat.self, forKey: .height)
                        ),
                        style: style
                    ))
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
    
    public func resolve(on element: ElementNode) -> AnyShape {
        switch self {
        case let .static(anyShape):
            return AnyShape(anyShape)
        case let .key(keyName):
            return element.children()
                .lazy
                .filter({ $0.attributes.contains(where: { $0.name == "template" && $0.value == keyName }) })
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
                        return .init(shape)
                    }
                }.first ?? .init(Rectangle())
        }
    }
    
    public func resolveInsettableShape(on element: ElementNode) -> AnyInsettableShape {
        switch self {
        case let .static(anyShape):
            return AnyInsettableShape(anyShape)
        case let .key(keyName):
            return element.children()
                .lazy
                .filter({ $0.attributes.contains(where: { $0.name == "template" && $0.value == keyName }) })
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
                        let modified = modifiers.stack.reduce(EitherAnyShape.insettable(shape)) { shape, modifier in
                            modifier.apply(to: shape)
                        }
                        switch modified {
                        case .shape:
                            return .init(shape)
                        case let .insettable(insettable):
                            return .init(insettable)
                        }
                    } else {
                        return .init(shape)
                    }
                }.first ?? .init(Rectangle())
        }
    }
    
    public struct AnyInsettableShape: InsettableShape {
        let _path: @Sendable (CGRect) -> Path
        let _inset: @Sendable (CGFloat) -> any InsettableShape
        let _sizeThatFits: @Sendable (ProposedViewSize) -> CGSize
        
        init(_ shape: some InsettableShape) {
            self._path = { shape.path(in: $0) }
            self._inset = { shape.inset(by: $0) }
            self._sizeThatFits = { shape.sizeThatFits($0) }
        }
        
        public typealias InsetShape = Self
        
        public static let role: ShapeRole = .fill
        
        public func path(in rect: CGRect) -> Path {
            _path(rect)
        }
        
        public func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize {
            _sizeThatFits(proposal)
        }
        
        public func inset(by amount: CGFloat) -> Self.InsetShape {
            .init(_inset(amount))
        }
    }
}
