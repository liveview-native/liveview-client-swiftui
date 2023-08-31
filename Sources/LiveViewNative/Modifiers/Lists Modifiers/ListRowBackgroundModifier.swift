//
//  ListRowBackgroundModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/12/2023.
//

import SwiftUI

/// Adds a background to a list row.
///
/// Provide a reference to the background content in the ``content`` argument.
///
/// - Note: This modifier is applied to an element within a ``List``, not the list itself.
///
/// ```html
/// <List>
///     <Text modifiers={list_row_background(content: :my_background)}>
///         ...
///         <Capsule template={:my_background} fill-color="system-red" />
///     </Text>
/// </List>
/// ```
///
/// ## Arguments
/// * ``content``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ListRowBackgroundModifier<R: RootRegistry>: ViewModifier, Decodable {
    /// A reference to the element that contains the background content.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let content: String?
    
    @ObservedElement private var element
    @LiveContext<R> private var context

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.content = try container.decodeIfPresent(String.self, forKey: .content)
    }

    func body(content: Content) -> some View {
        content.listRowBackground(self.content.flatMap({ context.buildChildren(of: element, forTemplate: $0) }))
    }

    enum CodingKeys: String, CodingKey {
        case content
    }
}
