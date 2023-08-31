//
//  GridCellColumnsModifier.swift
//
//
//  Created by Carson Katri on 2/14/23.
//

import SwiftUI

/// Sets the column span for an element in a grid.
///
/// Apply this modifier to any element in a ``Grid`` to modify how many columns it takes.
///
/// ```html
/// <Grid>
///     <GridRow>
///         <Text>Column 1</Text>
///         <Text>Column 2</Text>
///     </GridRow>
///     <GridRow>
///         <Text modifiers={grid_cell_columns(2)}>
///             Multi-Column Content
///         </Text>
///     </GridRow>
/// </Grid>
/// ```
///
/// ## Arguments
/// * ``count``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct GridCellColumnsModifier: ViewModifier, Decodable, Equatable {
    /// The number of columns to span.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let count: Int
    
    func body(content: Content) -> some View {
        content.gridCellColumns(count)
    }
}
