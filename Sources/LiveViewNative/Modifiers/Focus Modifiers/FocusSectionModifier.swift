//
//  FocusSectionModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 5/18/2023.
//

import SwiftUI

/// Groups a section of focusable elements.
///
/// Use this modifier to control the order elements receive focus in.
///
/// In the example below, the default tab ordering would traverse the buttons
/// left to right, top to bottom.
///
/// Applying this modifier to one of the ``VStack`` elements will cause focus
/// to go through each element in the stack before moving across or down.
///
/// ```html
/// <HStack>
///     <VStack modifiers={focus_section([])}>
///         <Button>A</Button>
///         <Button>B</Button>
///         <Button>C</Button>
///     </VStack>
///     <VStack>
///         <Button>D</Button>
///         <Button>E</Button>
///         <Button>F</Button>
///     </VStack>
/// </HStack>
/// ```
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(macOS 13.0, tvOS 16.0, *)
struct FocusSectionModifier: ViewModifier, Decodable {
    func body(content: Content) -> some View {
        content
            #if os(macOS) || os(tvOS)
            .focusSection()
            #endif
    }
}

