//
//  HStack.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 8/31/22.
//

import SwiftUI

/// Container that lays out its children in a horizontal line.
///
/// ```html
/// <HStack>
///     <Text>Leading</Text>
///     <Spacer />
///     <Text>Trailing</Text>
/// </HStack>
/// ```
///
/// ## Attributes
/// - ``alignment``
/// - ``spacing``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct HStack<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    /// The vertical alignment of views within the stack. Defaults to center-aligned.
    ///
    /// See ``LiveViewNative/SwiftUI/VerticalAlignment``.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("alignment") private var alignment: VerticalAlignment = .center
    /// The spacing between views in the stack. If not provided, the stack uses the system spacing.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("spacing") private var spacing: Double?
    
    public var body: some View {
        SwiftUI.HStack(
            alignment: alignment,
            spacing: spacing.flatMap(CGFloat.init)
        ) {
            context.buildChildren(of: element)
        }
    }
}
