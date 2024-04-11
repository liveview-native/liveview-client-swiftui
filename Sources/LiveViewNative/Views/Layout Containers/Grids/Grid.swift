//
//  Grid.swift
//
//
//  Created by Carson Katri on 2/14/23.
//

import SwiftUI

/// Align elements along two dimensions.
///
/// Use with ``GridRow`` to create a structured layout of elements.
///
/// ```html
/// <Grid>
///     <GridRow>
///         <Text>Title</Text>
///         <Text>Description</Text>
///     </GridRow>
///     <GridRow>
///         <Text>Item #1</Text>
///         <Text>The first of many items.</Text>
///     </GridRow>
/// </Grid>
/// ```
///
/// ## Attributes
/// * ``alignment``
/// * ``horizontalSpacing``
/// * ``verticalSpacing``
///
/// ## See Also
/// ### Creating Rows
/// * ``GridRow``
///
/// ### Modifying Grids
/// * ``GridCellAnchorModifier``
/// * ``GridCellColumnsModifier``
/// * ``GridCellUnsizedAxesModifier``
/// * ``GridColumnAlignmentModifier``
@_documentation(visibility: public)
@LiveElement
struct Grid<Root: RootRegistry>: View {
    /// The positioning of elements within the grid.
    @_documentation(visibility: public)
    private var alignment: Alignment = .center
    /// The spacing between elements in a ``GridRow``.
    @_documentation(visibility: public)
    private var horizontalSpacing: CGFloat?
    /// The spacing between ``GridRow`` elements.
    @_documentation(visibility: public)
    private var verticalSpacing: CGFloat?
    
    public var body: some View {
        SwiftUI.Grid(
            alignment: alignment,
            horizontalSpacing: horizontalSpacing,
            verticalSpacing: verticalSpacing
        ) {
            $liveElement.children()
        }
    }
}
