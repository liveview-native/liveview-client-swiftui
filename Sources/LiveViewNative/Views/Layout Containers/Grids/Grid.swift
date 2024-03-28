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
struct Grid<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    /// The positioning of elements within the grid.
    @_documentation(visibility: public)
    @Attribute(.init(name: "alignment")) private var alignment: Alignment = .center
    /// The spacing between elements in a ``GridRow``.
    @_documentation(visibility: public)
    @Attribute(.init(name: "horizontalSpacing")) private var horizontalSpacing: Double?
    /// The spacing between ``GridRow`` elements.
    @_documentation(visibility: public)
    @Attribute(.init(name: "verticalSpacing")) private var verticalSpacing: Double?
    
    public var body: some View {
        SwiftUI.Grid(
            alignment: alignment,
            horizontalSpacing: horizontalSpacing.flatMap(CGFloat.init),
            verticalSpacing: verticalSpacing.flatMap(CGFloat.init)
        ) {
            context.buildChildren(of: element)
        }
    }
}
