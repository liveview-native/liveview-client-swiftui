//
//  ZStack.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 8/31/22.
//

import SwiftUI

/// A container that lays out elements on top of each other, back to front.
///
/// ```html
/// <ZStack>
///     <Text>Back</Text>
///     <Text>Front</Text>
/// </ZStack>
/// ```
///
/// ## Attributes
/// - ``alignment``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ZStack<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    /// The alignment in both axes of views within the stack. Defaults to center-aligned.
    ///
    /// See ``LiveViewNative/SwiftUI/Alignment``.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("alignment") private var alignment: Alignment = .center
    
    public var body: some View {
        SwiftUI.ZStack(alignment: alignment) {
            context.buildChildren(of: element)
        }
    }
}
