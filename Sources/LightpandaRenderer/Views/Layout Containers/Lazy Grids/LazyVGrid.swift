//
//  LazyVGrid.swift
//
//
//  Created by Carson Katri on 2/15/23.
//

import SwiftUI
import LightpandaClient

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
struct LazyVGrid<Library: ElementLibrary>: View {
    let node: Node
    
    /// Configured columns to fill with the child elements.
    @_documentation(visibility: public)
    private var columns: [GridItem] {
        node.attributeValue(for: "columns", strategy: GridItemParseStrategy()) ?? []
    }
    /// The alignment between columns.
    @_documentation(visibility: public)
    private var alignment: HorizontalAlignment {
        node.attributeValue(for: "alignment", strategy: HorizontalAlignmentParseStrategy()) ?? .center
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
        SwiftUI.LazyVGrid(
            columns: columns,
            alignment: alignment,
            spacing: spacing,
            pinnedViews: pinnedViews
        ) {
            node.children(library: Library.self)
        }
    }
}

struct HorizontalAlignmentParseStrategy: ParseStrategy {
    func parse(_ value: String) throws -> HorizontalAlignment {
        switch value {
        case "leading":
            return .leading
        case "center":
            return .center
        case "trailing":
            return .trailing
        case "listRowSeparatorLeading":
            return .listRowSeparatorLeading
        case "listRowSeparatorTrailing":
            return .listRowSeparatorTrailing
        default:
            throw ParseError()
        }
    }
}
