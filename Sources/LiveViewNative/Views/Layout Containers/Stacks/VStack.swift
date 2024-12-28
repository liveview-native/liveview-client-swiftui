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
/// <VStack alignment="leading">
///     <Text>Top</Text>
///     <Text>Bottom</Text>
/// </VStack>
/// ```
///
/// ## Attributes
/// - ``alignment``
/// - ``spacing``
@_documentation(visibility: public)
@LiveElement
struct VStack<Root: RootRegistry>: View {
    /// The horizontal alignment of views within the stack. Defaults to center-aligned.
    ///
    /// See ``LiveViewNative/SwiftUI/HorizontalAlignment``
    @_documentation(visibility: public)
    private var alignment: HorizontalAlignment = .center
    
    /// The spacing between views in the stack. If not provided, the stack uses the system spacing.
    @_documentation(visibility: public)
    private var spacing: CGFloat?
    
    public var body: some View {
        SwiftUI.VStack(
            alignment: alignment,
            spacing: spacing
        ) {
            $liveElement.children()
        }
    }
}
