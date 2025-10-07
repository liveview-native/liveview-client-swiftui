//
//  LazyHGrid.swift
//
//
//  Created by Carson Katri on 2/15/23.
//

import SwiftUI
import LightpandaClient

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
struct LazyHGrid<Library: ElementLibrary>: View {
    let node: Node
    
    /// Configured rows to fill with the child elements.
    @_documentation(visibility: public)
    private var rows: [GridItem] {
        node.attributeValue(for: "rows", strategy: GridItemParseStrategy()) ?? []
    }
    /// The alignment between rows.
    @_documentation(visibility: public)
    private var alignment: VerticalAlignment {
        node.attributeValue(for: "alignment", strategy: VerticalAlignmentParseStrategy()) ?? .center
    }
    /// The spacing between rows.
    @_documentation(visibility: public)
    private var spacing: CGFloat? {
        node.attributeValue(for: "spacing", strategy: .number).flatMap(CGFloat.init)
    }
    /// Pins section headers/footers.
    ///
    /// See ``LiveViewNative/SwiftUI/PinnedScrollableViews``.
    @_documentation(visibility: public)
    private var pinnedViews: PinnedScrollableViews {
        node.attributeValue(for: "pinnedViews", strategy: PinnedScrollableViewsParseStrategy()) ?? []
    }

    public var body: some View {
        SwiftUI.LazyHGrid(
            rows: rows,
            alignment: alignment,
            spacing: spacing,
            pinnedViews: pinnedViews
        ) {
            node.children(library: Library.self)
        }
    }
}

struct GridItemParseStrategy: ParseStrategy {
    func parse(_ value: String) throws -> [GridItem] {
        // TODO: implement
        fatalError("todo")
    }
}
