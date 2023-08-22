//
//  GridColumnAlignmentModifier.swift
//  
//
//  Created by Carson Katri on 2/14/23.
//

import SwiftUI

/// Overrides the alignment of all cells in a column.
///
/// Apply this modifier to any cell in a column to modify the horizontal alignment of all cells within the column.
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
///             modifiers={grid_column_alignment(:trailing)}
///         />
///     </GridRow>
/// </Grid>
/// ```
///
/// With the modifier on the rectangle, the "Color" text and the rectangle will both be aligned to the trailing edge of the column.
///
/// ## Arguments
/// * ``guide``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct GridColumnAlignmentModifier: ViewModifier, Decodable, Equatable {
    /// The horizontal alignment of cells in the column.
    ///
    /// Possible values:
    /// * `leading`
    /// * `center`
    /// * `trailing`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let guide: HorizontalAlignment
    
    func body(content: Content) -> some View {
        content.gridColumnAlignment(guide)
    }
}
