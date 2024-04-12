//
//  LazyHGrid.swift
//
//
//  Created by Carson Katri on 2/15/23.
//

import SwiftUI

/// Grid that grows horizontally.
///
/// Use the ``rows`` attribute to configure the presentation of the grid.
///
/// ```html
/// <LazyHGrid
///     rows={[
///         %{ size: %{ fixed: 100 } },
///         %{ size: :flexible },
///         %{ size: %{ adaptive: %{ minimum: 50 } } }
///     ]}
/// >
///     <%= for i <- 1..50 do %>
///         <Text id={i |> Integer.to_string}><%= i %></Text>
///     <% end %>
/// </LazyHGrid>
/// ```
///
/// There are 3 types of grid item:
/// * `fixed(size, spacing, alignment)`: creates a single row that takes up the specified amount of space.
/// * `flexible(minimum, maximum, spacing, alignment)`: creates a single row that fills the available space.
/// * `adaptive(minimum, maximum, spacing, alignment)`: fills the available space with as many rows as will fit.
///
/// ## Attributes
/// * ``rows``
/// * ``alignment``
/// * ``spacing``
/// * ``pinnedViews``
@_documentation(visibility: public)
@LiveElement
struct LazyHGrid<Root: RootRegistry>: View {
    /// Configured rows to fill with the child elements.
    @_documentation(visibility: public)
    private var rows: [GridItem] = []
    /// The alignment between rows.
    @_documentation(visibility: public)
    private var alignment: VerticalAlignment = .center
    /// The spacing between rows.
    @_documentation(visibility: public)
    private var spacing: CGFloat?
    /// Pins section headers/footers.
    ///
    /// See ``LiveViewNative/SwiftUI/PinnedScrollableViews``.
    @_documentation(visibility: public)
    private var pinnedViews: PinnedScrollableViews = []

    public var body: some View {
        SwiftUI.LazyHGrid(
            rows: rows,
            alignment: alignment,
            spacing: spacing,
            pinnedViews: pinnedViews
        ) {
            $liveElement.children()
        }
    }
}
