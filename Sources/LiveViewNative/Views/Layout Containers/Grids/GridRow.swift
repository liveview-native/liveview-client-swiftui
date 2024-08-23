//
//  GridRow.swift
//
//
//  Created by Carson Katri on 2/14/23.
//

import SwiftUI

/// A row of items in a grid.
///
/// Use with ``Grid`` to define the rows of the grid.
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
///
/// ## See Also
/// ### Creating Grids
/// * ``Grid``
@_documentation(visibility: public)
@LiveElement
struct GridRow<Root: RootRegistry>: View {
    /// The positioning of elements within the row.
    @_documentation(visibility: public)
    private var alignment: VerticalAlignment?

    public var body: some View {
        SwiftUI.GridRow(alignment: alignment) {
            $liveElement.children()
        }
    }
}
