//
//  TransitionModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/5/2023.
//

import SwiftUI

/// Applies a transition when an element is inserted or removed.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct TransitionModifier: ViewModifier, Decodable {
    /// The transition to apply.
    ///
    /// See ``LiveViewNative/SwiftUI/AnyTransition`` for more information on creating transitions.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let transition: AnyTransition

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.transition = try container.decodeIfPresent(AnyTransition.self, forKey: .transition) ?? .identity
    }

    func body(content: Content) -> some View {
        content.transition(transition)
    }

    enum CodingKeys: String, CodingKey {
        case transition
    }
}
