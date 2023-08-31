//
//  ContentTransitionModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/5/2023.
//

import SwiftUI

/// Applies a transition when an element's content changes.
///
/// Specify a ``transition`` to apply to the element.
///
/// ```html
/// <Text
///   modifiers={
///     content_transition(:numeric_text)
///       |> animation(value: @count)
///   }
/// >
///   <%= @count %>
/// </Text>
/// ```
///
/// In this example, whenever the text content changes it will fade between the new numbers.
///
/// See ``LiveViewNative/SwiftUI/ContentTransition`` for more details on what content transitions are available.
///
/// ## Arguments
/// * ``transition``
///
/// ## See Also
/// ### Creating Content Transitions
/// * ``LiveViewNative/SwiftUI/ContentTransition``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ContentTransitionModifier: ViewModifier, Decodable {
    /// The transition to apply.
    ///
    /// See ``LiveViewNative/SwiftUI/ContentTransition`` for more information on creating content transitions.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let transition: ContentTransition

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.transition = try container.decodeIfPresent(ContentTransition.self, forKey: .transition) ?? .identity
    }

    func body(content: Content) -> some View {
        content.contentTransition(transition)
    }

    enum CodingKeys: String, CodingKey {
        case transition
    }
}
