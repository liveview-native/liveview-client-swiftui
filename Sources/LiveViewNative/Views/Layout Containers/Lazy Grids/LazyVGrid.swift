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
///         %{ size: %{ fixed: 100 } },
///         %{ size: :flexible },
///         %{ size: %{ adaptive: %{ minimum: 50 } } }
///     ]}
/// >
///     <%= for i <- 1..50 do %>
///         <Text id={i |> Integer.to_string}><%= i %></Text>
///     <% end %>
/// </LazyVGrid>
/// ```
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
@LiveElement
struct LazyVGrid<Root: RootRegistry>: View {
    /// Configured columns to fill with the child elements.
    @_documentation(visibility: public)
    private var columns: [GridItem] = []
    /// The alignment between columns.
    @_documentation(visibility: public)
    private var alignment: HorizontalAlignment = .center
    /// The spacing between rows.
    @_documentation(visibility: public)
    private var spacing: CGFloat?
    /// Pins section headers/footers.
    ///
    /// See ``LiveViewNative/SwiftUI/PinnedScrollableViews``.
    @_documentation(visibility: public)
    private var pinnedViews: PinnedScrollableViews = []
    
    public var body: some View {
        SwiftUI.LazyVGrid(
            columns: columns,
            alignment: alignment,
            spacing: spacing,
            pinnedViews: pinnedViews
        ) {
            $liveElement.children()
        }
    }
}
