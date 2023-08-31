//
//  AnimationModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/3/2023.
//

import SwiftUI

/// Applies an animation when a value changes.
///
/// Specify a ``value`` that, when changed, will cause animations to occur.
/// Any changes to elements that use the provided value will be automatically animated.
///
/// - Note: The ``value`` must be a string.
///
/// ```html
/// <Rectangle
///   modifiers={animation(value: @color)}
///   fill-color={@color}
/// />
/// ```
///
/// In this example, whenever the `@color` assign changes, the rectangle will animate to the new color.
///
/// The animation that is used can also be customized with the ``animation`` argument.
///
/// ```html
/// <Rectangle
///   modifiers={animation(animation: :ease_out, value: @color)}
///   fill-color={@color}
/// />
/// ```
///
/// See ``LiveViewNative/SwiftUI/Animation`` for more details on what animations are available.
///
/// ## Arguments
/// * ``animation``
/// * ``value``
///
/// ## See Also
/// ### Creating Animations
/// * ``LiveViewNative/SwiftUI/Animation``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct AnimationModifier: ViewModifier, Decodable {
    /// The animation to apply.
    ///
    /// See ``LiveViewNative/SwiftUI/Animation`` for more information on creating animations.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let animation: Animation

    /// The value to observe for changes.
    ///
    /// The provided animation will be used when this value changes.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let value: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.animation = try container.decodeIfPresent(Animation.self, forKey: .animation) ?? .default

        self.value = try container.decodeIfPresent(String.self, forKey: .value) ?? ""
    }

    func body(content: Content) -> some View {
        content.animation(animation, value: value)
    }

    enum CodingKeys: String, CodingKey {
        case animation
        case value
    }
}
