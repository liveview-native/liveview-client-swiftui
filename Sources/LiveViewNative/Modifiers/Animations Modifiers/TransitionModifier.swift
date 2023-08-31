//
//  TransitionModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/5/2023.
//

import SwiftUI

/// Applies a transition when an element is inserted or removed.
///
/// Specify a ``transition`` to apply to the element.
///
/// ```html
/// <%= if @show do %>
///     <Text modifiers={transition(:scale)}>Scaled</Text>
/// <% end %>
/// ```
///
/// In this example, whenever the `<Text>` element is shown/hidden it will scale up/down.
///
/// See ``LiveViewNative/SwiftUI/AnyTransition`` for more details on what transitions are available.
///
/// ## Arguments
/// * ``transition``
///
/// ## See Also
/// ### Creating Transitions
/// * ``LiveViewNative/SwiftUI/AnyTransition``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct TransitionModifier<R: RootRegistry>: ViewModifier, Decodable {
    /// The transition to apply.
    ///
    /// See ``LiveViewNative/SwiftUI/AnyTransition`` for more information on creating transitions.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let transition: AnyTransition

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.transition = (try? AnyTransition(from: container.nestedContainer(keyedBy: AnyTransition.CodingKeys.self, forKey: .transition), in: R.self)) ?? .identity
    }

    func body(content: Content) -> some View {
        content.transition(transition)
    }

    enum CodingKeys: String, CodingKey {
        case transition
    }
}
