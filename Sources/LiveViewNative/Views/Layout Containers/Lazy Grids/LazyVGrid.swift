//
//  LazyVGrid.swift
//
//
//  Created by Carson Katri on 2/15/23.
//

import SwiftUI

/// Grid that grows vertically.
///
/// Use the ``columns`` attribute to configure the presentation of the grid.
///
/// ```html
/// <LazyVGrid
///     columns={[
///         LiveViewNative.SwiftUI.Types.GridItem.fixed(100),
///         LiveViewNative.SwiftUI.Types.GridItem.flexible(),
///         LiveViewNative.SwiftUI.Types.GridItem.adaptive(50),
///     ] |> Jason.encode!}
/// >
///     <%= for i <- 1..50 do %>
///         <Text id={i |> Integer.to_string}><%= i %></Text>
///     <% end %>
/// </LazyVGrid>
/// ```
///
/// - Precondition: The ``columns`` attribute must be JSON encoded.
///
/// There are 3 types of grid item:
/// * `fixed(size, spacing, alignment)`: creates a single column that takes up the specified amount of space.
/// * `flexible(minimum, maximum, spacing, alignment)`: creates a single column that fills the available space.
/// * `adaptive(minimum, maximum, spacing, alignment)`: fills the available space with as many columns as will fit.
///
/// ## Attributes
/// * ``columns``
/// * ``alignment``
/// * ``spacing``
/// * ``pinnedViews``
@_documentation(visibility: public)
struct LazyVGrid<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    /// Configured columns to fill with the child elements.
    ///
    /// - Precondition: The value of the attribute must be JSON encoded.
    @_documentation(visibility: public)
    @Attribute(
        "columns",
        transform: {
            guard let value = $0?.value?.data(using: .utf8) else { throw AttributeDecodingError.missingAttribute([GridItem].self) }
            return try makeJSONDecoder().decode([GridItem].self, from: value)
        }
    ) private var columns: [GridItem]
    /// The alignment between columns.
    @_documentation(visibility: public)
    @Attribute("alignment") private var alignment: HorizontalAlignment = .center
    /// The spacing between rows.
    @_documentation(visibility: public)
    @Attribute("spacing") private var spacing: Double?
    /// Pins section headers/footers.
    ///
    /// See ``LiveViewNative/SwiftUI/PinnedScrollableViews``.
    @_documentation(visibility: public)
    @Attribute("pinnedViews") private var pinnedViews: PinnedScrollableViews = []
    
    public var body: some View {
        SwiftUI.LazyVGrid(
            columns: columns,
            alignment: alignment,
            spacing: spacing.flatMap(CGFloat.init),
            pinnedViews: pinnedViews
        ) {
            context.buildChildren(of: element)
        }
    }
}
