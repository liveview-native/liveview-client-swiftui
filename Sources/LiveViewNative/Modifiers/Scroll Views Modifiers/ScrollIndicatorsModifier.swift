//
//  ScrollIndicatorsModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/28/23.
//

import SwiftUI

/// Sets the visibility of scroll indicators within this view.
///
/// ```html
/// <List modifiers={scroll_indicators(:visible, axis: :vertical)}>
///     <Text>One</Text>
///     <Text>Two</Text>
///     <Text>Three</Text>
///     ...
/// </List>
/// ```
///
/// ## Arguments
/// * ``visibility``
/// * ``axes``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ScrollIndicatorsModifier: ViewModifier, Decodable {
    /// The visibility to apply to scrollable views.
    ///
    /// See ``LiveViewNative/SwiftUI/ScrollIndicatorVisibility`` for a list of possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let visibility: ScrollIndicatorVisibility
    
    /// The axes of scrollable views that the visibility applies to. Defaults to `all`.
    ///
    /// See ``LiveViewNative/SwiftUI/Axis/Set`` for a list of possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let axes: Axis.Set
    
    func body(content: Content) -> some View {
        content.scrollIndicators(visibility, axes: axes)
    }
}
