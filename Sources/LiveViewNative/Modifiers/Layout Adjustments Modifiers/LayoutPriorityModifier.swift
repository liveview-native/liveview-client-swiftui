//
//  LayoutPriorityModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/13/2023.
//

import SwiftUI

/// Sets the priority of an element.
///
/// Every element has a default priority of `0`. This modifier allows you to set the priority to a custom value.
///
/// By default, the two text elements in the example below would be given an equal amount of space.
/// However, by setting the priority of the second text to `1` it will take up all of the space it needs to fit without wrapping, causing the first text to wrap.
///
/// ```html
/// <HStack>
///     <Text>Long string with a default priority of 0</Text>
///     <Text modifiers={layout_priority(1)}>
///         Long string with higher layout priority of 1
///     </Text>
/// </HStack>
/// ```
///
/// ## Arguments
/// * ``value``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct LayoutPriorityModifier: ViewModifier, Decodable {
    /// The priority value.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let value: Double

    func body(content: Content) -> some View {
        content.layoutPriority(value)
    }
}

