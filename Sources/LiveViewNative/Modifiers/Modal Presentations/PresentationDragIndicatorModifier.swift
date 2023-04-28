//
//  PresentationDragIndicatorModifier.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 4/28/23.
//

import SwiftUI

/// A modifier that specifies the visibility of the drag handle on a sheet-presented view.
///
/// Use this modifier in the content of a ``SheetModifier``.
///
/// ```html
/// <Button phx-click="toggle" modifiers={sheet(@native, content: :content, on_dismiss: "dismiss", is_presented: :show)}>
///   Present Sheet
///
///   <sheet:content>
///     <VStack modifiers={presentation_drag_indicator(@native, visibility: :visible)}>
///       <Text>Hello, world!</Text>
///       <Button phx-click="toggle">Dismiss</Button>
///     </VStack>
///   </sheet:content>
/// </Button>
/// ```
///
/// ## Attributes
/// - ``visibility``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct PresentationDragIndicatorModifier: ViewModifier, Decodable {
    /// Whether the drag indicator is shown.
    ///
    /// See ``LiveViewNative/SwiftUI/Visibility``
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let visibility: Visibility

    func body(content: Content) -> some View {
        content.presentationDragIndicator(visibility)
    }
}
