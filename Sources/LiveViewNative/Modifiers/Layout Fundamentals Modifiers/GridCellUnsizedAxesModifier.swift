//
//  GridCellUnsizedAxesModifier.swift
//
//
//  Created by Carson Katri on 2/14/23.
//

import SwiftUI

/// Prevents grid cells from filling the available space.
///
/// When using flexible Views in a grid (such as a shape) use ``GridCellUnsizedAxesModifier`` to prevent it from expanding the grid beyond what other elements require.
///
/// ```html
/// <Grid>
///     <GridRow>
///         <Text>Name</Text>
///         <Text>Color</Text>
///     </GridRow>
///     <GridRow>
///         <Text>Ocean Blue</Text>
///         <Rectangle
///             fill-color="system-blue"
///             modifiers={grid_cell_unsized_axes(:all)}
///         />
///     </GridRow>
/// </Grid>
/// ```
///
/// Without the modifier, the rectangle would cause the grid to fill all of the available space.
/// With the modifier, the size of the rectangle matches the height of the "Ocean Blue" text, and the width of the "Color" text.
///
/// ## Arguments
/// * ``axes``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct GridCellUnsizedAxesModifier: ViewModifier, Decodable, Equatable {
    /// The axes the element will not expand to fill.
    ///
    /// Possible values:
    /// * `horizontal`
    /// * `vertical`
    /// * `all`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let axes: Axis.Set
    
    func body(content: Content) -> some View {
        content.gridCellUnsizedAxes(axes)
    }
}
