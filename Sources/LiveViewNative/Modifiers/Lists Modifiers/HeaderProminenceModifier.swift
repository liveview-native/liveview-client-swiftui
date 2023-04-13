//
//  HeaderProminenceModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/13/2023.
//

import SwiftUI

/// Sets the prominence of headers in this element.
///
/// Use this modifier on a ``Section`` in a ``List`` to set the prominence of the section's header.
///
/// ```html
/// <List>
///     <Section modifiers={header_prominence(@native, prominence: :increased} id="increased">
///         ...
///     </Section>
///     ...
/// </List>
/// ```
///
/// ## Arguments
/// * ``prominence``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct HeaderProminenceModifier: ViewModifier, Decodable {
    /// The prominence value.
    ///
    /// See ``LiveViewNative/SwiftUI/Prominence`` for a list of possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let prominence: Prominence

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.prominence = try container.decode(Prominence.self, forKey: .prominence)
    }

    func body(content: Content) -> some View {
        content.headerProminence(prominence)
    }

    enum CodingKeys: String, CodingKey {
        case prominence
    }
}

