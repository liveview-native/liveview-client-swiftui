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
///         foreground_color(:blue)
///         |> font({:system, :large_title})
///         |> mask(alignment: :center, mask: :mask)
///     }
/// >
///     <Rectangle template={:mask} modifiers={opacity(0.1)} />
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
    /// The alignment in relation to this view. Defaults to `center`
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
    private let mask: String
    
    @ObservedElement private var element
    @LiveContext<R> private var context
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.alignment = try container.decode(Alignment.self, forKey: .alignment)
        self.mask = try container.decode(String.self, forKey: .mask)
    }

    func body(content: Content) -> some View {
        content.mask(alignment: alignment) {
            context.buildChildren(of: element, forTemplate: self.mask)
        }
    }

    enum CodingKeys: String, CodingKey {
        case alignment
        case mask
    }
}
