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
/// <Button modifiers={content_shape(:rectangle)}>Click Me!</Button>
/// <Button modifiers={content_shape(:hover_effect, shape: :rectangle)}>Click Me!</Button>
/// <Button modifiers={content_shape([:hover_effect, :interaction], shape: :rectangle, eo_fill: true)}>Click Me!</Button>
/// ```
///
/// ## Arguments
/// * ``kind``
/// * ``shape``
/// * ``eo_fill``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ContentShapeModifier<R: RootRegistry>: ViewModifier, Decodable {
    /// The kinds to apply to this content shape.
    ///
    /// See ``LiveViewNative/SwiftUI/ContentShapeKinds`` for a list possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let kind: ContentShapeKinds
    
    /// The shape to use.
    ///
    /// See ``ShapeReference`` for more details on creating shape arguments.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private var shape: ShapeReference
    
    /// A Boolean that indicates whether the shape is interpreted with the even-odd winding number rule. Default value is `false`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private var eoFill: Bool = false

    @ObservedElement private var element
    @LiveContext<R> private var context

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.kind = try container.decodeIfPresent(ContentShapeKinds.self, forKey: .kind) ?? .interaction
        self.shape = try container.decode(ShapeReference.self, forKey: .shape)
    }

    func body(content: Content) -> some View {
        content.contentShape(
            kind,
            shape.resolve(on: element),
            eoFill: eoFill
        )
    }
    
    enum CodingKeys: String, CodingKey {
        case kind
        case shape
    }
}
