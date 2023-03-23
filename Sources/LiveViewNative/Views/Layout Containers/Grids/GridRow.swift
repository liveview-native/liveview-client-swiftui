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
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct GridRow<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    /// The positioning of elements within the row.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("alignment") private var alignment: VerticalAlignment?

    public var body: some View {
        SwiftUI.GridRow(alignment: alignment) {
            context.buildChildren(of: element)
        }
    }
}
