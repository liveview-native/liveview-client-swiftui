//
//  VStack.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 8/31/22.
//

import SwiftUI

/// Container that lays out its children in a vertical line.
///
/// ```html
/// <VStack>
///     <Text>Top</Text>
///     <Text>Bottom</Text>
/// </VStack>
/// ```
///
/// ## Attributes
/// - ``alignment``
/// - ``spacing``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct VStack<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    /// The horizontal alignment of views within the stack. Defaults to center-aligned.
    ///
    /// See ``LiveViewNative/SwiftUI/HorizontalAlignment``
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("alignment") private var alignment: HorizontalAlignment = .center
    /// The spacing between views in the stack. If not provided, the stack uses the system spacing.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("spacing") private var spacing: Double?
    
    public var body: some View {
        SwiftUI.VStack(
            alignment: alignment,
            spacing: spacing.flatMap(CGFloat.init)
        ) {
            context.buildChildren(of: element)
        }
    }
}
