//
//  MaskModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/27/23.
//

import SwiftUI

/// Masks this view using the alpha channel of the given view.
///
/// ```html
/// <Image system-name="envelope.badge.fill"
///     modifiers={
///         @native
///         |> foreground_color(color: :blue)
///         |> font(font: {:system, :large_title})
///         |> mask(alignment: :center, content: :rectangle)
///     }
/// >
///     <mask:rectangle>
///         <Rectangle modifiers={@native |> opacity(opacity: 0.1)} />
///     </mask:rectangle>
/// </Image>
/// ```
///
/// ## Arguments
/// * ``alignment``
/// * ``content``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct MaskModifier<R: RootRegistry>: ViewModifier, Decodable {
    /// The alignment in relation to this view.
    ///
    /// See ``LiveViewNative/SwiftUI/Alignment``.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let alignment: Alignment

    /// The reference to the view whose alpha the rendering system applies to the specified view.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let content: String
    
    @ObservedElement private var element
    @LiveContext<R> private var context
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.alignment = try container.decode(Alignment.self, forKey: .alignment)
        self.content = try container.decode(String.self, forKey: .content)
    }

    func body(content: Content) -> some View {
        content.mask(alignment: alignment) {
            context.buildChildren(of: element, withTagName: self.content, namespace: "mask")
        }
    }

    enum CodingKeys: String, CodingKey {
        case alignment
        case content
    }
}
