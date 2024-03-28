//
//  LazyVStack.swift
//
//
//  Created by Carson Katri on 2/9/23.
//

import SwiftUI

/// Vertical stack that creates Views lazily.
///
/// Lazy stacks behave similar to their non-lazy counterparts.
///
/// Use the ``pinnedViews`` attribute to pin section headers/footers when contained in a `ScrollView`.
///
/// ```html
/// <ScrollView axes="vertical">
///     <LazyVStack>
///         <%= for i <- 1..50 do %>
///             <Text id={i |> Integer.to_string} font="largeTitle"><%= i %></Text>
///         <% end %>
///     </LazyVStack>
/// </ScrollView>
/// ```
///
/// ## Attributes
/// * ``alignment``
/// * ``spacing``
/// * ``pinnedViews``
///
/// ## See Also
/// ### Stacks
/// * ``VStack``
@_documentation(visibility: public)
struct LazyVStack<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    /// The horizontal alignment of views within the stack. Defaults to center-aligned.
    ///
    /// See ``LiveViewNative/SwiftUI/VerticalAlignment``.
    @_documentation(visibility: public)
    @Attribute(.init(name: "alignment")) private var alignment: HorizontalAlignment = .center
    /// The spacing between views in the stack. If not provided, the stack uses the system spacing.
    @_documentation(visibility: public)
    @Attribute(.init(name: "spacing")) private var spacing: Double?
    /// Pins section headers/footers.
    ///
    /// See ``LiveViewNative/SwiftUI/PinnedScrollableViews``.
    @_documentation(visibility: public)
    @Attribute(.init(name: "pinnedViews")) private var pinnedViews: PinnedScrollableViews = []
    
    public var body: some View {
        SwiftUI.LazyVStack(
            alignment: alignment,
            spacing: spacing.flatMap(CGFloat.init),
            pinnedViews: pinnedViews
        ) {
            context.buildChildren(of: element)
        }
    }
}
