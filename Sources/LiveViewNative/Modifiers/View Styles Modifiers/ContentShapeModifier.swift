//
//  ContentShapeModifier.swift
//  
//
//  Created by murtza on 24/05/2023.
//

import SwiftUI

/// Sets the content shape for this view.
///
/// ```html
/// <HStack modifiers={content_shape(@native, shape: :rectangle)}>
///   <Image system-name="heart.circle"></Image>
/// </HStack>
///
/// <HStack modifiers={content_shape(@native, kind: :hover_effect, shape: :rectangle)}>
///   <Image system-name="heart.circle"></Image>
/// </HStack>
///
/// <HStack modifiers={content_shape(@native, kind: [:hover_effect, :interaction], shape: :rectangle, eo_fill: true)}>
///   <Image system-name="heart.circle"></Image>
/// </HStack>
/// ```
///
/// ## Arguments
/// * ``kind``
/// * ``shape``
/// * ``eo_fill``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ContentShapeModifier: ViewModifier, Decodable {
    /// The kinds to apply to this content shape.
    ///
    /// See ``LiveViewNative/SwiftUI/ContentShapeKinds`` for a list possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let kind: ContentShapeKinds?
    
    /// The shape to use.
    ///
    /// Possible values:
    /// * `capsule`
    /// * `circle`
    /// * `container_relative_shape`
    /// * `ellipse`
    /// * `rectangle`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private var shape: ShapeKind
    
    /// A Boolean that indicates whether the shape is interpreted with the even-odd winding number rule. Default value is `false`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private var eoFill: Bool = false

    func body(content: Content) -> some View {
        let kind = kind ?? []
        
        switch shape {
        case .capsule:
            content.contentShape(kind, Capsule(), eoFill: eoFill)
        case .circle:
            content.contentShape(kind, Circle(), eoFill: eoFill)
        case .containerRelativeShape:
            content.contentShape(kind, ContainerRelativeShape(), eoFill: eoFill)
        case .ellipse:
            content.contentShape(kind, Ellipse(), eoFill: eoFill)
        case .rectangle:
            content.contentShape(kind, Rectangle(), eoFill: eoFill)
        }
    }
}

/// The shape kind to use.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
private enum ShapeKind: String, Decodable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case capsule
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case circle
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case containerRelativeShape = "container_relative_shape"
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case ellipse
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case rectangle
}
