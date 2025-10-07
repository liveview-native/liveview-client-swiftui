//
//  Grid.swift
//
//
//  Created by Carson Katri on 2/14/23.
//

import SwiftUI
import LightpandaClient

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
struct Grid<Library: ElementLibrary>: View {
    let node: Node
    
    /// The positioning of elements within the grid.
    @_documentation(visibility: public)
    private var alignment: Alignment {
        node.attributeValue(for: "alignment", strategy: AlignmentParseStrategy()) ?? .center
    }
    /// The spacing between elements in a ``GridRow``.
    @_documentation(visibility: public)
    private var horizontalSpacing: CGFloat? {
        node.attributeValue(for: "horizontalSpacing", strategy: .number).flatMap(CGFloat.init)
    }
    /// The spacing between ``GridRow`` elements.
    @_documentation(visibility: public)
    private var verticalSpacing: CGFloat? {
        node.attributeValue(for: "verticalSpacing", strategy: .number).flatMap(CGFloat.init)
    }
    
    public var body: some View {
        SwiftUI.Grid(
            alignment: alignment,
            horizontalSpacing: horizontalSpacing,
            verticalSpacing: verticalSpacing
        ) {
            node.children(library: Library.self)
        }
    }
}
