//
//  GridCellAnchorModifier.swift
//
//
//  Created by Carson Katri on 2/14/23.
//

import SwiftUI

/// Changes the anchor point of an element in a grid.
///
/// Apply this modifier to any element in a ``Grid`` to change its positioning in the cell area.
///
/// ```html
/// <Grid>
///     <GridRow>
///         <Text modifiers={grid_cell_anchor({0.5, 1})}>
///             Customized cell anchor
///         </Text>
///     </GridRow>
/// </Grid>
/// ```
///
/// ## Arguments
/// * ``anchor``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct GridCellAnchorModifier: ViewModifier, Decodable, Equatable {
    /// The modified cell anchor value.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content.gridCellAnchor(anchor)
    }
}
