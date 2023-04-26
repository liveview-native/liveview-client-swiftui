//
//  CompositingGroupModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/25/23.
//

import SwiftUI

/// Wraps this view in a compositing group.
///
/// A compositing group makes compositing effects in this view’s ancestor views, such as opacity and the blend mode, take effect before this view is rendered.
///
/// ```html
/// <HStack>
///     <ZStack
///         modifier={
///             @native
///                 |> compositing_group()
///                 |> opacity(opacity: 0.5)
///         }
///     >
///         <Text>Hello, world!</Text>
///         <Text modifiers={blur(@native, radius: 2)}>Hello, world!</Text>
///     </ZStack>
/// </HStack>
/// ```
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct CompositingGroupModifier: ViewModifier, Decodable {
    func body(content: Content) -> some View {
        content.compositingGroup()
    }
}
