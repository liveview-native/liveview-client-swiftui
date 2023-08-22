//
//  PresentationCompactAdaptationModifier.swift
//  
//
//  Created by Carson Katri on 5/23/23.
//

import SwiftUI

/// Customizes how a presentation adapts in a compact size class.
///
/// A modal presentation modifier may choose a different style depending on the size class.
/// For example, the ``PopoverModifier`` modifier will display a sheet on iPhones by default.
///
/// Apply this modifier to the modal presentation's content.
///
/// ```html
/// <Button phx-click="toggle" modifiers={popover(content: :content, is_presented: :show)}>
///   Present Popover
///   <Text
///     template={:content}
///     modifiers={
///       presentation_compact_adaptation(
///         horizontal: :popover,
///         vertical: :full_screen_cover
///       )
///     }
///   >
///     Hello, world!
///   </Text>
/// </Button>
/// ```
///
/// In the example above, the `popover` adaptation is applied to horizontally compact size classes, such as an iPhone in a portrait orientation.
/// The `full_screen_cover` adaptation is applied to vertically compact size classes, such as an iPhone in a landscape orientation.
///
/// ## Arguments
/// * ``horizontal``
/// * ``vertical``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
struct PresentationCompactAdaptationModifier: ViewModifier, Decodable {
    /// The adaptation for horizontally compact size classes.
    ///
    /// See ``LiveViewNative/SwiftUI/PresentationAdaptation`` for a list of possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    let horizontal: PresentationAdaptation
    /// The adaptation for vertically compact size classes.
    /// Takes preference over ``horizontal`` for size classes that are compact in both dimensions.
    ///
    /// See ``LiveViewNative/SwiftUI/PresentationAdaptation`` for a list of possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    let vertical: PresentationAdaptation
    
    func body(content: Content) -> some View {
        content
            .presentationCompactAdaptation(
                horizontal: horizontal,
                vertical: vertical
            )
    }
}

/// An alternate presentation style for compact size classes.
///
/// Possible values:
/// * `automatic`
/// * `none`
/// * `popover`
/// * `sheet`
/// * `full_screen_cover`
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
extension PresentationAdaptation: Decodable {
    public init(from decoder: Decoder) throws {
        switch try decoder.singleValueContainer().decode(String.self) {
        case "automatic": self = .automatic
        case "none": self = .none
        case "popover": self = .popover
        case "sheet": self = .sheet
        case "full_screen_cover": self = .fullScreenCover
        case let `default`: throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Unknown presentation adaptation '\(`default`)'"))
        }
    }
}
